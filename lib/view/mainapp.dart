// // import 'package:runbhumi/widget/showOffline.dart';
// import 'package:flutter/material.dart';
// import 'views.dart';
// // import '../widget/widgets.dart';
// // import 'package:connectivity_widget/connectivity_widget.dart';
// /*
//   this has the bottom navigation bar of the app
// */

// class MainApp extends StatefulWidget {
//   @override
//   _MainAppState createState() => _MainAppState();
// }

// class _MainAppState extends State<MainApp> {
//   int _currentIndex = 2;
//   final PageController _pageController = PageController(initialPage: 2);
//   //add widgets of all relevant screens here
//   final List<Widget> _children = [
//     ExploreEvents(),
//     MessagePage(),
//     TeamsList(),
//     Notifications(),
//     Profile(),
//   ];

//   void onTabTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//     _pageController.animateToPage(index,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOutCubic);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PageView.builder(
//         controller: _pageController,
//         itemCount: 5,
//         itemBuilder: (context, index) {
//           // return ConnectivityWidget(builder: (context, isOnline) {
//           //   return isOnline ? _children[index] : ShowOffline();
//           // });
//           return _children[index];
//         },
//         onPageChanged: (int index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//       ),
//       //bottom navbar
//       // bottomNavigationBar:
//       //     buildBottomNavigationBar(context, onTabTapped, _currentIndex),
//     );
//   }
// }
