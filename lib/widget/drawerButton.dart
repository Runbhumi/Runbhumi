import 'package:flutter/material.dart';

class DrawerButton extends StatelessWidget {
  const DrawerButton({
    Key? key,
    required this.onpressed,
    required this.label,
    required this.icon,
    this.beta,
  }) : super(key: key);

  final Function()? onpressed;
  final String label;
  final Widget icon;
  final bool? beta;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color?>(Colors.white),
        backgroundColor:
            MaterialStateProperty.all<Color?>(Theme.of(context).primaryColor),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry?>(
            EdgeInsets.symmetric(vertical: 4, horizontal: 4)),
        shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
          (_) {
            return RoundedRectangleBorder(
              side: BorderSide.none,
              borderRadius: BorderRadius.circular(8),
            );
          },
        ),
        elevation: MaterialStateProperty.all<double>(0),
      ),
      onPressed: onpressed,
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
    );
  }
}
