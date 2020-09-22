import 'package:Runbhumi/authentication/loginPage.dart';
import 'package:Runbhumi/authentication/signUp.dart';
import 'package:Runbhumi/components/button.dart';
import 'package:Runbhumi/components/dividingOr.dart';
import 'package:Runbhumi/components/googleOauth.dart';
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
              myWidget: LoginPage(),
            ),
            Button(
              myText: "SignUp",
              myColor: Theme.of(context).accentColor,
              myWidget: SignUp(),
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
