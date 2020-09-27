import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({
    @required this.myText,
    @required this.myColor,
    this.routeName,
    this.onPressed,
    Key key,
  }) : super(key: key);
  final String myText;
  final Color myColor;
  final String routeName;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
          onTap: onPressed ??
              () {
                print("going to " + routeName);
                Navigator.pushNamed(context, routeName);
              },
          child: Container(
            height: 55,
            width: 300,
            decoration: BoxDecoration(
                color: myColor,
                borderRadius: BorderRadius.circular(800),
                boxShadow: [
                  BoxShadow(
                      color: myColor.withOpacity(.4),
                      blurRadius: 6,
                      offset: Offset(0, 5))
                ]),
            child: Center(
              child: Text(
                myText,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          )),
    );
  }
}
