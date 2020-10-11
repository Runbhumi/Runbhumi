import 'dart:async';
import 'dart:ui';
import 'package:Runbhumi/services/UserServices.dart';
import 'package:Runbhumi/services/auth.dart';
import 'package:Runbhumi/utils/Constants.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../widget/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:Runbhumi/utils/theme_config.dart';
import 'package:provider/provider.dart';

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
  static const double maxSlide = 250.0;
  static const double minDragStartEdge = 60;
  static const double maxDragStartEdge = maxSlide - 16;
  bool _canBeDragged = false;

  final List teamsList = [
    "Chennai superKings",
    "Rajasthan Royals",
    "Delhi dare devils",
    "Manchester united"
  ];

  @override
  Widget build(BuildContext context) {
    var myDrawer = SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(
                    Feather.x,
                    color: Colors.white,
                  ),
                  onPressed: toggle,
                );
              },
            ),
          ),
          body: DrawerBody(),
        ),
      ),
    );
    var myChild = DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: _buildTitle(context),
          centerTitle: true,
          elevation: 0,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Feather.menu,
                ),
                onPressed: toggle,
              );
            },
          ),
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(child: Text("Profile")),
              Tab(child: Text("Teams")),
              Tab(child: Text("Friends")),
            ],
            indicator: new BubbleTabIndicator(
              indicatorHeight: 30.0,
              indicatorColor: Theme.of(context).primaryColor,
              tabBarIndicatorSize: TabBarIndicatorSize.tab,
            ),
          ),
        ),
        body: ProfileBody(
          teamsList: teamsList,
        ),
      ),
    );
    return GestureDetector(
      onHorizontalDragStart: _onDragStart,
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      child: AnimatedBuilder(
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
      ),
    );
  }

  void _onDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft = animationController.isDismissed &&
        details.globalPosition.dx < minDragStartEdge;
    bool isDragCloseFromRight = animationController.isCompleted &&
        details.globalPosition.dx > maxDragStartEdge;

    _canBeDragged = isDragOpenFromLeft || isDragCloseFromRight;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_canBeDragged) {
      double delta = details.primaryDelta / maxSlide;
      animationController.value += delta;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    //I have no idea what it means, copied from Drawer
    double _kMinFlingVelocity = 365.0;

    if (animationController.isDismissed || animationController.isCompleted) {
      return;
    }
    if (details.velocity.pixelsPerSecond.dx.abs() >= _kMinFlingVelocity) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx /
          MediaQuery.of(context).size.width;

      animationController.fling(velocity: visualVelocity);
    } else if (animationController.value < 0.5) {
      animationController.reverse();
    } else {
      animationController.forward();
    }
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
    final theme = Provider.of<ThemeNotifier>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 0, 36),
          child: Container(
            child: Text(
              "Hello,\n" + Constants.prefs.getString('name'),
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        DrawerButton(
          onpressed: () {},
          label: "Home",
          icon: Icon(
            Feather.home,
            color: Colors.white,
          ),
        ),
        DrawerButton(
          onpressed: () {},
          label: "Create or Join Teams",
          icon: Icon(
            Feather.user_plus,
            color: Colors.white,
          ),
        ),
        DrawerButton(
          onpressed: () {
            Navigator.pushNamed(context, "/editprofile");
          },
          label: "Edit Profile",
          icon: Icon(
            Feather.edit,
            color: Colors.white,
          ),
        ),
        // More Info
        DrawerButton(
          icon: Icon(
            Feather.info,
            color: Colors.white,
          ),
          onpressed: () {
            print("go to more info");
            Navigator.pushNamed(context, "/moreinfo");
          },
          label: "More Info",
        ),
        //About US
        // DrawerButton(
        //   onpressed: () {},
        //   label: 'About Us',
        //   icon: Icon(
        //     Icons.engineering_outlined,
        //     color: Colors.white,
        //   ),
        // ),

        // Dark mode switch
        DrawerButton(
          onpressed: () {
            theme.switchTheme();
          },
          label: theme.myTheme == MyTheme.Light ? 'Dark Mode' : "Light Mode",
          icon: theme.myTheme == MyTheme.Light
              ? Icon(
                  Feather.sun,
                  color: Colors.white,
                )
              : Icon(Feather.moon),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Container(
            color: Colors.white54,
            height: 2,
            width: 150,
          ),
        ),
        //log out
        DrawerButton(
          onpressed: () {
            print("logout");
            Constants.prefs.setBool("loggedin", false);
            signOutGoogle();
            Navigator.pushReplacementNamed(context, "/secondpage");
          },
          label: 'Log Out',
          icon: Icon(
            Feather.log_out,
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
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
    sub = db
        .collection('users')
        .doc(Constants.prefs.getString('userId'))
        .snapshots()
        .listen((snap) {
      setState(() {
        data = snap.data();
        _loading = true;
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
    if (_loading) {
      return Center(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: TabBarView(
                  children: [
                    MainUserProfile(data: data),
                    ProfileTeamsList(widget: widget),
                    ProfileFriendsList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        child: Center(
          child: CircularProgressIndicator(
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ),
      );
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
    return Column(children: [
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
                color: Color(0x44393e46),
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
    ]);
  }
}

class ProfileTeamsList extends StatefulWidget {
  const ProfileTeamsList({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final ProfileBody widget;

  @override
  _ProfileTeamsListState createState() => _ProfileTeamsListState();
}

class _ProfileTeamsListState extends State<ProfileTeamsList> {
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
            shadowColor: Color(0x44393e46),
            elevation: 20,
            child: Container(
              height: 80,
              child: Center(
                child: ListTile(
                  title: Text(
                    widget.widget.teamsList[index],
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
              ),
            ),
          ),
        );
      },
      itemCount: widget.widget.teamsList.length,
    );
  }
}

// class Tabs extends StatelessWidget {
//   const Tabs({
//     Key key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return PreferredSize(
//       preferredSize: Size.fromHeight(50.0),
//       child: TabBar(
//         labelColor: Colors.white,
//         unselectedLabelColor: Colors.grey,
//         tabs: [
//           Tab(child: Text("Teams")),
//           Tab(child: Text("Friends")),
//         ],
//         indicator: new BubbleTabIndicator(
//           indicatorHeight: 30.0,
//           indicatorColor: Theme.of(context).primaryColor,
//           tabBarIndicatorSize: TabBarIndicatorSize.tab,
//         ),
//       ),
//     );
//   }
// }

class ProfileFriendsList extends StatefulWidget {
  @override
  _ProfileFriendsListState createState() => _ProfileFriendsListState();
}

class _ProfileFriendsListState extends State<ProfileFriendsList> {
  Stream userFriend;
  TextEditingController friendsSearch;
  String searchQuery = "";
  void initState() {
    super.initState();
    // Firebase.initializeApp().whenComplete(() {
    //   print("completed");
    //   setState(() {});
    // });
    friendsSearch = new TextEditingController();
    getUserFriends();
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
    print("searched " + newQuery);
  }

  getUserFriends() async {
    UserService().getFriends().then((snapshots) {
      setState(() {
        userFriend = snapshots;
        print("we got the data + ${userFriend.toString()} ");
      });
    });
  }

  Widget friends() {
    return StreamBuilder(
      stream: userFriend,
      builder: (context, asyncSnapshot) {
        print("Working");
        return asyncSnapshot.hasData
            ? asyncSnapshot.data.documents.length > 0
                ? ListView.builder(
                    itemCount: asyncSnapshot.data.documents.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Card(
                          shadowColor: Color(0x44393e46),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          elevation: 20,
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                child: ListTile(
                                    leading: Container(
                                      height: 100,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        child: Image.network(
                                          asyncSnapshot.data.documents[index]
                                              .get('profileImage'),
                                          height: 100, // not working
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      asyncSnapshot.data.documents[index]
                                          .get('name'),
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      );
                    })
                : //if you have no friends you will get this illustration
                Container(
                    child: Center(
                        child: Image.asset("assets/sports-illustration1.png")))
            : // loading
            Container(
                child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                ),
              );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Container(
              child: TextField(
                controller: friendsSearch,
                decoration: const InputDecoration(
                  hintText: 'Search friends...',
                  border: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    borderSide: BorderSide(color: Color(00000000)),
                  ),
                  suffixIcon: Icon(Feather.search),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    borderSide: BorderSide(color: Color(00000000)),
                  ),
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
                style: const TextStyle(fontSize: 16.0),
                onChanged: updateSearchQuery,
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: <Widget>[friends()],
            ),
          ),
        ],
      ),
    );
  }
}
