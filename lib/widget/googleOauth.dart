import 'package:runbhumi/services/auth.dart';

import 'package:runbhumi/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:unicons/unicons.dart';

class GoogleOauth extends StatefulWidget {
  const GoogleOauth({
    Key? key,
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
        Button(
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
              if (GetStorage().read('userId') != null) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AnimatedBottomBar()));
              }
            });
          },
          buttonTitle: state ? "loading..." : "Continue with Google",
          bgColor: Colors.white,
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
            UniconsLine.info,
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
