import 'package:flutter/material.dart';

class OnBoarding extends StatefulWidget {
  OnBoarding({Key? key}) : super(key: key);

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFF001E05),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
              ),
              Image.asset(
                'assets/ngalogo.png',
                height: 100,
                width: 100,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("23 MARS 12:00 - 18:00",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Color(0xFFFFDEFEE3),
                          )),
                      Text("GLØSHAUGEN _ REALFAGSBYGGET",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color: Color(0xFFFFDEFEE3),
                          )),
                    ]),
              ),
              SizedBox(
                height: 16,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFA2FFD2),
                  foregroundColor: Color(0xFFFFA2FFD2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                ),
                onPressed: () => {},
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "CLAIN YOUR TICKET",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFFF001E05),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              TextButton(
                onPressed: () => {},
                child: Text(
                  "gamewards.no",
                  style: TextStyle(
                    color: Color(0xFFFFDEFEE3),
                  ),
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    height: 100,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}


