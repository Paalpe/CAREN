import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:caren/admin/send_sms.dart';
import 'package:flutter/material.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final TextStyle robotStyle = TextStyle(
    //   fontSize: 16,
    //   fontWeight: FontWeight.w500,
    // );

    return Scaffold(
        appBar: AppBar(
          title: Text('Admin Home'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            // create a list of buttons directing to different pages "Send SMS", "Send Email", "Add Games", "Add Players"
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 32),
                height: 140,
                child: Center(
                  child: AnimatedTextKit(
                    isRepeatingAnimation: false,
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Bib boop -> Velkommen s sje sjef!',
                      ),
                      TypewriterAnimatedText(
                        'Forhåpentligvis er du sjef!',
                      ),
                      TypewriterAnimatedText(
                          "Hvis ikke, så er det ikke noe problem, du kan bare trykke på '<' Her oppe"),
                      TypewriterAnimatedText(
                          "Her kan du sende SMS til alle spillere, sende e-post til alle spillere, legge til spill og legge til spillere. __tror jeg.")
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 16),
                height: 100,
                child: TextButton.icon(
                  onPressed: () {
                    //navigate to send sms page SendSMSPage()
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SendSMSPage()));
                  },
                  icon: Icon(
                    Icons.sms,
                    color: Colors.red,
                  ),
                  label: Text(
                    'SEND_SMS ("Bib boop")',
                    // style: robotStyle,
                  ),
                ),
              ),
              // add a button to send email to all players
              Container(
                margin: EdgeInsets.symmetric(vertical: 16),
                height: 100,
                child: TextButton.icon(
                  // onPressed: () {
                  //   Navigator.pushNamed(context, '/send_email');
                  // },
                  onPressed: null,
                  icon: Icon(Icons.email),
                  label: Text('Send Email'),
                ),
              ),
              // check results of games
              Container(
                margin: EdgeInsets.symmetric(vertical: 16),
                height: 100,
                child: TextButton.icon(
                  // onPressed: () {
                  //   Navigator.pushNamed(context, '/check_results');
                  // },
                  onPressed: null,
                  icon: Icon(Icons.bar_chart_sharp),
                  label: Text('Check Results'),
                ),
              ),
            ],
          ),
        ));
  }
}
