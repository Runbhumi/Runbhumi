import 'package:Runbhumi/models/models.dart';
import 'package:Runbhumi/services/services.dart';
import 'package:Runbhumi/utils/Constants.dart';
import 'package:Runbhumi/utils/theme_config.dart';
import 'package:Runbhumi/view/Chats/conversation.dart';
import 'package:Runbhumi/view/Chats/teamConversation.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import '../../widget/widgets.dart';
import 'eventConversation.dart';

/*
  Code For Message Page
*/
class Network extends StatefulWidget {
  @override
  _NetworkState createState() => _NetworkState();
}

class _NetworkState extends State<Network> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: buildTitle(context, "Message"),
          automaticallyImplyLeading: false,
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(child: Text("Direct")),
              Tab(child: Text("Team")),
              Tab(child: Text("Events")),
            ],
            indicator: new BubbleTabIndicator(
              indicatorHeight: 30.0,
              indicatorColor: Theme.of(context).primaryColor,
              tabBarIndicatorSize: TabBarIndicatorSize.tab,
            ),
          ),
        ),
        body: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Expanded(child: DirectChats()),
              Expanded(
                child: TabBarView(
                  children: [
                    //direct chats
                    DirectChats(),
                    //teams chat
                    TeamChats(),
                    // b/w teams chat
                    EventChats(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EventChats extends StatefulWidget {
  @override
  _EventChatsState createState() => _EventChatsState();
}

class _EventChatsState extends State<EventChats> {
  Stream userEventChats;
  @override
  void initState() {
    getEventChats();
    super.initState();
  }

  getEventChats() async {
    EventService().getCurrentUserEventChats().then((snapshots) {
      setState(() {
        userEventChats = snapshots;
        print("we got the data user Event chats");
      });
    });
  }

  Widget getEventsFeed() {
    return StreamBuilder(
      stream: userEventChats,
      builder: (context, asyncSnapshot) {
        print("user Event chats list is loading");
        if (asyncSnapshot.hasData) {
          print("user Event chats list got loaded");
          if (asyncSnapshot.data.documents.length > 0) {
            return ListView.builder(
                itemCount: asyncSnapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  print('I am here');
                  Events data =
                      new Events.fromJson(asyncSnapshot.data.documents[index]);
                  print('I am here2');
                  return Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventConversation(
                                data: data,
                              ),
                            ));
                        //Go to the team ChatRoom
                      },
                      title: Text(data.eventName),
                      subtitle: Text(data.description),
                    ),
                  );
                });
          } else {
            return Container(
              child: Center(
                child: Image.asset("assets/add-friends.png"),
              ),
            );
          }
        } else {
          return Loader();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: getEventsFeed());
  }
}

class TeamChats extends StatefulWidget {
  @override
  _TeamChatsState createState() => _TeamChatsState();
}

class _TeamChatsState extends State<TeamChats> {
  Stream userTeamChats;
  @override
  void initState() {
    getTeamChats();
    super.initState();
  }

  getTeamChats() async {
    TeamService().getTeamsChatRoom().then((snapshots) {
      setState(() {
        userTeamChats = snapshots;
        print("we got the data user Team chats");
      });
    });
  }

  Widget getTeamsFeed() {
    return StreamBuilder(
      stream: userTeamChats,
      builder: (context, asyncSnapshot) {
        print("user team chats list is loading⌚");
        if (asyncSnapshot.hasData) {
          print("user team chats list got loaded😀");
          if (asyncSnapshot.data.documents.length > 0) {
            return ListView.builder(
                itemCount: asyncSnapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  Teams data =
                      new Teams.fromJson(asyncSnapshot.data.documents[index]);
                  print(data.bio);
                  String sportIcon;
                  // IconData sportIcon;
                  switch (data.sport) {
                    case "Volleyball":
                      sportIcon = "assets/icons8-volleyball-96.png";
                      break;
                    case "Basketball":
                      // sportIcon = Icons.sports_basketball;
                      sportIcon = "assets/icons8-basketball-96.png";
                      break;
                    case "Cricket":
                      sportIcon = "assets/icons8-cricket-96.png";
                      break;
                    case "Football":
                      sportIcon = "assets/icons8-soccer-ball-96.png";
                      break;
                  }
                  return Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TeamConversation(
                                data: data,
                              ),
                            ));
                        //Go to the team ChatRoom
                      },
                      leading: Image.asset(sportIcon),
                      title: Text(data.teamName),
                      subtitle: Text(data.bio),
                    ),
                  );
                });
          } else {
            return Container(
              child: Center(
                child: Image.asset("assets/add-friends.png"),
              ),
            );
          }
        } else {
          return Loader();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getTeamsFeed(),
    );
  }
}

class DirectChats extends StatefulWidget {
  @override
  _DirectChatsState createState() => _DirectChatsState();
}

class _DirectChatsState extends State<DirectChats> {
  Stream userDirectChats;
  TextEditingController friendsSearch;
  String searchQuery = "";
  void initState() {
    getUserChats(); //Getting the chats of the particular user
    super.initState();
    friendsSearch = new TextEditingController();
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
    print("searched " + newQuery);
  }

  getUserChats() async {
    ChatroomService().getUsersDirectChats().then((snapshots) {
      setState(() {
        userDirectChats = snapshots;
        print("we got the data for user direct chats");
      });
    });
  }

  Widget getDirectChats() {
    return StreamBuilder(
      stream: userDirectChats,
      builder: (context, asyncSnapshot) {
        print("Working");
        if (asyncSnapshot.hasData) {
          if (asyncSnapshot.data.documents.length > 0) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView.builder(
                itemCount: asyncSnapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(0),
                        onTap: () {
                          //Sending the user to the chat room
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Conversation(
                                  chatRoomId: asyncSnapshot
                                      .data.documents[index]
                                      .get('chatRoomId'),
                                  usersNames: asyncSnapshot
                                      .data.documents[index]
                                      .get('usersNames'),
                                  users: asyncSnapshot.data.documents[index]
                                      .get('users'),
                                  usersPics: asyncSnapshot.data.documents[index]
                                      .get('usersPics')),
                            ),
                          );
                        },
                        title: Constants.prefs.getString('name') ==
                                asyncSnapshot.data.documents[index]
                                    .get('usersNames')[0]
                            ? Text(
                                asyncSnapshot.data.documents[index]
                                    .get('usersNames')[1],
                                style: TextStyle(fontSize: 18),
                              )
                            : Text(
                                asyncSnapshot.data.documents[index]
                                    .get('usersNames')[0],
                                style: TextStyle(fontSize: 18),
                              ),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image(
                            width: 48,
                            height: 48,
                            image: NetworkImage(
                              Constants.prefs.getString('profileImage') ==
                                      asyncSnapshot.data.documents[index]
                                          .get('usersPics')[0]
                                  ? asyncSnapshot.data.documents[index]
                                      .get('usersPics')[1]
                                  : asyncSnapshot.data.documents[index]
                                      .get('usersPics')[0],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return Container(
              child: Center(
                child: Image.asset("assets/add-friends.png"),
              ),
            );
          }
        } else {
          return Loader();
        }
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
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: GestureDetector(
              onTap: () {
                showSearch(context: context, delegate: UserSearchDirect());
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
          ),
          Expanded(
            child: Stack(
              children: <Widget>[getDirectChats()],
            ),
          ),
        ],
      ),
    );
  }
}

class UserSearchDirect extends SearchDelegate<ListView> {
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

  createChatRoom(String userId, BuildContext context, String username,
      String userProfile) {
    print(userId);
    print(Constants.prefs.getString('userId'));
    if (userId != Constants.prefs.getString('userId')) {
      List<String> users = [userId, Constants.prefs.getString('userId')];
      String chatRoomId =
          getUsersInvolved(userId, Constants.prefs.getString('userId'));
      List<String> usersNames = [username, Constants.prefs.getString('name')];
      List<String> usersPics = [
        Constants.prefs.getString('profileImage'),
        userProfile
      ];

      Map<String, dynamic> chatRoom = {
        "users": users,
        "chatRoomId": chatRoomId,
        "usersNames": usersNames,
        "usersPics": usersPics,
      };
      ChatroomService().addChatRoom(chatRoom, chatRoomId);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Conversation(
                    chatRoomId: chatRoomId,
                    usersNames: usersNames,
                    users: users,
                    usersPics: usersPics,
                  )));
    } else {
      print("Cannot do that");
    }
  }

  getUsersInvolved(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder(
        stream: getUserFeed(query),
        builder: (context, asyncSnapshot) {
          print("Working");
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
                          print("creating a chat room");
                          //Creating a chatroom for the user he searched for
                          // Can get any information of that other user here.
                          createChatRoom(
                              asyncSnapshot.data.documents[index].get('userId'),
                              context,
                              asyncSnapshot.data.documents[index].get('name'),
                              asyncSnapshot.data.documents[index]
                                  .get('profileImage'));
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(0),
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
