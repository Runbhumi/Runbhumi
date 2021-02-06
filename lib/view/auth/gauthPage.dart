import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widget/widgets.dart';
import 'package:Runbhumi/widget/googleOauth.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';

class GauthPage extends StatefulWidget {
  @override
  _GauthPageState createState() => _GauthPageState();
}

class _GauthPageState extends State<GauthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, title: buildTitle(context, "Runbhumi")),
      body: ConnectivityWidgetWrapper(
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 50.0, vertical: 20.0),
                child: Image(
                  image: AssetImage('assets/basketballGuy.png'),
                ),
              ),
              /*Padding(
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
              DividingOr(),*/
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
                child: Text(
                  "Connecting people through sports",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60.0),
                child: Text(
                  "join the community of sports players nearby you",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: GoogleOauth(),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'By continuing you agree to our ',
                    style: Theme.of(context).textTheme.bodyText1,
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launch(
                                'https://runbhumi.vercel.app/privacy-policy');
                          },
                      ),
                      TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Terms & Conditions',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launch(
                                'https://runbhumi.vercel.app/terms-and-condition');
                          },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
