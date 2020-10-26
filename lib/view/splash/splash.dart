import 'dart:async';

import 'package:Runbhumi/utils/Constants.dart';
import 'package:flutter/material.dart';
import 'package:Runbhumi/widget/animations/type_write.dart';
import 'package:Runbhumi/utils/router.dart';

import '../views.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  // Timer to change the screen in 1.2 seconds
  startTimeout() {
    return Timer(Duration(milliseconds: 2200), handleTimeout);
  }

  void handleTimeout() {
    changeScreen();
  }

  changeScreen() async {
    Constants.prefs.getBool("loggedin") == false
        ? CRouter.pushPageWithFadeAnimation(context, SecondPage())
        : CRouter.pushPageWithFadeAnimation(context, MainApp());
    // CRouter.pushPageWithFadeAnimation(context, SecondPage());
  }

  @override
  void initState() {
    super.initState();
    startTimeout();
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
