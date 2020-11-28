import 'package:Runbhumi/models/models.dart';
import 'package:Runbhumi/services/services.dart';
import 'package:Runbhumi/utils/Constants.dart';
import 'package:Runbhumi/utils/theme_config.dart';
import 'package:Runbhumi/widget/loader.dart';
import 'package:Runbhumi/widget/widgets.dart';
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
