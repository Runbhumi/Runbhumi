import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

BottomNavigationBar buildBottomNavigationBar(
    BuildContext context, void Function(int) onTap, int currentIndex) {
  return BottomNavigationBar(
    onTap: onTap,
    type: BottomNavigationBarType.fixed,
    currentIndex: currentIndex,
    showUnselectedLabels: false,
    unselectedItemColor: Theme.of(context).primaryColor.withOpacity(0.5),
    items: [
      new BottomNavigationBarItem(
        icon: Icon(Feather.home),
        activeIcon: Icon(Feather.home),
        label: 'Home',
      ),
      new BottomNavigationBarItem(
        icon: Icon(Feather.message_square),
        activeIcon: Icon(Feather.message_square),
        label: 'Message',
      ),
      // new BottomNavigationBarItem(
      //   icon: Icon(Feather.plus_circle),
      //   activeIcon: Icon(Feather.plus_circle),
      //   label: 'Add Post',
      // ),
      new BottomNavigationBarItem(
        icon: Icon(Feather.bell),
        activeIcon: Icon(Feather.bell),
        label: 'Notifications',
      ),
      new BottomNavigationBarItem(
        icon: Icon(Feather.user),
        activeIcon: Icon(Feather.user),
        label: 'Profile',
      ),
    ],
  );
}
