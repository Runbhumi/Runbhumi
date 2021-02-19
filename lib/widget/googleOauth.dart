import 'package:Runbhumi/services/auth.dart';
import 'package:Runbhumi/utils/Constants.dart';
import 'package:Runbhumi/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

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
        OutlineButton(
          color: Colors.white,
          onPressed: () async {
            setState(() => state = true);
            await signInWithGoogle().catchError((err) {
              setState(() => state = false);
              print('there is an error while authenticationg: ');
              print(err);
              showDialog(
                context: context,
                builder: (context) {
                  return authError(context);
                },
              );
            }).then((_) {
              if (Constants.prefs.getString('userId') != null) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AnimatedBottomBar()));
              }
            });
          },
          borderSide: BorderSide(
              color: Theme.of(context).backgroundColor.withOpacity(0.7),
              width: 2.0),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (state == false)
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16.0, top: 8, bottom: 8),
                    child: Image(
                        image: AssetImage('assets/googleicon.png'), width: 24),
                  ),
                if (state == false)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Continue with Google",
                      style: TextStyle(fontSize: 18),
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
            borderRadius: new BorderRadius.circular(16.0),
          ),
        ),
      ],
    );
  }
}

SimpleDialog authError(BuildContext context) {
  return SimpleDialog(
    title: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: Icon(
            Feather.info,
            size: 64,
          )),
        ),
        Center(child: Text("Error during authentication")),
      ],
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    children: [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
            child: Text(
                "There was an error which occured during authentication. Please try again",
                style: Theme.of(context).textTheme.subtitle1)),
      ),
    ],
  );
}
