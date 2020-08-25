import 'package:Runbhumi/authentication/loginPage.dart';
import 'package:flutter/material.dart';


class CheckMail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F4F4),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(50, 0, 50, 0),
                padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                child: Image(
                  image: AssetImage('assets/checkmail.png'),
                  height: 400,
                  width: 300,
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(80, 0, 70, 70),
                alignment: Alignment.center,
                child: Text(
                  "We have sent you a mail, follow the instructions to reset your password",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
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
                        "Go back to login",
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
