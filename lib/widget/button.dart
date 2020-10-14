import 'package:flutter/material.dart';

class Button extends StatefulWidget {
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
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
          onTap: widget.onPressed ??
              () {
                print("going to " + widget.routeName);
                Navigator.pushNamed(context, widget.routeName);
              },
          child: Container(
            height: 55,
            width: 300,
            decoration: BoxDecoration(
                color: widget.myColor,
                borderRadius: BorderRadius.circular(800),
                boxShadow: [
                  BoxShadow(
                      color: widget.myColor.withOpacity(.4),
                      blurRadius: 6,
                      offset: Offset(0, 5))
                ]),
            child: Center(
              child: Text(
                widget.myText,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          )),
    );
  }
}
