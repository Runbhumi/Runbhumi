import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

BottomNavigationBar buildBottomNavigationBar(
    BuildContext context, void Function(int) onTap, int currentIndex) {
  return BottomNavigationBar(
    onTap: onTap,
    type: BottomNavigationBarType.fixed,
    currentIndex: currentIndex,
    showUnselectedLabels: false,
    selectedFontSize: 13,
    selectedItemColor: Theme.of(context).primaryColor,
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
      new BottomNavigationBarItem(
        icon: Icon(Feather.users),
        activeIcon: Icon(Feather.users),
        label: 'Teams',
      ),
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
