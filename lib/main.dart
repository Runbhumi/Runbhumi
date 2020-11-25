import 'package:Runbhumi/utils/Constants.dart';
import 'package:Runbhumi/utils/theme_config.dart';
import 'package:Runbhumi/widget/showOffline.dart';
import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'view/views.dart';
import 'package:provider/provider.dart';

Future main() async {
  // initialize shared prefs
  WidgetsFlutterBinding.ensureInitialized();
  Constants.prefs = await SharedPreferences.getInstance();
  // using provider
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ThemeNotifier()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //name of app
      title: 'Runbhumi',
      // Named Routes
      routes: {
        '/mainapp': (context) => MainApp(),
        '/home': (context) => Home(),
        '/addpost': (context) => AddPost(),
        '/secondpage': (context) => SecondPage(),
        '/moreinfo': (context) => MoreInfo(),
        '/network': (context) => Network(),
        '/profile': (context) => Profile(),
        '/editprofile': (context) => EditProfile(),
        '/testing': (context) => Testing(),
        '/createteam': (context) => CreateTeam(),
      },
      //theme
      theme: Provider.of<ThemeNotifier>(context).currentTheme,
      //connectivity widget used to check internet connection
      home: ConnectivityWidget(
          showOfflineBanner: false,
          offlineCallback: () {
            print("-----------------we Are f^*KiNg offline----------------");
          },
          builder: (context, isOnline) {
            return isOnline ? Splash() : ShowOffline();
          }),
      // home: Splash(),
      // debug tag which comes on top left corner
      debugShowCheckedModeBanner: false,
    );
  }
}
