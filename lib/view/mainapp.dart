import 'package:flutter/material.dart';
import 'views.dart';
/*
  this has the bottom navigation bar of the app
*/

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

GlobalKey<NavigatorState> _pageNavigatorKey = GlobalKey<NavigatorState>();

class _MainAppState extends State<MainApp> {
  static final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>();
  int _currentIndex = 0;
  // final PageController _pageController = PageController();
  //add widgets of all relevant screens here
  final List<Widget> _children = [
    Home(),
    Network(),
    AddPost(),
    Notifications(),
    Profile(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        body: _children[_currentIndex],
        //bottom navbar
        bottomNavigationBar: buildBottomNavigationBar());
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      onTap: onTabTapped,
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      showUnselectedLabels: false,
      items: [
        new BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        new BottomNavigationBarItem(
          icon: Icon(Icons.people_outline),
          activeIcon: Icon(Icons.people),
          label: 'Network',
        ),
        new BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          activeIcon: Icon(Icons.add_circle),
          label: 'Add Post',
        ),
        new BottomNavigationBarItem(
          icon: Icon(Icons.notifications_outlined),
          activeIcon: Icon(Icons.notifications),
          label: 'Notifications',
        ),
        new BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
