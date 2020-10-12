import 'package:Runbhumi/services/chatroomServices.dart';
import 'package:Runbhumi/utils/Constants.dart';
import 'package:Runbhumi/view/conversation.dart';
import 'package:Runbhumi/widget/placeholder_widget.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import '../widget/widgets.dart';

/*
  Code For Network Page
*/
class Network extends StatefulWidget {
  @override
  _NetworkState createState() => _NetworkState();
}

class _NetworkState extends State<Network> {
  // for Title
  Widget _buildTitle(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: const Text(
        'Network',
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    // TODO: make this schedule list connect to firebase
    final List scheduleList = ["hayat", "manas", "rohan", "mohit"];

    return Scaffold(
      appBar: AppBar(
        title: _buildTitle(context),
        automaticallyImplyLeading: false,
      ),
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Text(
                  'Schedule',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              //schedule
              Schedule(scheduleList: scheduleList),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 8.0,
                ),
                child: Text(
                  'Chats',
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.start,
                ),
              ),
              //Chat Tabs
              ChatsTabs(),
              // TODO: replace placeholders with actual UI
              Expanded(
                child: TabBarView(
                  children: [
                    directChats(),
                    teamChats(),
                    betweenTeamsChats(),
                  ],
                ),
              ),

            ),
            // ChatsTabs(),
            // TODO: replace placeholders with actual UI
            Expanded(
              // child: TabBarView(
              //   children: [
              //     PlaceholderWidget(),
              //     PlaceholderWidget(),
              //     PlaceholderWidget(),
              //   ],
              // ),
              child: PlaceholderWidget(),
            ),
          ],

            ],
          ),

        ),
      ),
    );
  }
}

class directChats extends StatefulWidget {
  @override
  _directChatsState createState() => _directChatsState();
}

class _directChatsState extends State<directChats> {
  @override
  void initState() {
    //getUserInfogetChats();
    super.initState();
  }

  getUserInfogetChats() {
    chatroomService()
        .getUsersDirectChats(Constants.prefs.getString('username'))
        .then((snapshots) {
      setState(() {
        directChatRooms = snapshots;
        print(
            "we got the data + ${directChatRooms.toString()} this is name  ${Constants.prefs.getString('username')}");
      });
    });
  }

  Stream directChatRooms;
  Widget directChatRoomsList() {
    return StreamBuilder(
      stream: directChatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      // Code for going into the coversation class
                    },
                    leading: Icon(Icons.person),
                    trailing: Icon(Icons.send),
                  );
                })
            : Container(
                child: Text("You do not have any chats yet"),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: directChatRoomsList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => search()));
        },
      ),
    );
    //Code for direct chats
  }
}

class teamChats extends StatefulWidget {
  @override
  _teamChatsState createState() => _teamChatsState();
}

class _teamChatsState extends State<teamChats> {
  Stream teamsChatRooms;

  Widget teamsChatRoomsList() {
    return StreamBuilder(

      stream: currentFeed,
      builder: (context, asyncSnapshot) {
        print("Working");
        return asyncSnapshot.hasData
            ? asyncSnapshot.data.documents.length > 0
                ? ListView.builder(
                    itemCount: asyncSnapshot.data.documents.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                        ),
                        child: Card(
                          shadowColor: Color(0x44393e46),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          elevation: 5,
                          child: Container(
                            width: 300,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    isThreeLine: true,
                                    title: Text(
                                      asyncSnapshot.data.documents[index].get(
                                          'eventName'), // widget.scheduleList[index][],
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                    subtitle: Row(
                                      children: [
                                        Icon(
                                          Feather.map_pin,
                                          size: 16.0,
                                        ),
                                        Text(
                                          asyncSnapshot.data.documents[index]
                                              .get('location'),
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1,
                                        ),
                                      ],
                                    ),
                                    trailing: Column(
                                      children: [
                                        //time
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(DateFormat('E\ndd/MM\nkk:mm')
                                                .format(asyncSnapshot
                                                    .data.documents[index]
                                                    .get('dateTime')
                                                    .toDate())
                                                .toString()),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : //if you have no events you will get this illustration
                Container(
                    child: Center(
                      child: Image.asset("assets/events.png", height: 200),
                    ),
                  )
            : Loader();
      stream: teamsChatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      // Code for going into the coversation class
                    },
                    leading: Icon(Icons.person),
                    trailing: Icon(Icons.send),
                  );
                })
            : Container(
                child: Text("You do not have any chats yet"),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
    //Code for team chats
  }
}

class betweenTeamsChats extends StatefulWidget {
  @override
  _betweenTeamsChatsState createState() => _betweenTeamsChatsState();
}

class _betweenTeamsChatsState extends State<betweenTeamsChats> {
  Stream betweenTeamsChatRooms;

  Widget teamsChatRoomsList() {
    return StreamBuilder(
      stream: betweenTeamsChatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      // Code for going into the coversation class
                    },
                    leading: Icon(Icons.person),
                    trailing: Icon(Icons.send),
                  );
                })
            : Container(
                child: Text("You do not have any chats yet"),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
    //Code for between teams chats
  }
}

class Schedule extends StatelessWidget {
  const Schedule({
    Key key,
    @required this.scheduleList,
  }) : super(key: key);

  final List scheduleList;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 5,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
            ),
            child: Card(
              shadowColor: Color(0x44393e46),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              elevation: 5,
              child: Container(
                width: 300,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        isThreeLine: true,
                        title: Text(
                          scheduleList[index],
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        subtitle: Row(
                          children: [
                            Icon(
                              Feather.map_pin,
                              size: 16.0,
                            ),
                            Text(
                              "Bahrain",
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ],
                        ),
                        trailing: Column(
                          children: [
                            //time
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(DateTime.now().hour.toString()),
                                Text(":"),
                                Text(DateTime.now().minute.toString()),
                              ],
                            ),
                            //day
                            // Text(DateTime.now().weekday.toString()),
                            if (DateTime.now().weekday == 1) Text("MON"),
                            if (DateTime.now().weekday == 2) Text("TUE"),
                            if (DateTime.now().weekday == 3) Text("WED"),
                            if (DateTime.now().weekday == 4) Text("THU"),
                            if (DateTime.now().weekday == 5) Text("FRI"),
                            if (DateTime.now().weekday == 6) Text("SAT"),
                            if (DateTime.now().weekday == 7) Text("SUN"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: scheduleList.length,
      ),
    );
  }
}

class ChatsTabs extends StatelessWidget {
  const ChatsTabs({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x29000000),
            blurRadius: 6,
            offset: Offset(0, -1),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: TabBar(
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
    );
  }
}

class search extends StatefulWidget {
  @override
  _searchState createState() => _searchState();
}

class _searchState extends State<search> {
  TextEditingController searchEditingController = new TextEditingController();
  QuerySnapshot searchResultSnapshot;
  Widget getName(Map<String, dynamic> map) {
    Map data = map;
    return Text(
      data["username"],
    );
  }

  Widget searchList() {
    return searchResultSnapshot != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchResultSnapshot.size,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(Icons.person),
                title: getName(searchResultSnapshot.docs[index].data()),
                trailing: GestureDetector(
                  onTap: () {
                    createChatRoom(
                        searchResultSnapshot.docs[index].data()["username"]);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(24)),
                    child: Text(
                      "Message",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              );
            })
        : Container(
            child: Text("No such users"),
          );
  }

  createChatRoom(String userName) {
    if (userName != Constants.prefs.getString('username')) {
      List<String> users = [userName, Constants.prefs.getString('username')];
      String chatRoomId =
          getChatRoomId(Constants.prefs.getString('username'), userName);

      Map<String, dynamic> chatRoom = {
        "users": users,
        "chatRoomId": chatRoomId,
      };
      chatroomService().addChatRoom(chatRoom, chatRoomId);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Conversation(
                    chatRoomId: chatRoomId,
                  )));
    } else {
      print("Cannot do that");
    }
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              color: Colors.black12,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchEditingController,
                      decoration: InputDecoration(
                          hintText: "search username ...",
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          border: InputBorder.none),
                    ),
                  ),
                  GestureDetector(
                    child: Icon(Icons.search),
                    onTap: () async {
                      print("Cannot do that");
                      if (searchEditingController.text.isNotEmpty) {
                        print("I am here");
                        await chatroomService().getAllusers().then((snapshot) {
                          setState(() {
                            if (snapshot != null) {
                              searchResultSnapshot = snapshot;
                            }
                          });
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}
