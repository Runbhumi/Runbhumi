import '../views.dart';
import 'package:flutter/material.dart';
import '../../widget/widgets.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: BackButton(
              color: Colors.black,
            ),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
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
                      horizontal: 50.0, vertical: 40.0),
                  child: Container(
                    child: Text(
                      "Send us your Phone number, we will send you an OTP to reset you password",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                InputBox(
                  myText: "Phone Number",
                  hidden: false,
                  icon: Icon(Icons.phone),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Button(
                  myText: "Send",
                  myColor: Theme.of(context).accentColor,
                  //routeName: OtpInput(),
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

class BackBtn extends StatelessWidget {
  const BackBtn({
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
            child: Icon(Icons.arrow_back, color: Colors.black)));
  }
}
