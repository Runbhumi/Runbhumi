import 'dart:async';

import 'package:Runbhumi/view/auth/gauthPage.dart';
// import 'package:Runbhumi/widget/widgets.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:Runbhumi/utils/router.dart';
// import '../views.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  // Timer to change the screen in 2.2 seconds

  String? _userId = GetStorage().read('userId');
  String? _firsttime = GetStorage().read('firsttime');
  @override
  void initState() {
    startTimeout();
    super.initState();
    // Firebase.initializeApp().whenComplete(() {
    //   print("firbase initialized in splash screen");
    //   setState(() {});
    //   startTimeout();
    // });
  }

  startTimeout() {
    return Timer(Duration(milliseconds: 2200), changeScreen);
  }

  changeScreen() async {
    // _firsttime == null
    //     ? CRouter.pushPageWithFadeAnimation(context, OnBoardingPage())
    //     : _userId == null
    //         ? CRouter.pushPageWithFadeAnimation(context, GauthPage())
    //         : Navigator.pushReplacement(context,
    //             MaterialPageRoute(builder: (context) => AnimatedBottomBar()));
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) {
    //       return GauthPage();
    //     },
    //   ),
    // );
    Get.to(() => GauthPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Opacity(
                opacity: 0.85,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(32)),
                  child: Image(
                    image: AssetImage('assets/icon.png'),
                    width: 150,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 170,
            ),
            Text(
              "Runbhumi",
              style: TextStyle(
                color: Theme.of(context).backgroundColor.withOpacity(0.25),
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
