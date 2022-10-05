import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

class ShowOffline extends StatelessWidget {
  const ShowOffline({
    Key? key,
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
                UniconsLine.wifi_slash,
                size: 64,
                color: Colors.red[300],
              ),
              Text("It seems you are offline!",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              Text("Please check you internet connectivity",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
