import 'package:flutter/material.dart';

class DrawerButton extends StatelessWidget {
  const DrawerButton({
    Key key,
    @required this.onpressed,
    @required this.label,
    @required this.icon,
  }) : super(key: key);

  final Function onpressed;
  final String label;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return FlatButton.icon(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      onPressed: onpressed,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0),
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(0))),
      label: Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
      icon: icon,
      textColor: Colors.white,
      color: Theme.of(context).primaryColor,
    );
  }
}
