import 'package:Runbhumi/services/services.dart';
import 'package:Runbhumi/utils/Constants.dart';
import 'package:Runbhumi/utils/theme_config.dart';
import 'package:Runbhumi/view/profile/drawer/faq.dart';
import 'package:Runbhumi/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter/foundation.dart' as Foundation;

class DrawerBody extends StatefulWidget {
  const DrawerBody({
    Key key,
  }) : super(key: key);

  @override
  _DrawerBodyState createState() => _DrawerBodyState();
}

class _DrawerBodyState extends State<DrawerBody> {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Spacer(),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 0, 36),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 24,
                ),
                Text(
                  "Hello,",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  Constants.prefs.getString('name'),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        // // only use for testing
        // if (Foundation.kDebugMode)
        //   DrawerButton(
        //     onpressed: () {
        //       Navigator.pushNamed(context, "/testing");
        //     },
        //     label: "Testing",
        //     icon: Icon(
        //       Feather.flag,
        //       color: Colors.white,
        //     ),
        //   ),
        DrawerButton(
          onpressed: () {
            Navigator.pushNamed(context, "/editprofile");
          },
          label: "Edit Profile",
          icon: Icon(
            Feather.edit,
            color: Colors.white,
          ),
        ),
        // Dark mode switch
        DrawerButton(
          onpressed: () {
            theme.switchTheme();
          },
          beta: true,
          label: theme.myTheme == MyTheme.Light ? 'Dark Mode' : "Light Mode",
          icon: theme.myTheme == MyTheme.Light
              ? Icon(
                  Feather.sun,
                  color: Colors.white,
                )
              : Icon(Feather.moon),
        ),
        // More Info
        DrawerButton(
          icon: Icon(
            Feather.info,
            color: Colors.white,
          ),
          onpressed: () {
            print("go to more info");
            Navigator.pushNamed(context, "/moreinfo");
          },
          label: "More Info",
        ),
        //faq
        DrawerButton(
          onpressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Faq();
            }));
          },
          label: 'FAQ',
          icon: Icon(
            Feather.help_circle,
            color: Colors.white,
          ),
        ),
        //feedback
        DrawerButton(
          onpressed: () {
            _launchURL(websiteURL + "feedback");
          },
          label: 'Give Feedback',
          icon: Icon(
            Feather.thumbs_up,
            color: Colors.white,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Container(
            color: Colors.white54,
            height: 2,
            width: 150,
          ),
        ),
        //log out
        DrawerButton(
          onpressed: () {
            print("logout");
            Constants.prefs.setBool("loggedin", false);
            signOutGoogle();
            Navigator.pushReplacementNamed(context, "/secondpage");
          },
          label: 'Log Out',
          icon: Icon(
            Feather.log_out,
            color: Colors.white,
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 0, 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  launch(websiteURL + 'privacy-policy');
                },
                child: Text(
                  "Privacy Policy",
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  launch(websiteURL + 'terms-and-conditions');
                },
                child: Text(
                  "Terms & Conditions",
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text(
                "© 2020-" + DateTime.now().year.toString() + " Runbhumi",
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Spacer(),
      ],
    );
  }
}

_launchURL(String gurl) async {
  String url = gurl;
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

var websiteURL = "https://runbhumi-website.vercel.app/";
