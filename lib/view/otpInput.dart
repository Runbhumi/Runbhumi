import 'package:Runbhumi/widget/button.dart';
import 'package:Runbhumi/widget/inputBox.dart';
// import 'package:pinput/pin_put/pin_put.dart';
import 'package:flutter/material.dart';

class OtpInput extends StatelessWidget {
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
              child:
                  Image(image: AssetImage('assets/checkmail.png'), width: 200),
            ),
            Container(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Text(
                  "Please enter the OTP here",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            InputBox(myText: "OTP", hidden: true),
            Button(
              myText: "Login Again",
              myColor: Theme.of(context).accentColor,
              routeName: "/login",
            ),
          ],
        ),
      ),
    );
  }
}
