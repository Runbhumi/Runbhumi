import 'package:flutter/material.dart';
import 'views.dart';
/*
  this has the bottom navigation bar of the app
*/

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  static final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>();
  int _currentIndex = 0;
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
      bottomNavigationBar: BottomNavigationBar(
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
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'views.dart';
// /*
//   this has the bottom navigation bar of the app
// */

// class MainApp extends StatefulWidget {
//   @override
//   _MainAppState createState() => _MainAppState();
// }

// class _MainAppState extends State<MainApp> {
//   static final GlobalKey<ScaffoldState> scaffoldKey =
//       new GlobalKey<ScaffoldState>();
//   final _navigatorKey = GlobalKey<NavigatorState>();
//   int _currentIndex = 0;
//   //add widgets of all relevant screens here
//   final List<Widget> _children = [
//     Home(),
//     Network(),
//     AddPost(),
//     Notifications(),
//     Profile(),
//   ];

//   void onTabTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: scaffoldKey,
//       body: Navigator(key: _navigatorKey, 
//       initialRoute: '/',
//       // child: _children[_currentIndex],
//       onGenerateRoute: (RouteSettings settings) {
//           WidgetBuilder builder;
//            switch (settings.name) {
//             case '/':
//               builder = (BuildContext context) => Home();
//               break;
//             case '/network':
//               builder = (BuildContext context) => Network();
//               break;
//             case '/addpost':
//               builder = (BuildContext context) => AddPost();
//               break;
//             case '/notifications':
//               builder = (BuildContext context) => Notifications();
//               break;
//             case '/profile':
//               builder = (BuildContext context) => Profile();
//               break;
//             default:
//               throw Exception('Invalid route: ${settings.name}');
//           }
//           // You can also return a PageRouteBuilder and
//           // define custom transitions between pages
//           return MaterialPageRoute(
//             builder: builder,
//             settings: settings,
//           );
//         },
//       ),
//       //bottom navbar
//       bottomNavigationBar: buildBottomNavigationBar(),
//     );
//   }

//   BottomNavigationBar buildBottomNavigationBar() {
//     return BottomNavigationBar(
//       onTap: onTabTapped,
//       type: BottomNavigationBarType.fixed,
//       currentIndex: _currentIndex,
//       showUnselectedLabels: false,
//       items: [
//         new BottomNavigationBarItem(
//           icon: Icon(Icons.home_outlined),
//           activeIcon: Icon(Icons.home),
//           label: 'Home',
//         ),
//         new BottomNavigationBarItem(
//           icon: Icon(Icons.people_outline),
//           activeIcon: Icon(Icons.people),
//           label: 'Network',
//         ),
//         new BottomNavigationBarItem(
//           icon: Icon(Icons.add_circle_outline),
//           activeIcon: Icon(Icons.add_circle),
//           label: 'Add Post',
//         ),
//         new BottomNavigationBarItem(
//           icon: Icon(Icons.notifications_outlined),
//           activeIcon: Icon(Icons.notifications),
//           label: 'Notifications',
//         ),
//         new BottomNavigationBarItem(
//           icon: Icon(Icons.person_outline),
//           activeIcon: Icon(Icons.person),
//           label: 'Profile',
//         ),
//       ],
//     );
//   }
// }


/*
import 'package:flutter/material.dart';
import 'package:social_app_ui/components/icon_badge.dart';
import 'package:social_app_ui/screens/chat/chats.dart';
import 'package:social_app_ui/screens/friends.dart';
import 'package:social_app_ui/screens/home.dart';
import 'package:social_app_ui/screens/notifications.dart';
import 'package:social_app_ui/screens/profile.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PageController _pageController;
  int _page = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: <Widget>[
          Chats(),
          Friends(),
          Home(),
          Notifications(),
          Profile(),
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
          canvasColor: Theme.of(context).primaryColor,
          // sets the active color of the `BottomNavigationBar` if `Brightness` is light
          primaryColor: Theme.of(context).accentColor,
          textTheme: Theme.of(context).textTheme.copyWith(
                caption: TextStyle(color: Colors.grey[500]),
              ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.message,
              ),
              title: Container(height: 0.0),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.group,
              ),
              title: Container(height: 0.0),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              title: Container(height: 0.0),
            ),
            BottomNavigationBarItem(
              icon: IconBadge(
                icon: Icons.notifications,
              ),
              title: Container(height: 0.0),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              title: Container(height: 0.0),
            ),
          ],
          onTap: navigationTapped,
          currentIndex: _page,
        ),
      ),
    );
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 2);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }
}
*/