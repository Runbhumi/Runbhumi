import 'package:Runbhumi/services/auth.dart';
import 'package:Runbhumi/widget/widgets.dart';
import 'package:flutter/material.dart';

class GoogleOauth extends StatefulWidget {
  const GoogleOauth({
    Key key,
  }) : super(key: key);

  @override
  _GoogleOauthState createState() => _GoogleOauthState();
}

class _GoogleOauthState extends State<GoogleOauth> {
  bool state = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RaisedButton(
          color: Colors.white,
          onPressed: () async {
            setState(() => state = true);
            await signInWithGoogle().whenComplete(() {
              Navigator.pushReplacementNamed(context, "/mainapp");
            });
          },
          elevation: 1,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (state == false)
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16.0, top: 8, bottom: 8),
                    child: Image(image: AssetImage('assets/googleicon.png')),
                  ),
                if (state == false)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Continue with Google",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                if (state)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Loader(),
                  )
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
