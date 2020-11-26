import 'package:Runbhumi/models/models.dart';
import 'package:Runbhumi/services/services.dart';
import 'package:Runbhumi/utils/Constants.dart';
import 'package:Runbhumi/widget/button.dart';
import 'package:Runbhumi/widget/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChallangeTeam extends StatefulWidget {
  final String sportName;
  final TeamChallengeNotification teamData;
  ChallangeTeam({Key key, this.sportName, this.teamData}) : super(key: key);
  @override
  _ChallangeTeamState createState() => _ChallangeTeamState();
}

class _ChallangeTeamState extends State<ChallangeTeam> {
  Stream currentTeams;
  void initState() {
    super.initState();
    getUserManagingTeams(widget.sportName);
  }

  getUserManagingTeams(String sport) async {
    await UserService().getTeams(sport).then((snapshots) {
      setState(() {
        currentTeams = snapshots;
      });
    });
  }

  Widget feed() {
    return StreamBuilder(
        stream: currentTeams,
        builder: (context, asyncSnapshot) {
          return asyncSnapshot.hasData
              ? asyncSnapshot.data.documents.length > 0
                  ? ListView.builder(
                      itemCount: asyncSnapshot.data.documents.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        TeamView data = new TeamView.fromJson(
                            asyncSnapshot.data.documents[index]);
                        return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            child: Card(
                                child: Column(
                              children: [
                                Text(
                                  data.teamName,
                                  style: TextStyle(
                                    color: Color.fromARGB(32, 32, 32, 32),
                                  ),
                                ),
                                Button(
                                  myText: "Challenge",
                                  myColor: Color.fromARGB(32, 32, 32, 32),
                                  onPressed: () {
                                    TeamChallengeNotification myTeam =
                                        new TeamChallengeNotification.newTeam(
                                            data.teamId,
                                            Constants.prefs.getString('userId'),
                                            data.teamName);
                                    NotificationServices()
                                        .challengeTeamNotification(
                                            widget.sportName,
                                            widget.teamData,
                                            myTeam)
                                        .then(() {
                                      //TODO : add a success notification that a challenge is created will be notified when opponents accepts it
                                    });
                                  },
                                )
                              ],
                            )));
                      })
                  : Container(
                      child: Center(
                        child: Image.asset("assets/notification.png"),
                      ),
                    )
              : Loader();
        });
  }

  Widget build(context) {
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
              child: Text(
                'Teams You Manage',
                style: TextStyle(
                  color: Color.fromARGB(32, 32, 32, 32),
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: Stack(
                children: <Widget>[
                  feed(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
