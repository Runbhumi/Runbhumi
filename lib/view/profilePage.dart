import 'dart:async';
import 'package:Runbhumi/services/auth.dart';
import 'package:Runbhumi/utils/Constants.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widget/widgets.dart';
import 'package:firebase_core/firebase_core.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Widget _buildTitle(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Profile',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
  }

  //toggle for drawer(menu)
  void toggle() {
    animationController.isDismissed
        ? animationController.forward()
        : animationController.reverse();
    print("menu toggle");
  }

  //distance for profile to move right when the drawer is opened
  final double maxSlide = 225.0;

  final List teamsList = [
    "Chennai superKings",
    "Rajasthan Royals",
    "Delhi dare devils",
    "Manchester united"
  ];
  final List friendsList = ["cupcake", "lolipop", "oreo", "Pie"];

  @override
  Widget build(BuildContext context) {
    var myDrawer = SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.clear,
                  color: Colors.white,
                ),
                onPressed: toggle,
              );
            },
          ),
        ),
        body: DrawerBody(),
      ),
    );
    var myChild = DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: _buildTitle(context),
          centerTitle: true,
          elevation: 0,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.menu,
                ),
                onPressed: toggle,
              );
            },
          ),
        ),
        body: ProfileBody(
          teamsList: teamsList,
          friendsList: friendsList,
        ),
      ),
    );
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, _) {
        double slide = maxSlide * animationController.value;
        double scale = 1 - (animationController.value * 0.3);
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

class DrawerBody extends StatefulWidget {
  const DrawerBody({
    Key key,
  }) : super(key: key);

  @override
  _DrawerBodyState createState() => _DrawerBodyState();
}

class _DrawerBodyState extends State<DrawerBody> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DrawerButton(
          onpressed: () {},
          label: "Edit Profile",
          icon: Icon(
            Icons.edit_outlined,
            color: Colors.white,
          ),
        ),
        DrawerButton(
          onpressed: () {
            print("logout");
            Constants.prefs.setBool("loggedin", false);
            signOutGoogle();
            Navigator.pushReplacementNamed(context, "/secondpage");
          },
          label: 'Log out',
          icon: Icon(
            Icons.logout,
            color: Colors.white,
          ),
        ),
        DrawerButton(
          icon: Icon(
            Icons.info_outline,
            color: Colors.white,
          ),
          onpressed: () {
            print("go to more info");
            Navigator.pushNamed(context, "/moreinfo");
          },
          label: "More Info",
        ),
        DrawerButton(
          onpressed: () {},
          label: 'About Us',
          icon: Icon(
            Icons.engineering_outlined,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class ProfileBody extends StatefulWidget {
  const ProfileBody({
    Key key,
    this.teamsList,
    this.friendsList,
  }) : super(key: key);

  final List teamsList;
  final List friendsList;

  @override
  _ProfileBodyState createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  final db = FirebaseFirestore.instance;
  StreamSubscription sub;
  Map data;

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
    sub = db
        .collection('users')
        .doc(getCurrentUserId())
        .snapshots()
        .listen((snap) {
      setState(() {
        data = snap.data();
      });
    });
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (data['profileImage'] != null)
              Container(
                width: 150,
                height: 150,
                margin: EdgeInsets.only(top: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  image: DecorationImage(
                    image: NetworkImage(data['profileImage']),
                    fit: BoxFit.contain,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x44005F8F),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
              ),
            if (data['profileImage'] == null)
              Container(
                width: 150,
                height: 150,
                margin: EdgeInsets.only(top: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  image: DecorationImage(
                    image: AssetImage("assets/ProfilePlaceholder.png"),
                    fit: BoxFit.contain,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x3A353580),
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
                style: TextStyle(fontSize: 24),
              ),
            ),
            //Bio
            Padding(
              padding: const EdgeInsets.only(
                bottom: 8.0,
                left: 16.0,
                right: 16.0,
              ),
              child: Text(
                data['username'],
                style: TextStyle(fontSize: 14),
              ),
            ),
            //Tabs
            Tabs(),
            Expanded(
              child: TabBarView(
                children: [
                  ProfileTeamsList(widget: widget),
                  ProfileFriendsList(friendsList: widget.friendsList),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileTeamsList extends StatelessWidget {
  const ProfileTeamsList({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final ProfileBody widget;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            shadowColor: Color(0x44005F8F),
            elevation: 20,
            child: Container(
              height: 80,
              child: Center(
                child: ListTile(
                  title: Text(
                    widget.teamsList[index],
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
              ),
            ),
          ),
        );
      },
      itemCount: widget.teamsList.length,
    );
  }
}

class Tabs extends StatelessWidget {
  const Tabs({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(50.0),
      child: TabBar(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey,
        tabs: [
          Tab(child: Text("Teams")),
          Tab(child: Text("Friends")),
        ],
        indicator: new BubbleTabIndicator(
          indicatorHeight: 30.0,
          indicatorColor: Theme.of(context).primaryColor,
          tabBarIndicatorSize: TabBarIndicatorSize.tab,
        ),
      ),
    );
  }
}

class ProfileFriendsList extends StatelessWidget {
  final List friendsList;
  const ProfileFriendsList({
    this.friendsList = const [],
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.count(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        // Generate 10 widgets that display their index in the List.
        children: List.generate(
          friendsList.length,
          (index) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              shadowColor: Color(0x44005F8F),
              elevation: 20,
              child: Container(
                child: Column(
                  children: [
                    Center(
                      child: ListTile(
                        title: Text(
                          friendsList[index],
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        "assets/ProfilePlaceholder.png",
                        height: 100,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
