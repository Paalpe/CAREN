import 'package:caren/onboarding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
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
    return FirebasePhoneAuthProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner:false,
        title: 'Flutter Demo',
        theme: ThemeData(
          // add textbutton theme
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Color(0xFFFF093F12),
            ),
          ),

          useMaterial3: true,
          primarySwatch: Colors.green,
        ),
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const MyHomePage(title: 'NGA');
            }
            return OnBoarding();
          },
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              title: Text(
                'NGA • NORWEGIAN GAME AWARDS',
                style: TextStyle(fontSize: 12),
              ),
              backgroundColor: Color(0xFFFF88FFC6),
              expandedHeight: 400.0,
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: [StretchMode.zoomBackground],
                background: UserHeaderInfo(),
              ),
            ),
            SliverFixedExtentList(
              itemExtent: 150.0,
              delegate: SliverChildListDelegate(
                [
                  Container(
                    color: Colors.white,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "23 MARS 12:00 - 18:00",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 20),
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
                        subtext: "SE VÅRE PREMIER",
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
                  Container(color: Colors.yellow),
                  Container(color: Colors.pink),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class UserHeaderInfo extends StatefulWidget {
  UserHeaderInfo({Key? key}) : super(key: key);

  @override
  State<UserHeaderInfo> createState() => _UserHeaderInfoState();
}

class _UserHeaderInfoState extends State<UserHeaderInfo> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          textTheme: TextTheme(bodyText2: TextStyle(color: Colors.white))),
      child: Container(
        color: Color(0xFFFF001E05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // add img ngalogo.png form assers
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Row(
                children: [
                  Image.asset(
                    "assets/ngalogo.png",
                    width: 80,
                    height: 80,
                    color: Color(0xFFFFAEBFB1),
                  ),
                ],
              ),
            ),
            QrImage(
              gapless: false,
              dataModuleStyle:
                  QrDataModuleStyle(dataModuleShape: QrDataModuleShape.circle),
              foregroundColor: Color(0xFFFF88FFC6),
              data: "1234567890",
              version: QrVersions.auto,
              size: 200.0,
            ),
            SizedBox(
              height: 32,
            ),
            Text(
              "OLA NORDMANN",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18),
            ),
            SizedBox(
              height: 8,
            ),
            Text("#plas-234234", style: TextStyle(color: Colors.white)),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
      child: TextButton(
        onPressed: () => {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Icon(
                icon,
                size: 32,
              ),
            ),
            SizedBox(
              width: 32,
            ),
            Container(
              width: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  Text(subtext),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
