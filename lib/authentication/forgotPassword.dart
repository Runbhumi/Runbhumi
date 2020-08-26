import 'package:Runbhumi/authentication/checkMail.dart';
import 'package:Runbhumi/authentication/loginPage.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F4F4),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Icon(Icons.arrow_back)),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(50, 0, 50, 0),
                padding: EdgeInsets.fromLTRB(20, 0, 10, 10),
                child: Image(
                  image: AssetImage('assets/forgotPass.png'),
                  height: 400,
                  width: 300,
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(70, 10, 70, 70),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Enter your E-mail to reset your password",
                  style: TextStyle(
                    fontSize: 20,
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
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(225, 95, 27, .3),
                          blurRadius: 40,
                          offset: Offset(0, 10))
                    ]),
                child: TextFormField(
                  validator: (val) {
                    return RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(val)
                        ? null
                        : "Please Enter Correct Email";
                  },
                  decoration: InputDecoration(
                      hintText: "Email",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none),
                ),
              ),
              GestureDetector(
                  onTap: () {
                    //send email via backend then
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => CheckMail()));
                  },
                  child: Container(
                    height: 55,
                    width: 250,
                    margin: EdgeInsets.symmetric(horizontal: 50),
                    decoration:
                        BoxDecoration(color: Color(0xFFFF7315), boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(225, 95, 27, .3),
                          blurRadius: 40,
                          offset: Offset(0, 10))
                    ]),
                    child: Center(
                      child: Text(
                        "Send E-Mail",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
