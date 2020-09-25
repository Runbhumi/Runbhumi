import 'package:flutter/material.dart';
import 'placeholder_widget.dart';
import 'views.dart';

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  static final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>();
  int _currentIndex = 0;
  final List<Widget> _children = [
    Home(),
    PlaceholderWidget(Colors.green),
    AddPost(),
    PlaceholderWidget(Colors.yellow),
    PlaceholderWidget(Colors.redAccent),
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
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, // new
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex, // new
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: 'Network',
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Post',
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            label: 'Notifications',
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Profile')
        ],
      ),
    );
  }
}
