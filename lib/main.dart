import 'package:Runbhumi/utils/Constants.dart';
import 'package:Runbhumi/utils/theme_config.dart';
// import 'package:Runbhumi/widget/widgets.dart';
// import 'package:Runbhumi/widget/showOffline.dart';
// import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'view/payments/cards.dart';
import 'view/views.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

Future main() async {
  // initialize shared prefs
  WidgetsFlutterBinding.ensureInitialized();
  Constants.prefs = await SharedPreferences.getInstance();
  // using provider
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ThemeNotifier()),
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _statusText = "Waiting...";
  final String _finished = "Finished creating channel";
  final String _error = "Error while creating channel";
  static const MethodChannel _channel =
      MethodChannel('testing.com/channel_test');

  Map<String, String> channelMap = {
    "id": "Notifications",
    "name": "Testing",
    "description": "All Notifications",
  };
  void _createNewChannel() async {
    try {
      await _channel.invokeMethod('createNotificationChannel', channelMap);
      setState(() {
        _statusText = _finished;
      });
    } on PlatformException catch (e) {
      _statusText = _error;
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _createNewChannel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //name of app
      title: 'Runbhumi',
      // Named Routes
      routes: {
        // '/mainapp': (context) => AnimatedBottomNav(),
        '/addpost': (context) => AddPost(),
        '/secondpage': (context) => GauthPage(),
        '/moreinfo': (context) => MoreInfo(),
        '/network': (context) => MessagePage(),
        '/profile': (context) => Profile(),
        '/editprofile': (context) => EditProfile(),
        '/testing': (context) => Testing(),
        '/createteam': (context) => CreateTeam(),
        '/cards': (context) => Cards(),
      },
      //theme
      theme: Provider.of<ThemeNotifier>(context).currentTheme,
      //connectivity widget used to check internet connection
      // home: ConnectivityWidget(
      //     showOfflineBanner: false,
      //     offlineCallback: () {
      //       print("-----------------we Are offline----------------");
      //     },
      //     builder: (context, isOnline) {
      //       return isOnline ? Splash() : ShowOffline();
      //     }),
      home: Splash(),
      // debug tag which comes on top left corner
      debugShowCheckedModeBanner: false,
    );
  }
}
