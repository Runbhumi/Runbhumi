import 'package:Runbhumi/utils/Constants.dart';
import 'package:Runbhumi/view/auth/secondPage.dart';
import 'package:Runbhumi/view/splash/splash.dart';
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

// _checkForUser() async {
//   bool connectionResult = await Constants.getUserLoggedInSharedPreference();
//   return connectionResult;
// }

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
        '/home': (context) => MainApp(),
        '/addpost': (context) => AddPost(),
        '/secondpage': (context) => SecondPage(),
        '/moreinfo': (context) => MoreInfo(),
      },
      theme: lightTheme(context),
      darkTheme: darkTheme(context),
      home: Splash(),
      debugShowCheckedModeBanner: false,
    );
  }

  ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: Color(0xff393E46),
        ),
        filled: true,
        fillColor: Color(0xffeeeeee),
        hoverColor: Colors.white,
        alignLabelWithHint: true,
        border: border(),
        focusedBorder: focusedBorder(context),
      ),
      bottomAppBarTheme: BottomAppBarTheme(
        color: Colors.white,
        elevation: 0,
      ),
      appBarTheme: AppBarTheme(
        color: Colors.white,
        elevation: 0,
        brightness: Brightness.light,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      primaryColor: Color(0xff00adb5),
      primaryColorLight: Color(0xff00adb5),
      accentColor: Color(0xff393e46),
      buttonColor: Color(0xffeeeeee),
      scaffoldBackgroundColor: Colors.white,
      bottomAppBarColor: Colors.white,
      fontFamily: 'Montserrat',
      brightness: Brightness.light,
      primaryColorBrightness: Brightness.light,
    );
  }

  ThemeData darkTheme(BuildContext context) {
    return ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: AppBarTheme(
          color: Colors.black26,
          elevation: 0,
          brightness: Brightness.dark,
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          actionsIconTheme: IconThemeData(
            color: Colors.white,
          )),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: Color(0xff333333),
        ),
        filled: true,
        fillColor: Colors.black,
        alignLabelWithHint: true,
        border: border(),
        focusedBorder: focusedBorder(context),
      ),
      primaryColor: Color(0xff00adb5),
      primaryColorLight: Color(0xff00adb5),
      accentColor: Color(0xff393e46),
      buttonColor: Color(0xffeeeeee),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.black45,
        elevation: 10,
        selectedItemColor: Color(0xff00adb5),
      ),
      fontFamily: 'Montserrat',
      brightness: Brightness.dark,
    );
  }

  OutlineInputBorder focusedBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: new BorderRadius.circular(50),
      borderSide: BorderSide(
        color: Color(0xff00adb5),
        width: 2.0,
      ),
    );
  }

  OutlineInputBorder border() {
    return OutlineInputBorder(
      borderRadius: new BorderRadius.circular(50),
      borderSide: BorderSide(
        color: Color(0xffB3ABAB),
        width: 1.0,
      ),
    );
  }
}

class CustomSplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds: Constants.prefs.getBool("loggedin") == false
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
