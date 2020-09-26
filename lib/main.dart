import 'package:Runbhumi/utils/Constants.dart';
import 'package:Runbhumi/view/secondPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';
import 'view/views.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Constants.prefs = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0x55393e46),
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
    ));
    return MaterialApp(
      title: 'Runbhumi',
      // Named Routes
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUp(),
        '/forgotpassword': (context) => ForgotPassword(),
        '/home': (context) => MainApp(),
        '/addpost': (context) => AddPost(),
        '/secondpage': (context) => SecondPage(),
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
      debugShowCheckedModeBanner: false,
    );
  }
}

class CustomSplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds: Constants.prefs.getBool("loggedIn") == false
          ? SecondPage()
          : MainApp(),
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
