import 'package:Runbhumi/authentication/loginPage.dart';
import 'package:Runbhumi/authentication/signUp.dart';
import 'package:Runbhumi/components/button.dart';
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
            GoogleOauthBig(),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class GoogleOauthBig extends StatelessWidget {
  const GoogleOauthBig({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                    color: Theme.of(context).buttonColor,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                          color: Theme.of(context).buttonColor.withOpacity(.4),
                          blurRadius: 6,
                          offset: Offset(0, 5))
                    ]),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child:
                            Image(image: AssetImage('assets/googleicon.png')),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "Continue with Google",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

class DividingOr extends StatelessWidget {
  const DividingOr({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Container(
          height: 1.0,
          width: 100.0,
          color: Colors.black,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text("OR"),
        ),
        Container(
          height: 1.0,
          width: 100.0,
          color: Colors.black,
        ),
      ]),
    );
  }
}
