import 'package:flutter/material.dart';

Widget buildTitle(BuildContext context, String text) {
  return new Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12.0),
    child: Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 24,
        color: Theme.of(context).backgroundColor.withOpacity(0.85),
      ),
    ),
  );
}
