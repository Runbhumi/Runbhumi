import 'package:Runbhumi/authentication/forgotPassword.dart';
import 'package:Runbhumi/authentication/signUp.dart';
import 'package:Runbhumi/components/button.dart';
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
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TopWelcomeImage(),
              UsernameInputLogin(),
              PasswordInputLogin(),
              ForgotPasswordAnchor(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [LoginMainBtn(), GoogleOauthSmall()],
              ),
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
                myWidget: SignUp(),
              ),
              SizedBox(
                height: 16.0,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LoginMainBtn extends StatelessWidget {
  const LoginMainBtn({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GestureDetector(
          onTap: () {},
          child: Container(
            height: 55,
            width: 100,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).primaryColor.withOpacity(.4),
                      blurRadius: 6,
                      offset: Offset(0, 5))
                ]),
            child: Center(
              child: Text(
                "Login",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          )),
    );
  }
}

class GoogleOauthSmall extends StatelessWidget {
  const GoogleOauthSmall({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GestureDetector(
          onTap: () {},
          child: Container(
            height: 55,
            width: 100,
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
                child: Image(image: AssetImage("assets/googleicon.png"))),
          )),
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
      padding: const EdgeInsets.only(left: 40.0, top: 8.0, bottom: 16.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ForgotPassword()));
        },
        child: Container(
          padding: EdgeInsets.all(8.0),
          alignment: Alignment.centerLeft,
          child: Text(
            "Forgot Password?",
            style: TextStyle(
              color: Color(0xFF3A3535),
              fontSize: 18,
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
                  : "Please Enter Correct Email";
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
