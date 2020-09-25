import 'package:flutter/material.dart';

class InputBox extends StatelessWidget {
  const InputBox({
    @required this.myText,
    this.hidden,
    this.helptext,
    this.sufIcon,
    this.icon,
    Key key,
  }) : super(key: key);

  final String myText;
  final bool hidden;
  final String helptext;
  final Icon sufIcon;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
      child: TextFormField(
        obscureText: hidden,
        validator: (val) {
          return val.length > 8 ? null : "Enter Password 8+ characters";
        },
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: new BorderRadius.circular(50),
            ),
            prefixIcon: icon,
            suffixIcon: sufIcon,
            helperText: helptext,
            filled: true,
            fillColor: Color(0xffeeeeee),
            hintText: myText,
            hintStyle: TextStyle(color: Color(0xff393E46))),
      ),
    );
  }
}
