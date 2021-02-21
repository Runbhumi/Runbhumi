import 'dart:async';
import 'package:Runbhumi/utils/Constants.dart';
import 'package:Runbhumi/view/profile/profileFriendsList.dart';
import 'package:Runbhumi/widget/customAnimatedContainer.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../views.dart';
import '../../widget/widgets.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
  static _ProfileState of(BuildContext context) =>
      context.findAncestorStateOfType<_ProfileState>();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  AnimationController animationController;

  final db = FirebaseFirestore.instance;
  StreamSubscription sub;
  Map data;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    sub = db
        .collection('users')
        .doc(Constants.prefs.getString('userId'))
        .snapshots()
        .listen((snap) {
      setState(() {
        data = snap.data();
        loading = true;
      });
    });
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }

  // starting radius
  var _myValue = 0.0;

// ending radius
  final _myNewValue = 48.0;

  //toggle for drawer(menu)
  void toggle() {
    setState(() {
      if (_myValue == _myNewValue) {
        _myValue = 0;
      } else {
        _myValue = _myNewValue;
      }
    });
    animationController.isDismissed
        ? animationController.forward()
        : animationController.reverse();
    print("menu toggle");
  }

  //distance for profile to move right when the drawer is opened
  //variables for drawer animations
  static const double maxSlide = 300.0;

  @override
  Widget build(BuildContext context) {
    var myDrawer = Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        // to close drawer
        leading: Builder(
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey[200].withOpacity(0.2),
                    width: 0.2,
                  ),
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(
                    Feather.x,
                    color: Colors.white,
                  ),
                  onPressed: toggle,
                ),
              ),
            );
          },
        ),
      ),
      body: DrawerBody(),
    );

    var _myDuration = Duration(milliseconds: 300);
    var myChild = CustomAnimatedContainer(
      curve: Curves.easeInOut,
      clipBehavior: Clip.antiAlias,
      duration: _myDuration,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_myValue),
      ),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: loading
                ? buildTitle(context, data["username"] ?? "Profile")
                : null,
            centerTitle: true,
            elevation: 0,
            leading: Builder(
              builder: (BuildContext context) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey[200].withOpacity(0.2),
                        width: 0.2,
                      ),
                      color: Colors.grey.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Feather.menu,
                      ),
                      onPressed: toggle,
                    ),
                  ),
                );
              },
            ),
            bottom: TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(child: Text("Profile")),
                Tab(child: Text("Friends")),
                Tab(child: Text("Schedule")),
              ],
              indicator: new BubbleTabIndicator(
                indicatorHeight: 30.0,
                indicatorColor: Theme.of(context).primaryColor,
                tabBarIndicatorSize: TabBarIndicatorSize.tab,
              ),
            ),
          ),
          body: ProfileBody(data: data),
        ),
      ),
    );
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, _) {
        double slide = maxSlide * animationController.value;
        double scale = 1 - (animationController.value * 0.2);
        return Stack(
          children: [
            myDrawer,
            Transform(
              child: myChild,
              transform: Matrix4.identity()
                ..translate(slide)
                ..scale(scale),
              alignment: Alignment.centerLeft,
            ),
          ],
        );
      },
    );
  }
}

class ProfileBody extends StatefulWidget {
  final Map data;
  const ProfileBody({
    @required this.data,
    Key key,
  }) : super(key: key);

  @override
  _ProfileBodyState createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  @override
  Widget build(BuildContext context) {
    if (Profile.of(context).loading) {
      return Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: TabBarView(
                  children: [
                    MainUserProfile(data: widget.data),
                    ProfileFriendsList(),
                    Schedule(),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Loader();
    }
  }
}

class MainUserProfile extends StatelessWidget {
  const MainUserProfile({
    Key key,
    @required this.data,
  }) : super(key: key);

  final Map data;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          //profile image
          if (data['profileImage'] != null)
            Container(
              width: 115,
              height: 115,
              clipBehavior: Clip.antiAlias,
              margin: EdgeInsets.only(top: 8),
              child: FadeInImage(
                image: NetworkImage(data['profileImage']),
                fit: BoxFit.fitWidth,
                placeholder: AssetImage("assets/ProfilePlaceholder.png"),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(32)),
                // image: DecorationImage(
                //   image: NetworkImage(data['profileImage']),
                //   fit: BoxFit.fitWidth,
                // ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0800d2ff),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
            ),
          //Name
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              data['name'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
          ),
          //Bio
          Padding(
            padding: const EdgeInsets.only(
              bottom: 8.0,
              left: 32.0,
              right: 32.0,
            ),
            child: Center(
              child: Text(
                data['bio'],
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          //stats
          Column(
            children: <Widget>[
              Card(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            data['eventCount'].toString(),
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "Events",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(16.0),
                    //   child: Column(
                    //     children: [
                    //       Text(
                    //         data['teamsCount'].toString(),
                    //         style: TextStyle(
                    //             fontSize: 24, fontWeight: FontWeight.w500),
                    //       ),
                    //       Text(
                    //         "Teams",
                    //         style: TextStyle(
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    GestureDetector(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              data['friendCount'].toString(),
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "Friends",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          //details
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (data["age"] != "")
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Icon(
                            Icons.cake_outlined,
                            size: 24.0,
                          ),
                        ),
                      ),
                      Text(
                        data["age"],
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Icon(
                          Feather.mail,
                          size: 24.0,
                        ),
                      ),
                    ),
                    Text(
                      data["emailId"],
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                if (data['phoneNumber']['show'])
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Icon(
                            Feather.phone,
                            size: 24.0,
                          ),
                        ),
                      ),
                      Text(
                        data['phoneNumber']['ph'],
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                if (data["location"] != "")
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Icon(
                            Feather.map_pin,
                            size: 24.0,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          data["location"],
                          style: TextStyle(
                            fontSize: 16,
                          ),
                          maxLines: 3,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/*
Text Spanning can be used to give user a feeling of auto completion
*/
