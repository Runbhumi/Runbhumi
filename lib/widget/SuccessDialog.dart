import 'package:flutter/material.dart';

SimpleDialog successDialog(BuildContext context) {
  return SimpleDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    children: [
      Center(
          child:
              Text("Post added", style: Theme.of(context).textTheme.headline4)),
      Image.asset("assets/confirmation-illustration.png"),
    ],
  );
}
