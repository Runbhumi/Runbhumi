import 'package:Runbhumi/services/auth.dart';
import 'package:Runbhumi/utils/Constants.dart';
import 'package:flutter/material.dart';

class GoogleOauth extends StatelessWidget {
  const GoogleOauth({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          Constants.prefs.setBool("loggedin", true);
          await signInWithGoogle().whenComplete(() {
            Navigator.pushReplacementNamed(context, "/home");
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 55,
              width: 300,
              decoration: BoxDecoration(
                  color: Theme.of(context).buttonColor,
                  borderRadius: BorderRadius.circular(800),
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).buttonColor.withOpacity(.4),
                        blurRadius: 6,
                        offset: Offset(0, 5))
                  ]),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Image(image: AssetImage('assets/googleicon.png')),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "Continue with Google",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
