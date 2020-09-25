import 'package:Runbhumi/widget/button.dart';
import 'package:Runbhumi/widget/dividingOr.dart';
import 'package:Runbhumi/widget/googleOauth.dart';
import 'package:flutter/material.dart';

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
              child: Image(image: AssetImage('assets/login.png')),
            ),
            Button(
              myText: "Login",
              myColor: Theme.of(context).primaryColor,
              routeName: "/login",
            ),
            Button(
              myText: "SignUp",
              myColor: Theme.of(context).accentColor,
              routeName: "/signup",
            ),
            DividingOr(),
            GoogleOauth(),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
