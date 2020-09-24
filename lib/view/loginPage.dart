import 'package:Runbhumi/widget/button.dart';
import 'package:Runbhumi/widget/googleOauth.dart';
import 'package:Runbhumi/widget/inputBox.dart';
// import 'package:Runbhumi/mainApp/home.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TopWelcomeImage(),
            InputBox(
              myText: "Username",
              hidden: false,
              icon: Icon(Icons.account_circle),
            ),
            InputBox(
              myText: "Password",
              hidden: true,
              icon: Icon(Icons.lock),
              sufIcon: Icon(Icons.remove_red_eye),
            ),
            ForgotPasswordAnchor(),
            Button(
              myText: "Login",
              myColor: Theme.of(context).primaryColor,
              routeName: "/home",
            ),
            SizedBox(
              height: 10,
            ),
            GoogleOauth(),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Container(
                  child: Text(
                    "New here? Create an account",
                    style: TextStyle(
                      color: Color(0xFF3A3535),
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            Button(
              myColor: Theme.of(context).accentColor,
              myText: "SignUp",
              routeName: "/signup",
            ),
            SizedBox(
              height: 16.0,
            )
          ],
        ),
      ),
    );
  }
}

class ForgotPasswordAnchor extends StatelessWidget {
  const ForgotPasswordAnchor({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 32.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, "/forgotpassword");
        },
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              "Forgot Password?",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PasswordInputLogin extends StatelessWidget {
  const PasswordInputLogin({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
      child: Container(
        alignment: Alignment.centerLeft,
        height: 60,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color(0xffE1F2F2),
          border: Border.all(color: Color(0xff393E46), width: 0.3),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Container(
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black))),
          child: TextFormField(
            obscureText: true,
            validator: (val) {
              return val.length > 6 ? null : "Enter Password 6+ characters";
            },
            decoration: InputDecoration(
                icon: Icon(Icons.lock),
                hintText: "Password",
                hintStyle: TextStyle(color: Color(0xff667080)),
                border: InputBorder.none),
          ),
        ),
      ),
    );
  }
}

class UsernameInputLogin extends StatelessWidget {
  const UsernameInputLogin({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
      child: Container(
        alignment: Alignment.centerLeft,
        height: 60,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color(0xffE1F2F2),
          border: Border.all(color: Color(0xff393E46), width: 0.3),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Container(
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black))),
          child: TextFormField(
            validator: (val) {
              return RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(val)
                  ? null
                  : "Not Valid";
            },
            decoration: InputDecoration(
                icon: Icon(Icons.person),
                hintText: "Username",
                hintStyle: TextStyle(color: Color(0xff667080)),
                border: InputBorder.none),
          ),
        ),
      ),
    );
  }
}

class TopWelcomeImage extends StatelessWidget {
  const TopWelcomeImage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Image(image: AssetImage('assets/welcome.png')),
    );
  }
}
