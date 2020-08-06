import 'package:flutter/material.dart';
import 'package:runbhumi_ui/authentication/forgotPassword.dart';
import 'package:runbhumi_ui/authentication/signUp.dart';

class loginPage extends StatefulWidget {
  @override
  _loginPageState createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F4F4),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20),
                child: Image(image: AssetImage('assets/loginPage.png')),
              ),
              SizedBox(
                height: 20.0,
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
              SizedBox(
                height: 30.0,
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
              SizedBox(
                height: 30.0,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => forgotPassword()));
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: Color(0xFF3A3535),
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              GestureDetector(
                  onTap: () {},
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
                        "Login",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )),
              SizedBox(
                height: 30.0,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                padding: EdgeInsets.all(10),
                child: Text(
                  "New here? Create an account",
                  style: TextStyle(
                    color: Color(0xFF3A3535),
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => signUp()));
                  },
                  child: Container(
                    height: 55,
                    width: 250,
                    margin: EdgeInsets.symmetric(horizontal: 50),
                    decoration:
                        BoxDecoration(color: Color(0xFF3A3535), boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(225, 95, 27, .3),
                          blurRadius: 40,
                          offset: Offset(0, 10))
                    ]),
                    child: Center(
                      child: Text(
                        "Create an account",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )),
              SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
