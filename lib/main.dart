import 'package:Runbhumi/utils/Constants.dart';
import 'package:Runbhumi/utils/theme_config.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'view/views.dart';
import 'package:provider/provider.dart';
// import 'package:flutter/services.dart';

Future main() async {
  // initialize shared prefs
  WidgetsFlutterBinding.ensureInitialized();
  Constants.prefs = await SharedPreferences.getInstance();
  // using provider
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ThemeNotifier()),
  ], child: Runbhumi()));
}

class Runbhumi extends StatefulWidget {
  @override
  _RunbhumiState createState() => _RunbhumiState();
}

class _RunbhumiState extends State<Runbhumi> {
  // static const MethodChannel _channel =
  //     MethodChannel('testing.com/channel_test');

  // Map<String, String> channelMap = {
  //   "id": "Notifications",
  //   "name": "Show Notifications",
  //   "description": "All Notifications",
  // };
  // Map<String, String> chatchannelMap = {
  //   "id": "Chat",
  //   "name": "Chat Notifications",
  //   "description": "Chat Notifications"
  // };
  // void _createNewChannel() async {
  //   try {
  //     await _channel.invokeMethod('createNotificationChannel', channelMap);
  //     await _channel.invokeMethod('createNotificationChannel', chatchannelMap);
  //     setState(() {});
  //   } on PlatformException catch (e) {
  //     print(e.toString());
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // _createNewChannel();
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityAppWrapper(
      app: MaterialApp(
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
          '/createteam': (context) => CreateTeam(),
          //'/cards': (context) => Cards(),
        },
        //theme
        theme: Provider.of<ThemeNotifier>(context).currentTheme,
        home: Splash(),
        // debug tag which comes on top left corner
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
