import 'package:flutter/material.dart';
import 'views.dart';
import 'package:flutter_icons/flutter_icons.dart';
/*
  this has the bottom navigation bar of the app
*/

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

// GlobalKey<NavigatorState> _pageNavigatorKey = GlobalKey<NavigatorState>();

class _MainAppState extends State<MainApp> {
  int _currentIndex = 0;
  final PageController pageController = PageController();
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
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // body: _children[_currentIndex],
        body: PageView.builder(
          controller: pageController,
          itemBuilder: (context, index) {
            return _children[index];
          },
          // children: _children,
          onPageChanged: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
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
          icon: Icon(Feather.home),
          activeIcon: Icon(Feather.home),
          label: 'Home',
        ),
        new BottomNavigationBarItem(
          icon: Icon(Feather.users),
          activeIcon: Icon(Feather.users),
          label: 'Network',
        ),
        new BottomNavigationBarItem(
          icon: Icon(Feather.plus_circle),
          activeIcon: Icon(Feather.plus_circle),
          label: 'Add Post',
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
}
