import 'package:after_layout/after_layout.dart';
import 'package:defc_barcode_scanner/home_page.dart';
import 'package:defc_barcode_scanner/login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:googleapis/sheets/v4.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      ),
      home: Splash(),
    );
  }
}

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<Splash> with AfterLayoutMixin<Splash> {
  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: <String>[DriveApi.driveScope, SheetsApi.spreadsheetsScope],
  );
  GoogleSignInAccount? _currentUser;

  @override
  void initState() {
    super.initState();
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => HomePage(googleSignIn: googleSignIn)));
      }
    });
  }

  void checkFirstRun() async {
    if (await googleSignIn.signInSilently() != null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomePage(googleSignIn: googleSignIn)));
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _run = (prefs.getBool('isFirstRun') ?? true);

    if (_run) {
      await prefs.setBool('isFirstRun', false);
      final loginPage = LoginPage(googleSignIn: googleSignIn);
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => loginPage));
      loginPage.showHelp(context);
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => LoginPage(googleSignIn: googleSignIn)));
    }

    return;
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