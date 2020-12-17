import 'package:Runbhumi/models/models.dart';
import 'package:Runbhumi/services/services.dart';
import 'package:Runbhumi/utils/Constants.dart';
import 'package:Runbhumi/utils/theme_config.dart';
import 'package:Runbhumi/widget/loader.dart';
import 'package:Runbhumi/widget/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class TeamCategory extends StatefulWidget {
  final String sportName;
  TeamCategory({Key key, this.sportName}) : super(key: key);
  @override
  _TeamCategoryState createState() => _TeamCategoryState();
}

class _TeamCategoryState extends State<TeamCategory> {
  Stream teamFeed;
  void initState() {
    super.initState();
    getAllTeams();
    print(
        "------------------------${widget.sportName}--------------------------------------");
  }

  getAllTeams() async {
    await TeamService()
        .getSpecificCategoryFeed(widget.sportName)
        .then((snapshots) {
      setState(() {
        teamFeed = snapshots;
      });
    });
  }

  SimpleDialog successDialog(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      children: [
        Center(
            child: Text("You Have been added",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline4)),
        Image.asset("assets/confirmation-illustration.png")
      ],
    );
  }

  getUserInfoEvents() async {
    TeamService().getAllTeamsFeed().then((snapshots) {
      setState(() {
        teamFeed = snapshots;
        // print("we got the data + ${currentFeed.toString()} ");
      });
    });
  }

  Widget feed({ThemeNotifier theme}) {
    return StreamBuilder(
      stream: teamFeed,
      builder: (context, asyncSnapshot) {
        return asyncSnapshot.hasData
            ? asyncSnapshot.data.documents.length > 0
                ? ListView.builder(
                    itemCount: asyncSnapshot.data.documents.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      Teams data = new Teams.fromJson(
                          asyncSnapshot.data.documents[index]);

                      String sportIcon;
                      switch (widget.sportName) {
                        case "Volleyball":
                          sportIcon = "assets/icons8-volleyball-96.png";
                          break;
                        case "Basketball":
                          sportIcon = "assets/icons8-basketball-96.png";
                          break;
                        case "Cricket":
                          sportIcon = "assets/icons8-cricket-96.png";
                          break;
                        case "Football":
                          sportIcon = "assets/icons8-soccer-ball-96.png";
                          break;
                      }
                      bool notifiedCondition = false;
                      bool joinCondition = data.playerId
                          .contains(Constants.prefs.getString('userId'));
                      if (data.notificationPlayers.length > 0)
                        notifiedCondition = data.notificationPlayers
                            .contains(Constants.prefs.getString('userId'));

                      //asyncSnapshot
                      // .data.documents[index]
                      // .get('playersId')
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Card(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                      dividerColor: Colors.transparent),
                                  child: ExpansionTile(
                                    maintainState: true,
                                    onExpansionChanged: (expanded) {
                                      if (expanded) {
                                      } else {}
                                    },
                                    children: [
                                      SmallButton(
                                          myColor: !joinCondition
                                              ? Theme.of(context).primaryColor
                                              : Theme.of(context).accentColor,
                                          myText: !joinCondition
                                              ? !notifiedCondition
                                                  ? "Join"
                                                  : "Request Sent"
                                              : "Already there",
                                          onPressed: () {
                                            if (!joinCondition) {
                                              if (data.status == 'private') {
                                                NotificationServices()
                                                    .createTeamNotification(
                                                        Constants.prefs
                                                            .getString(
                                                                'userId'),
                                                        data.manager,
                                                        data);
                                              }
                                              if (data.status == 'closed') {
                                                // Make a custom Alert message for the user to
                                                //know that he can not join a closed team
                                              }
                                              if (data.status == 'public') {
                                                TeamService()
                                                    .addMeInTeam(data.teamId)
                                                    .then(() => {
                                                          // give a success notification that he was
                                                          //added to the team and take him to the chat
                                                          //window or the info page of the team
                                                        });
                                              }
                                            }
                                          })
                                    ],
                                    leading: Image.asset(sportIcon),
                                    title: Text(
                                      data.teamName,
                                      style: TextStyle(
                                        color:
                                            theme.currentTheme.backgroundColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data.bio,
                                          style: TextStyle(
                                            color: theme
                                                .currentTheme.backgroundColor,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Feather.map_pin,
                                              size: 16.0,
                                            ),
                                            Text(
                                              data.status,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    trailing:
                                        Text(data.playerId.length.toString()),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : // if there is no event in the DB you will get this illustration
                Container(
                    child: Center(
                      child: Image.asset("assets/notification.png"),
                    ),
                  )
            : Loader();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeNotifier theme = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: buildTitle(context, widget.sportName),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: GestureDetector(
                onTap: () {
                  showSearch(
                      context: context, delegate: TeamCategorySearchDirect());
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
                        color:
                            Theme.of(context).iconTheme.color.withOpacity(0.5),
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
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Text(
                'Nearby you',
                style: TextStyle(
                  color: theme.currentTheme.backgroundColor.withOpacity(0.35),
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: Stack(
                children: <Widget>[
                  feed(theme: theme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// TODO: dear backend devs please complete the search functionality
class TeamCategorySearchDirect extends SearchDelegate<ListView> {
  getTeams(String query) {
    print("getTeams");
    return FirebaseFirestore.instance
        .collection("teams")
        .where("teamname", isEqualTo: query)
        .limit(1)
        .snapshots();
  }

// make team search params
  getTeamFeed(String query) {
    print("getTeamFeed");
    return FirebaseFirestore.instance
        .collection("teams")
        .where("teamSearchParam", arrayContains: query)
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
    final ThemeNotifier theme = Provider.of<ThemeNotifier>(context);
    return StreamBuilder(
        stream: getTeams(query),
        builder: (context, asyncSnapshot) {
          return asyncSnapshot.hasData
              ? ListView.builder(
                  itemCount: asyncSnapshot.data.documents.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    Teams data =
                        new Teams.fromJson(asyncSnapshot.data.documents[index]);

                    String sportIcon;
                    switch (data.sport) {
                      case "Volleyball":
                        sportIcon = "assets/icons8-volleyball-96.png";
                        break;
                      case "Basketball":
                        sportIcon = "assets/icons8-basketball-96.png";
                        break;
                      case "Cricket":
                        sportIcon = "assets/icons8-cricket-96.png";
                        break;
                      case "Football":
                        sportIcon = "assets/icons8-soccer-ball-96.png";
                        break;
                    }
                    bool notifiedCondition = false;
                    bool joinCondition = data.playerId
                        .contains(Constants.prefs.getString('userId'));
                    if (data.notificationPlayers.length > 0)
                      notifiedCondition = data.notificationPlayers
                          .contains(Constants.prefs.getString('userId'));

                    //asyncSnapshot
                    // .data.documents[index]
                    // .get('playersId')
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Card(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Theme(
                                data: Theme.of(context)
                                    .copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  maintainState: true,
                                  onExpansionChanged: (expanded) {
                                    if (expanded) {
                                    } else {}
                                  },
                                  children: [
                                    SmallButton(
                                        myColor: !joinCondition
                                            ? Theme.of(context).primaryColor
                                            : Theme.of(context).accentColor,
                                        myText: !joinCondition
                                            ? !notifiedCondition
                                                ? "Join"
                                                : "Request Sent"
                                            : "Already there",
                                        onPressed: () {
                                          if (!joinCondition) {
                                            if (data.status == 'private') {
                                              NotificationServices()
                                                  .createTeamNotification(
                                                      Constants.prefs
                                                          .getString('userId'),
                                                      data.manager,
                                                      data);
                                            }
                                            if (data.status == 'closed') {
                                              //TODO: Make a custom Alert message for the user to
                                              //know that he can not join a closed team
                                            }
                                            if (data.status == 'public') {
                                              TeamService()
                                                  .addMeInTeam(data.teamId)
                                                  .then(() => {
                                                        //TODO: give a success notification that he was
                                                        //added to the team and take him to the chat
                                                        //window or the info page of the team
                                                      });
                                            }
                                          }
                                        })
                                  ],
                                  leading: Image.asset(sportIcon),
                                  title: Text(
                                    data.teamName,
                                    style: TextStyle(
                                      color: theme.currentTheme.backgroundColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data.bio,
                                        style: TextStyle(
                                          color: theme
                                              .currentTheme.backgroundColor,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Feather.map_pin,
                                            size: 16.0,
                                          ),
                                          Text(
                                            data.status,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  trailing:
                                      Text(data.playerId.length.toString()),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : Container(
                  child: Center(
                    child: Image(
                      image: AssetImage("assets/search-illustration.png"),
                    ),
                  ),
                );
        });
  }

  // createChatRoom(String userId, BuildContext context, String username,
  //     String userProfile) {
  //   print(userId);
  //   print(Constants.prefs.getString('userId'));
  //   if (userId != Constants.prefs.getString('userId')) {
  //     List<String> users = [userId, Constants.prefs.getString('userId')];
  //     String chatRoomId =
  //         getUsersInvolved(userId, Constants.prefs.getString('userId'));
  //     List<String> usersNames = [username, Constants.prefs.getString('name')];
  //     List<String> usersPics = [
  //       Constants.prefs.getString('profileImage'),
  //       userProfile
  //     ];

  //     Map<String, dynamic> chatRoom = {
  //       "users": users,
  //       "chatRoomId": chatRoomId,
  //       "usersNames": usersNames,
  //       "usersPics": usersPics,
  //     };
  //     ChatroomService().addChatRoom(chatRoom, chatRoomId);
  //     // Navigator.push(
  //     //     context,
  //     //     MaterialPageRoute(
  //     //         builder: (context) => Conversation(
  //     //               chatRoomId: chatRoomId,
  //     //               usersNames: usersNames,
  //     //               users: users,
  //     //               usersPics: usersPics,
  //     //             )));
  //   } else {
  //     print("Cannot do that");
  //   }
  // }

  // getUsersInvolved(String a, String b) {
  //   if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
  //     return "$b\_$a";
  //   } else {
  //     return "$a\_$b";
  //   }
  // }

  @override
  Widget buildSuggestions(BuildContext context) {
    String sportIcon;
    return StreamBuilder(
        stream: getTeamFeed(query),
        builder: (context, asyncSnapshot) {
          print("Suggestions Working");
          print(asyncSnapshot.hasData);
          return asyncSnapshot.hasData
              ? ListView.builder(
                  itemCount: asyncSnapshot.data.documents.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    print('I am here');
                    print(asyncSnapshot.data.documents[index].get('teamname'));
                    switch (asyncSnapshot.data.documents[index].get('sport')) {
                      case "Volleyball":
                        sportIcon = "assets/icons8-volleyball-96.png";
                        break;
                      case "Basketball":
                        sportIcon = "assets/icons8-basketball-96.png";
                        break;
                      case "Cricket":
                        sportIcon = "assets/icons8-cricket-96.png";
                        break;
                      case "Football":
                        sportIcon = "assets/icons8-soccer-ball-96.png";
                        break;
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 16.0),
                      child: GestureDetector(
                        onTap: () {
                          //TODO:Take him to team Info
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(0),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Image.asset(sportIcon),
                              ),
                              title: Text(asyncSnapshot.data.documents[index]
                                  .get('teamname')),
                              subtitle: Text(
                                asyncSnapshot.data.documents[index]
                                    .get('status'),
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
