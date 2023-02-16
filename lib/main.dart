import 'dart:math';

import 'package:caren/onboarding.dart';
import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// ...

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return FirebasePhoneAuthProvider(
      child: MaterialApp(
        color: Color(0xffff001e05),
        debugShowCheckedModeBanner: false,
        title: 'CAREN',
        theme: ThemeData(
           appBarTheme: AppBarTheme(
             systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Color(0xffff001e05),
            
             )),
          textTheme: GoogleFonts.robotoMonoTextTheme(textTheme).copyWith(
              // bodyMedium: GoogleFonts.oswald(textStyle: textTheme.bodyMedium),
              ),
          // add textbutton theme
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Color(0xffff093f12),
            ),
          ),

          useMaterial3: true,
          primarySwatch: Colors.green,
        ),
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return MyHomePage(title: 'NGA', streamUser: snapshot);
            }
            return OnBoarding();
          },
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
    required this.streamUser,
  });
  final String title;
  final AsyncSnapshot<User?> streamUser;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ConfettiController _controllerBottomCenter;
  @override
  void initState() {
    super.initState();
    _controllerBottomCenter =
        ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _controllerBottomCenter.dispose();
    super.dispose();
  }

  Future goConfetti() async {
    _controllerBottomCenter.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              stretch: true,
              pinned: true,
              title: Text(
                'NGA • NORWEGIAN GAME AWARDS',
                style: TextStyle(fontSize: 13 ,color: Color(0xffff88ffc6), fontWeight: FontWeight.w400),
              ),
              backgroundColor: Color(0xffff001e05),
              expandedHeight: 600.0,
              stretchTriggerOffset: 200,
              onStretchTrigger: () => goConfetti(),
              flexibleSpace: FlexibleSpaceBar(
                expandedTitleScale: 1.2,
                stretchModes: const [
                  StretchMode.zoomBackground,
                  StretchMode.fadeTitle
                ],
                background: StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.userChanges(),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.data != null) {
                      _controllerBottomCenter.play();
                      if (snapshot.data!.displayName != null) {
                        return Stack(
                          children: [
                            UserHeaderInfo(
                                name: snapshot.data!.displayName!,
                                uid: snapshot.data!.uid),
                            //BOTTOM CENTER
                            Align(
                              alignment: Alignment(0, -0.3),
                              child: ConfettiWidget(
                                colors: const [
                                  // add green colors
                                  Color(0xffff88ffc6),
                                  Color(0xffff11FF8D),
                                  Color(0xffffE8FDF3),
                                  Color(0xffffC5FBE1),
                                ],
                                confettiController: _controllerBottomCenter,
                                blastDirection: -pi / 2,
                                emissionFrequency: 0.05,
                                blastDirectionality:
                                    BlastDirectionality.explosive,
                                numberOfParticles: 30,
                                maxBlastForce: 49,
                                minBlastForce: 20,
                                gravity: 0.3,
                              ),
                            ),
                          ],
                        );
                      }
                    }
                    return LinearProgressIndicator(
                      color: Color.fromARGB(255, 13, 70, 43),
                      backgroundColor: Color(0xffff001e05),
                    );
                  },
                ),
              ),
            ),
            SliverFixedExtentList(
              itemExtent: 150.0,
              delegate: SliverChildListDelegate(
                [
                  Container(
                    color: Color(0xffff88ffc6),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "23 MARS 12:00 - 18:00",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 20),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text("GLØSHAUGEN _ REALFAGSBYGGET",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 13))
                        ]),
                  ),
                  Container(
                    color: Colors.white,
                    child: CustomButtonFixed(
                        text: "SE VÅRE PREMIER",
                        subtext: "airpods, ps5, xbox series x, nintendo switch",
                        icon: Icons.campaign_rounded,
                        onPressed: () => {}),
                  ),
                  Container(
                    color: Colors.white,
                    child: CustomButtonFixed(
                        text: "SE VÅRE SPILL",
                        subtext: "55 forksjellige spill, 200 utviklere",
                        icon: Icons.stadium_rounded,
                        onPressed: () => {}),
                  ),
                  Container(color: Colors.white),
                  Container(color: Colors.white),
                  Container(color: Colors.white),
                  Container(
                    color: Colors.white,
                    child: TextButton(
                      onPressed: () => FirebaseAuth.instance.signOut(),
                      child: Text("Logg av"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserHeaderInfo extends StatefulWidget {
  final String name, uid;
  const UserHeaderInfo({Key? key, required this.name, required this.uid})
      : super(key: key);

  @override
  State<UserHeaderInfo> createState() => _UserHeaderInfoState();
}

class _UserHeaderInfoState extends State<UserHeaderInfo> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.white))),
      child: Container(
        width: double.infinity,
        color: Color(0xffff001e05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // add img ngalogo.png form assers
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 32.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Image.asset(
            //         "assets/ngaw.png",
            //         width: 100,
            //         height: 100,
            //         color: Color(0xffffaebfb1),
            //       ),
            //     ],
            //   ),
            // ),
            QrImage(
              gapless: true,
              embeddedImage: AssetImage("assets/qrlogo.png"),
              embeddedImageStyle: QrEmbeddedImageStyle(
                // size: Size(76, 54),
              ),
              dataModuleStyle:
                  QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square),
              foregroundColor: Color(0xffff88ffc6),
              data: widget.uid,
              version: QrVersions.auto,
              size: 260.0,
            ),
            SizedBox(
              height: 32,
            ),
            Text(
              widget.name,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18),
            ),
            SizedBox(
              height: 8,
            ),
            Text(widget.uid, style: TextStyle(color: Colors.white)),
            SizedBox(
              height: 32,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomButtonFixed extends StatelessWidget {
  final String text;
  final String subtext;
  final IconData icon;
  final Function onPressed;
  const CustomButtonFixed(
      {Key? key,
      required this.text,
      required this.subtext,
      required this.icon,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 500),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
        child: TextButton.icon(
          onPressed: () => {},
          icon: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 16),
            child: Icon(
              icon,
              size: 32,
            ),
          ),
          label: SizedBox(
            width: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                ),
                Text(
                  subtext,
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}