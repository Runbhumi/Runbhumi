import 'package:Runbhumi/utils/Constants.dart';
import 'package:Runbhumi/utils/theme_config.dart';
import 'package:Runbhumi/view/auth/secondPage.dart';
import 'package:Runbhumi/view/splash/splash.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:splashscreen/splashscreen.dart';
import 'view/mainapp.dart';
import 'view/splash/splash.dart';
import 'view/views.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Constants.prefs = await SharedPreferences.getInstance();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ThemeNotifier()),
  ], child: MyApp()));
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
        // '/login': (context) => LoginPage(),
        // '/signup': (context) => SignUp(),
        // '/forgotpassword': (context) => ForgotPassword(),
        '/mainapp': (context) => MainApp(),
        '/home': (context) => Home(),
        '/addpost': (context) => AddPost(),
        '/secondpage': (context) => SecondPage(),
        '/moreinfo': (context) => MoreInfo(),
        '/network': (context) => Network(),
        '/profile': (context) => Profile(),
      },
      theme: Provider.of<ThemeNotifier>(context).currentTheme,
      home: Splash(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// class CustomSplashScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SplashScreen(
//       seconds: 5,
//       navigateAfterSeconds: Constants.prefs.getBool("loggedin") == false
//           ? SecondPage()
//           : MainApp(),
//       title: new Text(
//         'Runbhumi',
//         style: TextStyle(
//           fontSize: 24,
//           fontWeight: FontWeight.w600,
//         ),
//         textScaleFactor: 1.5,
//       ),
//       image: new Image(image: AssetImage('assets/welcome.png')),
//       loadingText: Text(""),
//       photoSize: 100.0,
//       loaderColor: Theme.of(context).primaryColor,
//     );
//   }
// }
