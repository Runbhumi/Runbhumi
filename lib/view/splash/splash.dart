import 'dart:async';
import 'package:Runbhumi/utils/Constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:Runbhumi/widget/animations/type_write.dart';
import 'package:Runbhumi/utils/router.dart';

import '../views.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  // Timer to change the screen in 2.2 seconds

  String _userId = Constants.prefs.getString('userId');
  startTimeout() {
    return Timer(Duration(milliseconds: 2200), handleTimeout);
  }

  void handleTimeout() {
    changeScreen();
  }

  changeScreen() async {
    _userId == null
        ? CRouter.pushPageWithFadeAnimation(context, SecondPage())
        : CRouter.pushPageWithFadeAnimation(context, MainApp());
    // CRouter.pushPageWithFadeAnimation(context, SecondPage());
  }

  @override
  void initState() {
    startTimeout();
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("firbase initialized in splash screen");
      setState(() {});
      startTimeout();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
                child: Image(
              image: AssetImage('assets/icon.png'),
              width: 150,
            )),
            Center(
              child: Hero(
                tag: 'appname',
                child: Material(
                  type: MaterialType.transparency,
                  child: TypeWrite(
                    word: 'Runbhumi',
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    ),
                    seconds: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
