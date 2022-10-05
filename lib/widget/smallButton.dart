import 'package:flutter/material.dart';

class SmallButton extends StatelessWidget {
  const SmallButton({
    required this.myText,
    required this.myColor,
    this.routeName,
    required this.onPressed,
    Key? key,
  }) : super(key: key);
  final String myText;
  final Color myColor;
  final String? routeName;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            color: myColor,
            borderRadius: BorderRadius.circular(800),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                myText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
