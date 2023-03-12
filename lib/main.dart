
import 'dart:math';

import 'package:caren/admin/admin_panel.dart';
import 'package:caren/game_sliver.dart';
import 'package:caren/onboarding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// ... flutter run -d chrome --web-renderer html --profile

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  String userDisplayName = "";
  String userEmail = "";
  bool isNewUser = false;

  void updateId(String userDisplayName, String userEmail, bool isNewUser) {
    // FirebaseAuth.instance.currentUser?.updateDisplayName(userDisplayName);
    setState(() {
      this.userDisplayName = userDisplayName;
      this.userEmail = userEmail;
      this.isNewUser = isNewUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return FirebasePhoneAuthProvider(
      child: MaterialApp(
        color: Color(0xffff001e05),
        debugShowCheckedModeBanner: false,
        title: 'NGA • NORWEGIAN GAME AWARDS 2023',
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
              if (isNewUser) {
                print("new user");
              }

              return MyHomePage(title: 'NGA', streamUser: snapshot);
            }
            return OnBoarding(
              onUserRegister: (userDisplayName, userEmail, isNewUSer) => {
                updateId(userDisplayName, userEmail, isNewUser),
                // // if (isNewUSer)
                // //   {
                // //     FirebaseFirestore.instance
                // //         .doc('/users/' + userEmail)
                // //         .set({'displayName': userDisplayName})
                // //   }
                // snapshot.data?.updateDisplayName(userDisplayName),
                // snapshot.data?.updateEmail(userEmail),
              },
            );
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
  final _scrollController = ScrollController();
  late ConfettiController _controllerBottomCenter;
  int adminCounter = 4;
  @override
  void initState() {
    super.initState();
    _controllerBottomCenter =
        ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _controllerBottomCenter.dispose();
    _scrollController.dispose();
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
          controller: _scrollController,
          slivers: <Widget>[
            SliverAppBar(
              stretch: true,
              pinned: true,
              title: TextButton(
                onPressed: () async {
                  print(adminCounter);
                  if (adminCounter > 0) {
                    adminCounter--;
                  }
// show toast!

                  if (adminCounter == 0) {
                    await FirebaseFirestore.instance
                        .doc('/isAdmin/' + widget.streamUser.data!.uid)
                        .get()
                        .then((value) {
                      // if (value.data()!=null) {
                      //   print(value.data());
                      if (value.exists) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdminHome()));
                      }
                      // }
                    }).catchError((e) {
                      print('/isAdmin/' + widget.streamUser.data!.uid);
                      adminCounter = 10;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("You are not an admin ;'("),
                        ),
                      );
                    });
                  }
                },
                child: Text(
                  'NGA  •  NORWEGIAN GAME AWARDS',
                  style: TextStyle(
                      fontSize: 13,
                      wordSpacing: 1.0002,
                      color: Color(0xffff88ffc6),
                      fontWeight: FontWeight.w400),
                ),
              ),
              backgroundColor: Color(0xffff001e05),
              expandedHeight: 480.0,
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
                              phone: snapshot.data!.phoneNumber!,
                              name: snapshot.data!.displayName!,
                              uid: snapshot.data!.phoneNumber!,
                              email: snapshot.data!.email!,
                            ),
                            //BOTTOM CENTER
                            Align(
                              alignment: Alignment(0, -0.3),
                              child: ConfettiWidget(
                                colors: const [
                                  // add green colors
                                  Color(0xffff88ffc6),
                                  Color(0xffff11FF8D),
                                  Color(0xffff9105E6),
                                  Color.fromARGB(255, 184, 78, 249),
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
            SliverToBoxAdapter(
              child: Container(
                height: 200,
                // color: Color(0xffff88ffc6),
                // color:  Color(0xffff9105E6),,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "23 MARS 14:00 - 18:00",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Color(0xffff9105E6)),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text("GLØSHAUGEN _ REALFAGSBYGGET",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 13))
                    ]),
              ),
            ),
            SliverGamesFromItch(scrollController: _scrollController),

            // SliverFixedExtentList(
            //   itemExtent: 150.0,
            //   delegate: SliverChildListDelegate(
            //     [
            //       Container(
            //         // color: Color(0xffff88ffc6),
            //         // color:  Color(0xffff9105E6),,
            //         child: Column(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: const [
            //               Text(
            //                 "23 MARS 14:00 - 18:00",
            //                 style: TextStyle(
            //                     fontWeight: FontWeight.w600,
            //                     fontSize: 20,
            //                     color: Color(0xffff9105E6)),
            //               ),
            //               SizedBox(
            //                 height: 8,
            //               ),
            //               Text("GLØSHAUGEN _ REALFAGSBYGGET",
            //                   style: TextStyle(
            //                       fontWeight: FontWeight.w600, fontSize: 13))
            //             ]),
            //       ),
            //       // Container(
            //       //   color: Colors.white,
            //       //   child: CustomButtonFixed(
            //       //       text: "SE VÅRE PREMIER",
            //       //       subtext: "airpods, ps5, xbox series x, nintendo switch",
            //       //       icon: Icons.campaign_rounded,
            //       //       onPressed: () => {}),
            //       // ),
            //       // Container(
            //       //   color: Colors.white,
            //       //   child: CustomButtonFixed(
            //       //       text: "SE VÅRE SPILL",
            //       //       subtext: "55 forksjellige spill, 200 utviklere",
            //       //       icon: Icons.stadium_rounded,
            //       //       onPressed: () => {}),
            //       // ),
            //       // Container(color: Colors.white),
            //       // Container(color: Colors.white),
            //       // Container(color: Colors.white),
            //       // Container(
            //       //   color: Colors.white,
            //       //   child: TextButton(
            //       //     onPressed: () => FirebaseAuth.instance.signOut(),
            //       //     child: Text("Logg av"),
            //       //   ),
            //       // ),
            //     ],
            //   ),
            // ),
            SliverFixedExtentList(
                delegate: SliverChildListDelegate([Container()]),
                itemExtent: 280),
            // SliverFixedExtentList(
            //     delegate: SliverChildListDelegate([ListOfGames()]),
            //     itemExtent: 280),

            SliverToBoxAdapter(
              child: Container(
                height: 200,
                color: Colors.white,
                child: TextButton(
                  onPressed: () => FirebaseAuth.instance.signOut(),
                  child: Text("Logg av"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyItemCarosell extends StatefulWidget {
  const MyItemCarosell({
    super.key,
  });

  @override
  State<MyItemCarosell> createState() => _MyItemCarosellState();
}

class _MyItemCarosellState extends State<MyItemCarosell> {
  final PageController _pageController = PageController(viewportFraction: 0.3);
  double _currentPage = 0;
  @override
  void initState() {
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      pageSnapping: true,
      controller: _pageController,
      children: [
        Container(
          color: Colors.blue,
        ),
        Container(
          color: Colors.green,
        )
      ],
    );
  }
}

class UserHeaderInfo extends StatefulWidget {
  final String name, uid, phone, email;
  const UserHeaderInfo(
      {Key? key,
      required this.name,
      required this.uid,
      required this.phone,
      required this.email})
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
              // data: widget.uid,
              data: 'www.gameAwards.no/',
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
            Text(widget.email, style: TextStyle(color: Colors.white)),
            SizedBox(
              height: 8,
            ),
            Text(
                widget.phone.contains('+47')
                // add format 123 45 678,

                ? '${widget.phone.substring(0, 3)} ${widget.phone.substring(3, 6)} ${widget.phone.substring(6, 8)} ${widget.phone.substring(8, 11)}'

                    // ? '${widget.phone.substring(0, 3)} ${widget.phone.substring(3, 5)} ${widget.phone.substring(5, 7)} ${widget.phone.substring(7, 9)}'
                    // add format +47 123 45 678,
                    : widget.phone.substring(3),
                style: TextStyle(color: Colors.white)),
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
