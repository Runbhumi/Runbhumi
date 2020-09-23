import 'package:Runbhumi/authentication screen/loginPage.dart';
import 'package:Runbhumi/components/button.dart';
import 'package:flutter/material.dart';

class CheckMail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: Image(
                image: AssetImage('assets/checkmail.png'),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                "We have sent you a mail, follow the instructions to reset your password",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
            Button(
              myText: "Login Again",
              myColor: Theme.of(context).accentColor,
              myWidget: LoginPage(),
            ),
          ],
        ),
      ),
    );
  }
}
