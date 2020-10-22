import 'package:Runbhumi/services/chatroomServices.dart';
import 'package:Runbhumi/utils/Constants.dart';
import 'package:Runbhumi/view/Chats/conversation.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../../widget/widgets.dart';

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
              Tab(child: Text("B/W Teams")),
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
              // ChatsTabs(),
              Expanded(
                child: TabBarView(
                  children: [
                    //direct chats
                    DirectChats(),
                    //teams chat
                    PlaceholderWidget(),
                    // b/w teams chat
                    PlaceholderWidget(),
                  ],
                ),
              ),
            ],
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     Navigator.pushNamed(context, "/addpost");
        //   },
        //   child: Icon(Icons.add),
        //   foregroundColor: Colors.white,
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.all(Radius.circular(20)),
        //   ),
        //   backgroundColor: Theme.of(context).primaryColor,
        // ),
      ),
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
    print("got here");
    ChatroomService().getUsersDirectChats().then((snapshots) {
      setState(() {
        print("got here");
        userDirectChats = snapshots;
        print("we got the data");
      });
    });
  }

  Widget getDirectChats() {
    return StreamBuilder(
      stream: userDirectChats,
      builder: (context, asyncSnapshot) {
        print("Working");
        return asyncSnapshot.hasData
            ? asyncSnapshot.data.documents.length > 0
                ? ListView.builder(
                    itemCount: asyncSnapshot.data.documents.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Card(
                          shadowColor: Color(0x44393e46),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          elevation: 20,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
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
                                        users: asyncSnapshot
                                            .data.documents[index]
                                            .get('users'),
                                        usersPics: asyncSnapshot
                                            .data.documents[index]
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
                                      style: TextStyle(fontSize: 20),
                                    )
                                  : Text(
                                      asyncSnapshot.data.documents[index]
                                          .get('usersNames')[0],
                                      style: TextStyle(fontSize: 20),
                                    ),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Image(
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
                              // trailing: Icon(Icons.send),
                            ),
                          ),
                        ),
                      );
                    },
                  )
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
                  showSearch(context: context, delegate: UserSearchDirect());
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

// class ChatsTabs extends StatelessWidget {
//   const ChatsTabs({
//     Key key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Color(0x29000000),
//             blurRadius: 6,
//             offset: Offset(0, -1),
//           ),
//         ],
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//       ),
//       child: PreferredSize(
//         preferredSize: Size.fromHeight(50.0),
//         child: TabBar(
//           labelColor: Colors.white,
//           unselectedLabelColor: Colors.grey,
//           tabs: [
//             Tab(child: Text("Direct")),
//             Tab(child: Text("Team")),
//             Tab(child: Text("B/W Teams")),
//           ],
//           indicator: new BubbleTabIndicator(
//             indicatorHeight: 30.0,
//             indicatorColor: Theme.of(context).primaryColor,
//             tabBarIndicatorSize: TabBarIndicatorSize.tab,
//           ),
//         ),
//       ),
//     );
//   }
// }
