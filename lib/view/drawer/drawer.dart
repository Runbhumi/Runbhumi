import 'package:Runbhumi/services/auth.dart';
import 'package:Runbhumi/utils/Constants.dart';
import 'package:Runbhumi/utils/theme_config.dart';
import 'package:Runbhumi/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

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
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 0, 36),
          child: Container(
            child: Text(
              "Hello,\n" + Constants.prefs.getString('name'),
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        DrawerButton(
          onpressed: () {},
          label: "Home",
          icon: Icon(
            Feather.home,
            color: Colors.white,
          ),
        ),
        DrawerButton(
          onpressed: () {},
          label: "Create or Join Teams",
          icon: Icon(
            Feather.user_plus,
            color: Colors.white,
          ),
        ),
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
        //About US
        // DrawerButton(
        //   onpressed: () {},
        //   label: 'About Us',
        //   icon: Icon(
        //     Icons.engineering_outlined,
        //     color: Colors.white,
        //   ),
        // ),

        // Dark mode switch
        DrawerButton(
          onpressed: () {
            theme.switchTheme();
          },
          label: theme.myTheme == MyTheme.Light ? 'Dark Mode' : "Light Mode",
          icon: theme.myTheme == MyTheme.Light
              ? Icon(
                  Feather.sun,
                  color: Colors.white,
                )
              : Icon(Feather.moon),
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
      ],
    );
  }
}
