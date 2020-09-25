import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppBottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      elevation: 10,
      items: [
        BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.home, size: 20)),
        BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.userFriends, size: 20)),
        BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.plus, size: 20)),
        BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.solidBell, size: 20)),
        BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.solidUserCircle, size: 20)),
      ].toList(),
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.black54,
      onTap: (int idx) {
        switch (idx) {
          case 0:
            Navigator.pushNamed(context, '/home');
            break;
          case 1:
            Navigator.pushNamed(context, '/about');
            break;
          case 2:
            Navigator.pushNamed(context, '/addpost');
            break;
          case 3:
            Navigator.pushNamed(context, '/profile');
            break;
          case 4:
            Navigator.pushNamed(context, '/profile');
            break;
        }
      },
    );
  }
}
