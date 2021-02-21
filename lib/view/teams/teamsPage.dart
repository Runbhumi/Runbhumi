import 'package:Runbhumi/models/models.dart';
import 'package:Runbhumi/services/services.dart';
import 'package:Runbhumi/utils/Constants.dart';
import 'package:Runbhumi/utils/theme_config.dart';
import 'package:Runbhumi/view/Chats/teamConversation.dart';
import 'package:Runbhumi/view/teams/challengeScreen.dart';
//import 'package:Runbhumi/view/teams/challengeScreen.dart';
import 'package:Runbhumi/view/teams/teamCategory.dart';
import 'package:Runbhumi/view/teams/teaminfo.dart';
import 'package:Runbhumi/widget/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class TeamsList extends StatefulWidget {
  @override
  _TeamsListState createState() => _TeamsListState();
}

class _TeamsListState extends State<TeamsList>
    with SingleTickerProviderStateMixin {
  int loadMoreTeams = 20;
  ScrollController _teamsScrollController;
  void initState() {
    super.initState();
    _teamsScrollController = ScrollController()
      ..addListener(() {
        if (_teamsScrollController.position.pixels ==
            _teamsScrollController.position.maxScrollExtent) {
          setState(() {
            loadMoreTeams += loadMoreTeams;
          });
        }
      });
  }

  Widget feed({ThemeNotifier theme}) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("teams")
          .limit(loadMoreTeams)
          .snapshots(),
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.hasData) {
          if (asyncSnapshot.data.documents.length > 0) {
            return ListView.builder(
              controller: _teamsScrollController,
              itemCount: asyncSnapshot.data.documents.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                Teams data =
                    new Teams.fromJson(asyncSnapshot.data.documents[index]);

                String sportIcon;
                // IconData sportIcon;
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
                bool joinCondition =
                    data.playerId.contains(Constants.prefs.getString('userId'));
                if (data.notificationPlayers.length > 0)
                  notifiedCondition = data.notificationPlayers
                      .contains(Constants.prefs.getString('userId'));

                //asyncSnapshot
                // .data.documents[index]
                // .get('playersId')
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: GestureDetector(
                    onLongPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return TeamInfo(
                              teamID: data.teamId,
                            );
                          },
                        ),
                      );
                    },
                    child: Card(
                      child: ExpansionCard(
                          maintainState: true,
                          children: [
                            !joinCondition
                                ? SmallButton(
                                    myColor: !joinCondition
                                        ? Theme.of(context).primaryColor
                                        : Theme.of(context).accentColor,
                                    myText: !joinCondition
                                        ? !notifiedCondition
                                            ? "Join"
                                            : "Request Sent"
                                        : "Already there",
                                    onPressed: () {
                                      if (!joinCondition && notifiedCondition) {
                                        //Notification pending
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return notifcationPending(context);
                                          },
                                        );
                                      } else if (!joinCondition &&
                                          !notifiedCondition) {
                                        if (data.status == 'private') {
                                          NotificationServices()
                                              .createTeamNotification(
                                                  Constants.prefs
                                                      .getString('userId'),
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
                                : Container(),
                            SmallButton(
                              myColor: !joinCondition
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).accentColor,
                              myText: !joinCondition ? 'Challenge' : 'Message',
                              onPressed: () {
                                if (!joinCondition) {
                                  // Challenge logic
                                  final TeamChallengeNotification teamData =
                                      new TeamChallengeNotification.newTeam(
                                          data.teamId,
                                          data.manager,
                                          data.teamName);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChallangeTeam(
                                            sportName: data.sport,
                                            teamData: teamData)),
                                  );
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TeamConversation(
                                          data: data,
                                        ),
                                      ));
                                  //Go to the team ChatRoom
                                }
                              },
                            )
                          ],
                          alwaysShowingChild: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Padding(
                              //   padding:
                              //       const EdgeInsets.symmetric(horizontal: 8.0),
                              //   child: Container(
                              //     height: 30,
                              //     child: Stack(
                              //       children: [
                              //         Stack(
                              //           // scrollDirection: Axis.horizontal,
                              //           children: [
                              //             PlayerPreview1(),
                              //             PlayerPreview2(),
                              //             PlayerPreview3(),
                              //           ],
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      TeamSportLeading(sportIcon: sportIcon),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.5,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              TeamName(data: data),
                                              TypeofTeam(data: data),
                                              TeamDescription(data: data),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Stack(
                                      alignment: AlignmentDirectional.center,
                                      children: [
                                        CircularProgressIndicator(
                                          value: data.playerId.length / 20,
                                          backgroundColor: theme
                                              .currentTheme.backgroundColor
                                              .withOpacity(0.15),
                                          strokeWidth: 7,
                                        ),
                                        Text(
                                          data.playerId.length.toString() +
                                              "/20",
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                    ),
                  ),
                );
              },
            );
          } else {
            return Container(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                      child: Image.asset("assets/teams_illustration.png",
                          width: 300),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Didn't find any team, create one",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                    Button(
                      myColor: Theme.of(context).primaryColor,
                      myText: "Create team",
                      onPressed: () {
                        Navigator.pushNamed(context, "/createteam");
                      },
                    )
                  ],
                ),
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
    final ThemeNotifier theme = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: buildTitle(context, "Teams"),
      ),
      body: NestedScrollView(
        headerSliverBuilder: _teamsPageSliverAppBar,
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
                child: Text(
                  'Teams Nearby you',
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
                  children: <Widget>[feed(theme: theme)],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/createteam");
        },
        child: Icon(
          Feather.user_plus,
          size: 32,
        ),
      ),
    );
  }

  List<Widget> _teamsPageSliverAppBar(
      BuildContext context, bool innerBoxIsScrolled) {
    final ThemeNotifier theme = Provider.of<ThemeNotifier>(context);
    return <Widget>[
      SliverList(
        delegate: SliverChildListDelegate(
          [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Text(
                'Categories',
                style: TextStyle(
                  color: theme.currentTheme.backgroundColor.withOpacity(0.35),
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SportsCategory(
                      theme: theme,
                      sport: "Basketball",
                      icon: "assets/icons8-basketball-96.png",
                    ),
                    SportsCategory(
                      theme: theme,
                      sport: "Cricket",
                      icon: "assets/icons8-cricket-96.png",
                    ),
                    SportsCategory(
                      theme: theme,
                      sport: "Football",
                      icon: "assets/icons8-soccer-ball-96.png",
                    ),
                    SportsCategory(
                      theme: theme,
                      sport: "Volleyball",
                      icon: "assets/icons8-volleyball-96.png",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    ];
  }
}

class PlayerPreview3 extends StatelessWidget {
  const PlayerPreview3({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32.0),
      child: Container(
        padding: EdgeInsets.all(2),
        child: CircleAvatar(
          radius: 13,
          backgroundColor: Theme.of(context).cardColor,
          child: Padding(
              padding: EdgeInsets.all(3),
              child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://pbs.twimg.com/profile_images/1286371379768516608/KKBFYV_t.jpg"))),
        ),
      ),
    );
  }
}

class PlayerPreview1 extends StatelessWidget {
  const PlayerPreview1({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      child: CircleAvatar(
        radius: 13,
        backgroundColor: Theme.of(context).cardColor,
        child: Padding(
            padding: EdgeInsets.all(3),
            child: CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://pbs.twimg.com/profile_images/1286371379768516608/KKBFYV_t.jpg"))),
      ),
    );
  }
}

class TeamSportLeading extends StatelessWidget {
  const TeamSportLeading({
    Key key,
    @required this.sportIcon,
  }) : super(key: key);

  final String sportIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Image.asset(
        sportIcon,
        width: 70,
      ),
    );
  }
}

class TeamName extends StatelessWidget {
  const TeamName({
    Key key,
    @required this.data,
  }) : super(key: key);

  final Teams data;

  @override
  Widget build(BuildContext context) {
    final ThemeNotifier theme = Provider.of<ThemeNotifier>(context);
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 2.5,
          child: Text(
            data.teamName,
            style: TextStyle(
              color: theme.currentTheme.backgroundColor,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.clip,
          ),
        ),
        data.verified == 'Y'
            ? Icon(
                Icons.verified,
                size: 16.0,
              )
            : Container(),
      ],
    );
  }
}

class TeamDescription extends StatelessWidget {
  const TeamDescription({
    Key key,
    @required this.data,
  }) : super(key: key);

  final Teams data;

  @override
  Widget build(BuildContext context) {
    final ThemeNotifier theme = Provider.of<ThemeNotifier>(context);
    return Text(
      data.bio,
      style: TextStyle(
        color: theme.currentTheme.backgroundColor,
      ),
      maxLines: 2,
      overflow: TextOverflow.visible,
    );
  }
}

class TypeofTeam extends StatelessWidget {
  const TypeofTeam({
    Key key,
    @required this.data,
  }) : super(key: key);

  final Teams data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: Icon(
            data.status == "public" ? Feather.globe : Feather.lock,
            size: 16,
            color:
                data.status == "public" ? Colors.green[400] : Colors.red[400],
          ),
        ),
        Text(
          data.status == "public" ? "Public" : "private",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color:
                data.status == "public" ? Colors.green[400] : Colors.red[400],
          ),
        ),
      ],
    );
  }
}

class PlayerPreview2 extends StatelessWidget {
  const PlayerPreview2({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Container(
        padding: EdgeInsets.all(2),
        child: CircleAvatar(
          radius: 13,
          backgroundColor: Theme.of(context).cardColor,
          child: Padding(
              padding: EdgeInsets.all(3),
              child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://pbs.twimg.com/profile_images/1286371379768516608/KKBFYV_t.jpg"))),
        ),
      ),
    );
  }
}

class SportsCategory extends StatelessWidget {
  const SportsCategory({
    Key key,
    @required this.theme,
    @required this.sport,
    @required this.icon,
  }) : super(key: key);

  final ThemeNotifier theme;
  final String sport;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TeamCategory(sportName: this.sport))),
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(200)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(icon, scale: 1.8),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              sport,
              style: TextStyle(
                color: theme.currentTheme.backgroundColor,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/*
use this logic to make a challenge logic

final TeamChallengeNotification
                                                  teamData =
                                                  new TeamChallengeNotification
                                                          .newTeam(
                                                      data.teamId,
                                                      data.manager,
                                                      data.teamName);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ChallangeTeam(
                                                            sportName:
                                                                data.sport,
                                                            teamData:
                                                                teamData)),
                                              );


*/
