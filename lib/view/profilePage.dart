import 'dart:async';
import 'package:Runbhumi/services/UserServices.dart';
import 'package:Runbhumi/utils/Constants.dart';
import 'package:Runbhumi/view/otherUserProfile.dart';
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
          title: buildTitle(context, "Profile"),
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
        body: ProfileBody(),
      ),
    );
    return GestureDetector(
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
}

class ProfileBody extends StatefulWidget {
  const ProfileBody({
    Key key,
  }) : super(key: key);

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
      print("profile body loaded");
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
                            data['eventCount'].toString(),
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w500),
                          ),
                          Text("events"),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            data['teamsCount'].toString(),
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w500),
                          ),
                          Text("teams"),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            data['friendCount'].toString(),
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
                    style: Theme.of(context).textTheme.headline6,
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
                    style: Theme.of(context).textTheme.headline6,
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
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
              if (data['phoneNumber']['show'])
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
                      data['phoneNumber']['ph'],
                      style: Theme.of(context).textTheme.headline6,
                    )
                  ],
                ),
            ],
          ),
        ),
      ],
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
        // print("we got the data + ${userFriend.toString()} ");
        print("we got the data for friends list ");
      });
    });
  }

  Widget friends() {
    return StreamBuilder(
      stream: userFriend,
      builder: (context, asyncSnapshot) {
        print("friends list is loading");
        return asyncSnapshot.hasData
            ? asyncSnapshot.data.documents.length > 0
                ? ListView.builder(
                    itemCount: asyncSnapshot.data.documents.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return SingleFriendCard(
                        imageLink: asyncSnapshot.data.documents[index]
                            .get('profileImage'),
                        name: asyncSnapshot.data.documents[index].get('name'),
                        userId:
                            asyncSnapshot.data.documents[index].get('friendId'),
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
              child: TextField(
                onTap: () {
                  showSearch(context: context, delegate: UserSearch());
                },
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

class UserSearch extends SearchDelegate<ListView> {
  getUser(String query) {
    print("getUser");
    return FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: query)
        .limit(1)
        .snapshots();
  }

  getUserFeed(String query) {
    print("getUserFeed");
    return FirebaseFirestore.instance
        .collection("users")
        .where("userSearchParam", arrayContains: query)
        .limit(5)
        .snapshots();
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Feather.x),
        onPressed: () {
          query = '';
        },
      ),
    ];
    // throw UnimplementedError();
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        });
    // throw UnimplementedError();
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder(
        stream: getUser(query),
        builder: (context, asyncSnapshot) {
          return asyncSnapshot.hasData
              ? ListView.builder(
                  itemCount: asyncSnapshot.data.documents.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 16.0),
                      child: GestureDetector(
                        onTap: () {},
                        child: Card(
                          shadowColor: Color(0x44393e46),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          elevation: 20,
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image(
                                image: NetworkImage(
                                  asyncSnapshot.data.documents[index]
                                      .get('profileImage'),
                                ),
                              ),
                            ),
                            title: Text(
                              asyncSnapshot.data.documents[index].get('name'),
                            ),
                            subtitle: Text(
                              asyncSnapshot.data.documents[index]
                                  .get('username'),
                            ),
                          ),
                        ),
                      ),
                    );
                  })
              : Container(
                  child: Center(
                    child: Image(
                      image: AssetImage("assets/search-illustration.png"),
                    ),
                  ),
                );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder(
        stream: getUserFeed(query),
        builder: (context, asyncSnapshot) {
          print("suggestions are loading");
          return asyncSnapshot.hasData
              ? ListView.builder(
                  itemCount: asyncSnapshot.data.documents.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 16.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OtherUserProfile(
                                      userID: asyncSnapshot
                                          .data.documents[index]
                                          .get('userId'),
                                    )),
                          );
                        },
                        child: Card(
                          shadowColor: Color(0x44393e46),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          elevation: 20,
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image(
                                image: NetworkImage(asyncSnapshot
                                    .data.documents[index]
                                    .get('profileImage')
                                    .toString()),
                              ),
                            ),
                            title: Text(asyncSnapshot.data.documents[index]
                                .get('name')),
                            subtitle: Text(
                              asyncSnapshot.data.documents[index]
                                  .get('username'),
                            ),
                          ),
                        ),
                      ),
                    );
                  })
              : Container(
                  child: Center(
                    child: Image(
                      image: AssetImage("assets/search-illustration.png"),
                    ),
                  ),
                );
        });
    // throw UnimplementedError();
  }
}

/*
Text Spanning can be used to give user a feeling of auto completion
*/
