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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  print("going to " + "/login");
                  Navigator.pushReplacementNamed(context, "/login");
                },
                child: Container(
                  height: 55,
                  width: 300,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(800),
                      boxShadow: [
                        BoxShadow(
                            color:
                                Theme.of(context).primaryColor.withOpacity(.4),
                            blurRadius: 6,
                            offset: Offset(0, 5))
                      ]),
                  child: Center(
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ),
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
