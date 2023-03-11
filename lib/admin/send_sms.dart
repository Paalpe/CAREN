import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class SendSMSPage extends StatefulWidget {
  SendSMSPage({Key? key}) : super(key: key);

  @override
  State<SendSMSPage> createState() => _SendSMSPageState();
}

class _SendSMSPageState extends State<SendSMSPage> {
  final db = FirebaseFirestore.instance;
// add controller to textfield
  final TextEditingController _controller = TextEditingController();

  var statusText = [TypewriterAnimatedText("bib boop")];

  List<String> phones = [];
  List<List<dynamic>> phoneSendt = [];
  List<List<dynamic>> phoneFailed = [];

  var countbeforSend = 5;

  Future<List<String>> getListOfPhones() async {
    final response = await http.get(
        Uri.parse('https://us-central1-caren-nga-23.cloudfunctions.net/helloWorld'),
        headers: {'Authorization': 'Bearer ${_controller.text}'});

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      print(jsonData["phoneList"]);
      return (jsonData['phoneList'] as List)
          .map((item) => item as String)
          .toList();
    } else {
      print(response.reasonPhrase);
      return ["Noe gikk galt!!"];
    }
  }

  sendABatchOfSMS(List<dynamic> numbers) async {
    // List<int> randomNumbers =
    //     List.generate(200, (index) => Random().nextInt(1000));
    // Send a batch of SMS 50 at a time to avoid hitting the rate limit of 100 SMS per second

    for (int i = 0; i < numbers.length; i += 50) {
      final batch = db.batch();
      List<dynamic> phonesToSend = [];
      if (i + 50 > numbers.length) {
        phonesToSend = numbers.sublist(i);
      } else {
        phonesToSend = numbers.sublist(i, i + 50);
      }
      for (var phone in phonesToSend) {
        final docRef = db.collection('messages').doc();
        batch.set(docRef, {
          'phone': phone,
          'body': _controller.text,
        });
      }



      batch.commit().then((_) {
        print('Batch committed successfully.');
        phoneSendt.add(phonesToSend);
        setState(() {
          statusText = [
            TypewriterAnimatedText(
                "Sendt ${phoneSendt.length * 50} (ish) av ${phones.length} meldinger")
          ];
        });
      }).catchError((error) {
        print('Error: $error');
        phoneFailed.add(phonesToSend);
        // add them to clipboard
        Clipboard.setData(ClipboardData(text: phoneFailed.toString()));
        setState(() {
          statusText = [TypewriterAnimatedText("Noe gikk galt")];
        });
      });

      await Future.delayed(Duration(seconds: 2));

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.red[50],
        backgroundColor: Colors.redAccent[400],
        title: Text('Send SMS'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
                'Her kan du sende SMS til alle spillere. Skriv inn meldingen du vil sende, og trykk på "Send SMS"'),
            SizedBox(
              height: 16,
            ),
            SizedBox(
              height: 200,
              width: double.infinity,
              child: TextField(
                expands: true,
                maxLength: 320,
                maxLines: null,
                minLines: null,
                keyboardType: TextInputType.multiline,
                selectionHeightStyle: BoxHeightStyle.max,
                controller: _controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Skriv inn meldingen du vil sende',
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            AnimatedTextKit(
                key: Key(countbeforSend.toString()),
                isRepeatingAnimation: false,
                animatedTexts: statusText),

            // if (countbeforSend == 0)
            // FutureBuilder(
            //   future: Future,
            //   initialData: InitialData,
            //   builder: (BuildContext context, AsyncSnapshot snapshot) {
            //     return Text(snapshot.data);
            //   },
            // ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: countbeforSend == 0
            ? null
            : () async {
                countbeforSend--;
                statusText = [
                  TypewriterAnimatedText(
                      "Sending SMS in $countbeforSend tapp(s)..."),
                ];

                if (countbeforSend == 0) {
                  statusText = [
                    TypewriterAnimatedText("Sending SMS..."),
                  ];
                  // send SMS
                  Clipboard.setData(ClipboardData(text: _controller.text));
                  statusText = [
                    TypewriterAnimatedText("SMS sent!"),
                  ];
                }
                if (phones.isEmpty) {
                  phones = await getListOfPhones();
                  setState(() {
                    statusText = [
                      TypewriterAnimatedText(
                          "Got list of phones -> ${phones.length} students"),
                      // TypewriterAnimatedText(phones.toString()),
                    ];
                  });

                }

                if (countbeforSend == 0 && phones.isNotEmpty) {
                  // await sendABatchOfSMS(List.generate(200, (index) => Random().nextInt(1000)));
                   await sendABatchOfSMS(phones);
                }

                setState(() {});
              },
        label: Text(countbeforSend == 0 ? '_-_-_' : 'Send SMS'),
        icon: Icon(Icons.sms_rounded),
      ),
    );
  }
}
