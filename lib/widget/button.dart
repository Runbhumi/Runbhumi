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
    // return Padding(
    //   padding: const EdgeInsets.all(8.0),
    //   child: FlatButton(
    //     color: widget.myColor,
    //     height: 54,
    //     minWidth: 300,
    //     onPressed: widget.onPressed ??
    //         () {
    //           print("going to " + widget.routeName);
    //           Navigator.pushNamed(context, widget.routeName);
    //         },
    //     child: Center(
    //       child: Text(
    //         widget.myText,
    //         style: TextStyle(
    //             color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
    //       ),
    //     ),
    //   ),
    // );
    return RaisedButton(
      textColor: Colors.white,
      elevation: 0,
      color: widget.myColor,
      child: Text(
        widget.myText,
        style: TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
      ),
      onPressed: widget.onPressed ??
          () {
            print("going to " + widget.routeName);
            Navigator.pushNamed(context, widget.routeName);
          },
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(30.0),
      ),
    );
  }
}
