import 'package:Runbhumi/view/secondPage.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'view/views.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Runbhumi',
      // Named Routes
        routes: {
          '/login': (context) => LoginPage(),
          '/signup': (context) => SignUp(),
          '/forgotpassword': (context) => ForgotPassword(),
          '/home': (context) => Home(),
          '/addpost': (context) => AddPost(),
        },
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primaryColor: Color(0xff00adb5),
          accentColor: Color(0xff393e46),
          buttonColor: Color(0xffeeeeee),
          bottomAppBarColor: Color(0xffd4ebf2),
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
      navigateAfterSeconds: new SecondPage(),
      title: new Text(
        'Runbhumi',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        textScaleFactor: 1.5,
      ),
      image: new Image(image: AssetImage('assets/welcome.png')),
      loadingText: Text(""),
      photoSize: 100.0,
      loaderColor: Theme.of(context).primaryColor,
    );
  }
}
