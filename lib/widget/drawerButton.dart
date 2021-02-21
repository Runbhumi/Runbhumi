import 'package:flutter/material.dart';

class DrawerButton extends StatelessWidget {
  const DrawerButton({
    Key key,
    @required this.onpressed,
    @required this.label,
    @required this.icon,
    this.beta,
  }) : super(key: key);

  final Function onpressed;
  final String label;
  final Widget icon;
  final bool beta;

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
      label: Row(
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.white),
          ),
          if (beta == true)
            Container(
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(8)),
              child: Text(
                "Beta",
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      icon: icon,
      textColor: Colors.white,
      color: Theme.of(context).primaryColor,
    );
  }
}
