import 'package:Runbhumi/widget/button.dart';
import 'package:Runbhumi/widget/dividingOr.dart';
import 'package:Runbhumi/widget/googleOauth.dart';
import 'package:Runbhumi/widget/inputBox.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    // loadLocations();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              CreateAccHeading(),
              InputBox(
                  myText: "Full name",
                  hidden: false,
                  icon: Icon(Icons.contacts)),
              InputBox(
                  myText: "Username",
                  hidden: false,
                  icon: Icon(Icons.account_circle)),
              InputBox(
                  myText: "Phone Number",
                  hidden: false,
                  icon: Icon(Icons.phone)),
              InputBox(
                  myText: "Password",
                  hidden: true,
                  helptext: "use at least 8 charecters",
                  sufIcon: Icon(Icons.remove_red_eye),
                  icon: Icon(Icons.lock)),
              Button(
                myText: "Sign Up For Runbhumi",
                myColor: Theme.of(context).accentColor,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Text(
                  "By signing up for Runbhumi you agree to our terms and conditions and privacy policy",
                  textAlign: TextAlign.center,
                ),
              ),
              DividingOr(),
              Button(
                myText: "Login",
                myColor: Theme.of(context).primaryColor,
                routeName: "/login",
              ),
              SizedBox(height: 20),
              GoogleOauth(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class CreateAccHeading extends StatelessWidget {
  const CreateAccHeading({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Text("Create Account",
            style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).primaryColor)),
      ),
    );
  }
}
