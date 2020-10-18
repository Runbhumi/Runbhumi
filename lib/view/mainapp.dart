import 'package:flutter/material.dart';
import 'views.dart';
import '../widget/widgets.dart';
/*
  this has the bottom navigation bar of the app
*/

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

// GlobalKey<NavigatorState> _pageNavigatorKey = GlobalKey<NavigatorState>();

class _MainAppState extends State<MainApp> {
  int currentIndex = 0;
  final PageController pageController = PageController();
  //add widgets of all relevant screens here
  final List<Widget> _children = [
    Home(),
    Network(),
    // AddPost(),
    Notifications(),
    Profile(),
  ];

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: pageController,
        itemBuilder: (context, index) {
          return _children[index];
        },
        onPageChanged: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      //bottom navbar
      bottomNavigationBar:
          buildBottomNavigationBar(context, onTabTapped, currentIndex),
    );
  }
}
