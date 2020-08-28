import 'package:Runbhumi/authentication/checkMail.dart';
import 'package:Runbhumi/authentication/loginPage.dart';
import 'package:Runbhumi/components/button.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                BackButton(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 20.0),
                  child: Container(
                    alignment: Alignment.center,
                    child: Image(
                      image: AssetImage('assets/forgotpassword.png'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 40.0),
                  child: Container(
                    child: Text(
                      "Send us your Email, we will send you the instructions to reset you password",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 40.0),
                  child: EmailInputLogin(),
                ),
                Button(
                  myText: "Continue",
                  myColor: Theme.of(context).accentColor,
                  myWidget: CheckMail(),
                ),
                SizedBox(
                  height: 16.0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmailInputLogin extends StatelessWidget {
  const EmailInputLogin({
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
                icon: Icon(Icons.mail),
                hintText: "E-mail",
                hintStyle: TextStyle(color: Color(0xff667080)),
                border: InputBorder.none),
          ),
        ),
      ),
    );
  }
}

class BackButton extends StatelessWidget {
  const BackButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        },
        child: Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Icon(Icons.arrow_back_ios,
                color: Theme.of(context).primaryColor)));
  }
}
