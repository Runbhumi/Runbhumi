import 'package:flutter/material.dart';

class DividingOr extends StatelessWidget {
  const DividingOr({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Container(
          height: 1.0,
          width: 100.0,
          color: Colors.black,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text("OR"),
        ),
        Container(
          height: 1.0,
          width: 100.0,
          color: Colors.black,
        ),
      ]),
    );
  }
}
