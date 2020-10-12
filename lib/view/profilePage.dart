import 'dart:async';
import 'dart:ui';
import 'package:Runbhumi/services/UserServices.dart';
import 'package:Runbhumi/utils/Constants.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:firebase_core/firebase_core.dart';
import 'views.dart';
import '../widget/widgets.dart';

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
  //variables for drawer animations
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
            // to close drawer
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
        body: ProfileBody(teamsList: teamsList),
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

class ProfileBody extends StatefulWidget {
  const ProfileBody({
    Key key,
    this.teamsList,
  }) : super(key: key);

  final List teamsList;

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
    return Column(
      children: [
        //profile image
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
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            color: Colors.grey.withOpacity(0.1),
            width: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            "23",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w500),
                          ),
                          Text("events"),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "2",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w500),
                          ),
                          Text("teams"),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "200",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w500),
                          ),
                          Text("friends"),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        //details
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Feather.user,
                      size: 24.0,
                    ),
                  ),
                  Text(
                    data["age"],
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Feather.map_pin,
                      size: 24.0,
                    ),
                  ),
                  Text(
                    data["location"],
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Feather.mail,
                      size: 24.0,
                    ),
                  ),
                  Text(
                    data["emailId"],
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Feather.phone,
                      size: 24.0,
                    ),
                  ),
                  Text(
                    "+91 123456789",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
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
                      child: Image.asset("assets/add-friends.png"),
                    ),
                  )
            : Loader();
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
              // TypeAheadField(
              //   itemBuilder: (context, suggestion) {
              //     return ListTile(
              //       leading: Icon(Icons.shopping_cart),
              //       title: Text(suggestion['name']),
              //       subtitle: Text('\$${suggestion['price']}'),
              //     );
              //   },
              //   suggestionsCallback: (pattern) async {
              //     // return await BackendService.getSuggestions(pattern);
              //   },
              //   onSuggestionSelected: (suggestion) {
              //     // Navigator.of(context).push(MaterialPageRoute(
              //     //     builder: (context) => ProductPage(product: suggestion)));
              //   },
              //   textFieldConfiguration: TextFieldConfiguration(
              //     controller: friendsSearch,
              //     decoration: const InputDecoration(
              //       hintText: 'Search friends...',
              //       border: InputBorder.none,
              //       enabledBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.all(Radius.circular(50.0)),
              //         borderSide: BorderSide(color: Color(00000000)),
              //       ),
              //       prefixIcon: Icon(Feather.search),
              //       focusedBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.all(Radius.circular(50.0)),
              //         borderSide: BorderSide(color: Color(00000000)),
              //       ),
              //       hintStyle: const TextStyle(color: Colors.grey),
              //     ),
              //     style: const TextStyle(fontSize: 16.0),
              //     onChanged: updateSearchQuery,
              //   ),
              // ),
              child: TextField(
                controller: friendsSearch,
                decoration: const InputDecoration(
                  hintText: 'Search friends...',
                  border: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    borderSide: BorderSide(color: Color(00000000)),
                  ),
                  prefixIcon: Icon(Feather.search),
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
