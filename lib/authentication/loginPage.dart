import 'package:Runbhumi/authentication/forgotPassword.dart';
import 'package:Runbhumi/authentication/signUp.dart';
import 'package:flutter/material.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F4F4),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              TopWelcomeImage(),
              Container(
                margin: EdgeInsets.all(20),
                alignment: Alignment.centerLeft,
                height: 60,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, .16),
                          blurRadius: 6,
                          offset: Offset(1, 1))
                    ]),
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
                        hintText: "Username",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(20),
                alignment: Alignment.centerLeft,
                height: 60,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, .16),
                          blurRadius: 6,
                          offset: Offset(1, 1))
                    ]),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.black))),
                  child: TextFormField(
                    validator: (val) {
                      return val.length > 6
                          ? null
                          : "Enter Password 6+ characters";
                    },
                    decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotPassword()));
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  padding: EdgeInsets.all(10),
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
              ContinueButton(),
              Center(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "New here? Create an account",
                    style: TextStyle(
                      color: Color(0xFF3A3535),
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              CreateAccountButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class CreateAccountButton extends StatelessWidget {
  const CreateAccountButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SignUp()));
          },
          child: Center(
            child: Container(
              height: 55,
              width: 250,
              margin: EdgeInsets.symmetric(horizontal: 50),
              decoration: BoxDecoration(
                  color: Color(0xFF3A3535),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromRGBO(58, 53, 53, .5),
                        blurRadius: 6,
                        offset: Offset(0, 5))
                  ]),
              child: Center(
                child: Text(
                  "Create an account",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          )),
    );
  }
}

class ContinueButton extends StatelessWidget {
  const ContinueButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
          onTap: () {},
          child: Container(
            height: 55,
            width: 250,
            decoration: BoxDecoration(
                color: Color(0xFFFF7315),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(225, 95, 27, .3),
                      blurRadius: 6,
                      offset: Offset(0, 5))
                ]),
            child: Center(
              child: Text(
                "Continue",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          )),
    );
  }
}

class TopWelcomeImage extends StatelessWidget {
  const TopWelcomeImage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Image(image: AssetImage('assets/loginPage.png')),
    );
  }
}
