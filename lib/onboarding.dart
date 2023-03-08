import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final _formKey = GlobalKey<FormState>();
  final namecontroller = TextEditingController();
  final phonecontroller = TextEditingController();
  final codecontroller = TextEditingController();

  bool claimingTicket = false;
  bool smsCodeSent = false;
  bool loading = false;
  String userDisplayName = '';
  String phoneNumber = '';
  String buttonText = 'CLAIM YOUR TICKET';
  String verificationId = '';

  List<TypewriterAnimatedText> animatedTextList = [
    TypewriterAnimatedText('\nPlay games ->>> Win prizes'),
    TypewriterAnimatedText('\n60 new games to try out'),
    TypewriterAnimatedText('\nDont forget to bring your friends'),
    TypewriterAnimatedText('\nIts gonna be a blast!'),
  ];

  _continueButton() async {
    claimingTicket = true;
    // check if form is valid
    if (!_formKey.currentState!.validate()) {
      return;
    }

    userDisplayName = namecontroller.text;
    phoneNumber = phonecontroller.text;

    // 1.0  click on the button
    if (buttonText == 'CLAIM YOUR TICKET') {
      setState(() {
        buttonText = 'CONFIRM';
        animatedTextList = [
          TypewriterAnimatedText('Let\'s get started! \n\nWhat is your name?'),
        ];
      });
    }

    // 2.0 after the user has given name, ask for phone number
    if (userDisplayName != "") {
      setState(() {
        buttonText = 'SEND SMS-CODE';
        animatedTextList = [
          TypewriterAnimatedText(
              '${userDisplayName.contains(" ") ? userDisplayName.split(" ").first : userDisplayName}? \nNice!\n \nWhat is your phonenumber?',
              textAlign: TextAlign.start),
        ];
      });
    }

    // 3.0 sending sms code to phone number
    if (userDisplayName != '' && phoneNumber != '' && verificationId == '') {
      setState(() => {
            loading = true,
            animatedTextList = [
              TypewriterAnimatedText(
                  'SENDING _ . . .  _-_-_-\n dailing ${phoneNumber.contains("+") ? phoneNumber : ("+47$phoneNumber")}. \n are you there?'),
            ]
          });
      try {
        await FirebaseAuth.instance
            .signInWithPhoneNumber(
                phoneNumber.contains("+") ? phoneNumber : ("+47$phoneNumber"))
            .then((value) => {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        "📬 SMS code sent to ${phoneNumber.contains("+") ? phoneNumber : ("+47$phoneNumber")} "),
                  )),
                  setState(() {
                    animatedTextList = [
                      TypewriterAnimatedText(
                          'Enter the code you recieved in the SMS'),
                    ];
                    verificationId = value.verificationId;
                    smsCodeSent = true;
                    buttonText = 'GET YOUR TICKET';
                    loading = false;
                  })
                });
      } on FirebaseAuthException catch (e) {
        setState(() {
          animatedTextList = [
            TypewriterAnimatedText(
                '. . .  Smoething went wrong! \n Please try again'),
          ];
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("SMS not sendt. Error: ${e.message}")));
      }
    }

    // 4.0 logging inn with sms code recieved
    if (verificationId != '' && codecontroller.text != '') {
      setState(() => {
            loading = true,
            animatedTextList = [
              TypewriterAnimatedText(
                  '. . . Checking _-_-_-\n Our datbase is huge!\n hmmm... \n'),
            ]
          });
      // sign in with sms code and verification id
      try {
        await FirebaseAuth.instance
            .signInWithCredential(PhoneAuthProvider.credential(
                verificationId: verificationId, smsCode: codecontroller.text))
            .then((value) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(value.additionalUserInfo!.isNewUser
                ? "Welcome! 🎉 Your ticket is now claimed!"
                : "Welcome back! 🎉"),
          ));
          FirebaseAuth.instance.currentUser!.updateDisplayName(userDisplayName);
        });
      } on FirebaseAuthException catch (e) {
        setState(() {
          animatedTextList = [
            TypewriterAnimatedText(
                '. . .  Smoething went wrong! \n Please try again?'),
          ];
        });
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text("Code not valid. Error: ${e.message}"),
        //   duration: Duration(seconds: 10),
        //   showCloseIcon: true,
        // ));
      }
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffff001e05),
      body: AnimatedContainer(
        height: MediaQuery.of(context).size.height,
        duration: Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        color: claimingTicket ? Color(0xffffa2ffd2) : Color(0xffff001e05),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            constraints: BoxConstraints(maxWidth: 400),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 24,
                  ),
                  Image.asset(
                    claimingTicket ? 'assets/ngab.png' : 'assets/ngaw.png',
                    height: 160,
                    width: 160,
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Shows info about the event
                              if (!claimingTicket) ...[
                                Text("23 MARS 14:00 - 18:00",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                      color: Color(0xffffdefee3),
                                    )),
                                SizedBox(
                                  height: 8,
                                ),
                                Text("GLØSHAUGEN _ REALFAGSBYGGET",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13,
                                      color: Color(0xffffdefee3),
                                    )),
                              ],

                              SizedBox(
                                // alignment: Alignment.bottomCenter,
                                height: 200,
                                // color: Colors.red,
                                width: double.infinity,
                                // margin: EdgeInsets.only(bottom: 32),
                                child: DefaultTextStyle(
                                  style: claimingTicket
                                      ? TextStyle(
                                          fontFamily: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .fontFamily,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 24,
                                          color: Color(0xffff001e05),
                                        )
                                      : TextStyle(
                                          fontFamily: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .fontFamily,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20,
                                          color: Color(0xffffdefee3),
                                        ),
                                  child: AnimatedTextKit(
                                    key: ValueKey<String>(
                                        animatedTextList[0].text),
                                    isRepeatingAnimation: false,
                                    animatedTexts: animatedTextList,
                                  ),
                                ),
                              ),

                              // asks for name
                              if (claimingTicket && userDisplayName == '')
                                FormField(builder: (state) {
                                  return TextFormField(
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (value) =>
                                        _continueButton(),
                                    controller: namecontroller,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    cursorWidth: 4,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your name';
                                      }
                                      return null;
                                    },
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 32),
                                    textAlignVertical: TextAlignVertical.center,
                                    decoration: InputDecoration(
                                      labelText: "Enter your name",
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      labelStyle: TextStyle(
                                        color: Color(0xffff001e05),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xffff001e05)),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xffff001e05)),
                                      ),
                                    ),
                                  );
                                }),

                              // asks for phone number
                              if (claimingTicket &&
                                  userDisplayName != '' &&
                                  smsCodeSent == false)
                                FormField(builder: (state) {
                                  return TextFormField(
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (value) =>
                                        _continueButton(),

                                    controller: phonecontroller,
                                    keyboardType: TextInputType.phone,
                                    // focusNode: myFocusNodePhone,
                                    cursorWidth: 4,
                                    style: TextStyle(fontSize: 32),
                                    textAlign: TextAlign.center,
                                    textAlignVertical: TextAlignVertical.center,
                                    //phone number validation
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your phone number';
                                      }

                                      if (value.length < 8) {
                                        return 'Please enter a valid phone number';
                                      }

                                      return null;
                                    },

                                    decoration: InputDecoration(
                                      labelText: "Enter your phone number",
                                      hintText: '... .. ...',
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      labelStyle: TextStyle(
                                        color: Color(0xffff001e05),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xffff001e05)),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xffff001e05)),
                                      ),
                                    ),
                                  );
                                }),

                              if (claimingTicket &&
                                  userDisplayName != '' &&
                                  smsCodeSent == true)
                                FormField(builder: (state) {
                                  return TextFormField(
                                    textInputAction: TextInputAction.next,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(6),
                                    ],
                                    onChanged: (value) => value.length == 6
                                        ? _continueButton()
                                        : null,
                                    onFieldSubmitted: (value) =>
                                        _continueButton(),
                                    validator: (value) => value?.length != 6
                                        ? 'Please enter the 6 digit code'
                                        : null,
                                    controller: codecontroller,
                                    // focusNode: myFocusNodeCode,
                                    style: TextStyle(fontSize: 32),
                                    textCapitalization:
                                        TextCapitalization.words,
                                    cursorWidth: 4,
                                    textAlign: TextAlign.center,
                                    textAlignVertical: TextAlignVertical.center,
                                    decoration: InputDecoration(
                                      labelText: "Enter the SMS code",
                                      hintText: '. . . . . .',
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      labelStyle: TextStyle(
                                        color: Color(0xffff001e05),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xffff001e05)),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xffff001e05)),
                                      ),
                                    ),
                                  );
                                }),
                            ]),
                      )),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    height: 60,
                    child: loading
                        ? SizedBox(
                            height: 60,
                            width: 60,
                            child: CircularProgressIndicator(
                              color: Color(0xffff9105E6),
                            ))
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: smsCodeSent
                                  ? Color(0xffff001e05)
                                  : Color(0xffffa2ffd2),
                              foregroundColor: smsCodeSent
                                  ? Color(0xffff001e05)
                                  : Color(0xffffa2ffd2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0),
                              ),
                            ),
                            onPressed: _continueButton,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                buttonText,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: smsCodeSent
                                      ? Color.fromARGB(255, 255, 255, 255)
                                      : Color(0xffff001e05),
                                ),
                              ),
                            ),
                          ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextButton(
                    onPressed: () => {
                      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //   content: Text("Sending Message"),
                      // ))
                    },
                    child: Text(
                      "gamewards.no",
                      style: TextStyle(
                        color: !claimingTicket
                            ? Color(0xffffdefee3)
                            : Color(0xffff9105E6),
                      ),
                    ),
                  ),
                  Row(
                    children: const [
                      SizedBox(
                        height: 100,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
