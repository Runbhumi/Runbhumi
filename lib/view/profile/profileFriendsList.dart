import 'package:Runbhumi/services/services.dart';
import 'package:Runbhumi/utils/theme_config.dart';
import 'package:Runbhumi/widget/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

import '../views.dart';

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
                        userId: asyncSnapshot.data.documents[index].get('id'),
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
            child: GestureDetector(
              onTap: () {
                showSearch(context: context, delegate: UserSearch());
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                height: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).inputDecorationTheme.fillColor,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Feather.search,
                      color: Theme.of(context).iconTheme.color.withOpacity(0.5),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Search",
                      style: TextStyle(
                        color: Theme.of(context)
                            .inputDecorationTheme
                            .hintStyle
                            .color,
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              ),
            ),
            // child: Container(
            //   child: TextField(
            //     onTap: () {
            //       showSearch(context: context, delegate: UserSearch());
            //     },
            //     controller: friendsSearch,
            //     decoration: const InputDecoration(
            //       hintText: 'Search friends...',
            //       border: InputBorder.none,
            //       prefixIcon: Icon(Feather.search),
            //       hintStyle: const TextStyle(color: Colors.grey),
            //     ),
            //     style: const TextStyle(fontSize: 16.0),
            //     onChanged: updateSearchQuery,
            //   ),
            // ),
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
  ThemeData appBarTheme(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context);
    return ThemeData(
      primaryColor: theme.currentTheme.appBarTheme.color,
      appBarTheme: theme.currentTheme.appBarTheme,
    );
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
