import 'package:flutter/material.dart';
import 'authentication/LoginPage.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Runbhumi',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Montserrat'),
      home: CustomSplashScreen(),
      // home: LoginPage(),
      debugShowCheckedModeBanner: true,
    );
  }
}

class CustomSplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds: new LoginPage(),
      title: new Text(
        'Runbhumi',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        textScaleFactor: 1.5,
      ),
      // image: new Image.network(
      //     'https://img.pngio.com/skipping-sport-game-outdoor-exercise-jumping-rope-activity-png-outdoor-games-256_256.png'),
      image: new Image(image: AssetImage('assets/loginPage.png')),
      loadingText: Text("Running"),
      photoSize: 100.0,
      loaderColor: Colors.orange,
    );
  }
}
