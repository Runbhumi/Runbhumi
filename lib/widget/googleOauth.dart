import 'package:Runbhumi/services/auth.dart';
import 'package:Runbhumi/utils/Constants.dart';
import 'package:flutter/material.dart';

class GoogleOauth extends StatelessWidget {
  const GoogleOauth({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RaisedButton(
          onPressed: () async {
            Constants.prefs.setBool("loggedin", true);
            await signInWithGoogle().whenComplete(() {
              Navigator.pushReplacementNamed(context, "/mainapp");
            });
          },
          elevation: 0,
          // height: 54,
          // decoration: BoxDecoration(
          //     color: Theme.of(context).buttonColor,
          //     borderRadius: BorderRadius.circular(800),
          //     boxShadow: [
          //       BoxShadow(
          //           color: Theme.of(context).buttonColor.withOpacity(.4),
          //           blurRadius: 6,
          //           offset: Offset(0, 5))
          //     ]),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 8, bottom: 8),
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
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0),
          ),
        ),
      ],
    );
  }
}
