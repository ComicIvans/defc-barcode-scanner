import 'package:after_layout/after_layout.dart';
import 'package:defc_barcode_scanner/home_page.dart';
import 'package:defc_barcode_scanner/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Asistencia DEFC',
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Roboto',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primarySwatch: Colors.blue,
      ),
      home: const Splash(),
      navigatorKey: navigatorKey,
    );
  }
}

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<Splash> with AfterLayoutMixin<Splash> {
  Future checkFirstRun() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _run = (prefs.getBool('isFirstRun') ?? false);

    if (_run) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()));
    } else {
      await prefs.setBool('isFirstRun', true);
      final page = LoginPage();
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => page));
      page.showHelp(context);
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstRun();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Image.asset(
      'assets/images/defc_white.png',
      height: 250,
      width: 250,
    )));
  }
}
