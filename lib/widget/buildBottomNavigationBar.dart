// import 'package:flutter/material.dart';
// import 'package:unicons/unicons.dart';

// BottomNavigationBar buildBottomNavigationBar(
//     BuildContext context, void Function(int) onTap, int currentIndex) {
//   return BottomNavigationBar(
//     onTap: onTap,
//     type: BottomNavigationBarType.fixed,
//     currentIndex: currentIndex,
//     showUnselectedLabels: false,
//     selectedFontSize: 13,
//     selectedItemColor: Theme.of(context).primaryColor,
//     unselectedItemColor: Theme.of(context).primaryColor.withOpacity(0.5),
//     items: [
//       new BottomNavigationBarItem(
//         icon: Icon(UniconsLine.compass),
//         activeIcon: Icon(UniconsLine.compass),
//         label: 'Explore',
//       ),
//       new BottomNavigationBarItem(
//         icon: Icon(UniconsLine.message_square),
//         activeIcon: Icon(UniconsLine.message_square),
//         label: 'Message',
//       ),
//       new BottomNavigationBarItem(
//         icon: Icon(UniconsLine.users),
//         activeIcon: Icon(UniconsLine.users),
//         label: 'Teams',
//       ),
//       new BottomNavigationBarItem(
//         icon: Icon(UniconsLine.bell),
//         activeIcon: Icon(UniconsLine.bell),
//         label: 'Notifications',
//       ),
//       new BottomNavigationBarItem(
//         icon: Icon(UniconsLine.user),
//         activeIcon: Icon(UniconsLine.user),
//         label: 'Profile',
//       ),
//     ],
//   );
// }

import 'package:runbhumi/view/views.dart';
import 'package:runbhumi/widget/showOffline.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

class AnimatedBottomBar extends StatefulWidget {
  @override
  _AnimatedBottomBarState createState() => _AnimatedBottomBarState();
}

class _AnimatedBottomBarState extends State<AnimatedBottomBar> {
  late int _currentPage;

  @override
  void initState() {
    _currentPage = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConnectivityWidgetWrapper(
        offlineWidget: ShowOffline(),
        child: getPage(_currentPage),
      ),
      bottomNavigationBar: AnimatedBottomNav(
          currentIndex: _currentPage,
          onChange: (index) {
            setState(() {
              _currentPage = index;
            });
          }),
    );
  }

  getPage(int page) {
    switch (page) {
      case 0:
        return ExploreEvents();
      case 1:
        return MessagePage();
      case 2:
        return TeamsList();
      case 3:
        return Notifications();
      case 4:
        return Profile();
    }
  }
}

class AnimatedBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onChange;
  const AnimatedBottomNav(
      {Key? key, required this.currentIndex, required this.onChange})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight,
      decoration: BoxDecoration(
        color: Theme.of(context)
            .bottomNavigationBarTheme
            .backgroundColor!
            .withOpacity(0.3),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => onChange(0),
              child: BottomNavItem(
                icon: UniconsLine.compass,
                title: "Explore",
                isActive: currentIndex == 0,
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => onChange(1),
              child: BottomNavItem(
                icon: UniconsLine.message,
                title: "Message",
                isActive: currentIndex == 1,
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => onChange(2),
              child: BottomNavItem(
                icon: UniconsLine.user,
                title: "Teams",
                isActive: currentIndex == 2,
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => onChange(3),
              child: BottomNavItem(
                icon: UniconsLine.bell,
                title: "Notifications",
                isActive: currentIndex == 3,
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => onChange(4),
              child: BottomNavItem(
                icon: UniconsLine.user,
                title: "Profile",
                isActive: currentIndex == 4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final bool isActive;
  final IconData icon;
  final Color? activeColor;
  final Color? inactiveColor;
  final String title;
  const BottomNavItem({
    Key? key,
    this.isActive = false,
    required this.icon,
    this.activeColor,
    this.inactiveColor,
    required this.title,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
      duration: Duration(milliseconds: 300),
      reverseDuration: Duration(milliseconds: 200),
      child: isActive
          ? Container(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      title,
                      softWrap: false,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: activeColor ?? Theme.of(context).primaryColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Container(
                    width: 5.0,
                    height: 5.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: activeColor ?? Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            )
          : SizedBox(
              height: kToolbarHeight,
              child: Icon(
                icon,
                color: inactiveColor ?? Colors.grey,
              ),
            ),
    );
  }
}
