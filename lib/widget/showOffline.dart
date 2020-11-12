import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ShowOffline extends StatelessWidget {
  const ShowOffline({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                Feather.wifi_off,
                size: 64,
                color: Colors.red[300],
              ),
              Text("It seems you are offline!",
                  style: TextStyle(
                      fontSize: 32,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              Text("Please check you internet connectivity",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
