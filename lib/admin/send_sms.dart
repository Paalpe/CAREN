import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SendSMSPage extends StatefulWidget {
  SendSMSPage({Key? key}) : super(key: key);

  @override
  State<SendSMSPage> createState() => _SendSMSPageState();
}

class _SendSMSPageState extends State<SendSMSPage> {
// add controller to textfield
  final TextEditingController _controller = TextEditingController();

  var statusText = [TypewriterAnimatedText("bib boop")];

  var countbeforSend = 5;

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
            : () {
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

                setState(() {});
              },
        label: Text(countbeforSend == 0 ? '_-_-_' : 'Send SMS'),
        icon: Icon(Icons.sms_rounded),
      ),
    );
  }
}
