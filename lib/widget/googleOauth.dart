import 'package:Runbhumi/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:Runbhumi/view/views.dart';

// for now i am taking back to the login page but firebase will reflect entry

class GoogleOauth extends StatelessWidget {
  const GoogleOauth({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          await signInWithGoogle().whenComplete(() {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return MainApp();
                },
              ),
            );
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 55,
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
                        style: TextStyle(color: Colors.black, fontSize: 20),
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
