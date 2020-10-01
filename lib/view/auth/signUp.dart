import 'package:flutter/material.dart';
import '../../widget/widgets.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              CreateAccHeading(),
              InputBox(
                hintText: "Full name",
                icon: Icon(Icons.contacts_outlined),
              ),
              InputBox(
                hintText: "Username",
                icon: Icon(Icons.account_circle_outlined),
              ),
              InputBox(
                hintText: "E-mail",
                icon: Icon(Icons.mail_outline),
              ),
              InputBox(
                hintText: "Password",
                obscureText: true,
                helpertext: "use at least 8 charecters",
                sufIcon: IconButton(
                  icon: Icon(Icons.remove_red_eye),
                  splashRadius: 1,
                  onPressed: () {},
                ),
                icon: Icon(Icons.lock_outline),
              ),
              Button(
                myText: "Sign Up For Runbhumi",
                myColor: Theme.of(context).accentColor,
                routeName: "/home",
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
