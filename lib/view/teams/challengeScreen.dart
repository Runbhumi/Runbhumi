import 'package:Runbhumi/models/models.dart';
import 'package:Runbhumi/services/services.dart';
import 'package:Runbhumi/utils/Constants.dart';
import 'package:Runbhumi/view/views.dart';
import 'package:Runbhumi/widget/button.dart';
import 'package:Runbhumi/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

class ChallangeTeam extends StatefulWidget {
  final String sportName;
  final TeamChallengeNotification teamData;
  ChallangeTeam({Key? key, this.sportName, this.teamData}) : super(key: key);
  @override
  _ChallangeTeamState createState() => _ChallangeTeamState();
}

class _ChallangeTeamState extends State<ChallangeTeam> {
  Stream currentTeams;
  void initState() {
    super.initState();
    getUserManagingTeams(widget.sportName);
  }

  SimpleDialog successDialog(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      children: [
        Center(
            child: Text("Challenge created",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline4)),
        Image.asset("assets/confirmation-illustration.png")
      ],
    );
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
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Card(
                            child: ListTile(
                              contentPadding: EdgeInsets.all(0),
                              leading: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image(
                                  image: AssetImage(sportIcon),
                                  width: 70,
                                ),
                              ),
                              title: Text(
                                data.teamName,
                              ),
                              trailing: Padding(
                                padding: const EdgeInsets.only(
                                    top: 4.0, bottom: 4, left: 4, right: 8),
                                child: GestureDetector(
                                  onTap: () {
                                    TeamChallengeNotification myTeam =
                                        new TeamChallengeNotification.newTeam(
                                            data.teamId,
                                            Constants.prefs.getString('userId'),
                                            data.teamName);

                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          NotificationServices()
                                              .challengeTeamNotification(
                                                  widget.sportName,
                                                  widget.teamData,
                                                  myTeam);
                                          Future.delayed(Duration(seconds: 3),
                                              () {
                                            Navigator.pop(context);
                                          });
                                          return successDialog(context);
                                        });
                                  },
                                  child: Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0)),
                                          color: Colors.green[100],
                                        ),
                                        width: 36,
                                        height: 36,
                                      ),
                                      Icon(
                                        UniconsLine.check,
                                        color: Colors.green,
                                        size: 24,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      })
                  : Container(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(
                              "assets/notification.png",
                              scale: 1.5,
                            ),
                            Text(
                              "Dont have a team 😓",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Button(
                              buttonTitle: 'Create one',
                              bgColor: Theme.of(context).primaryColor,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return CreateTeam();
                                    },
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    )
              : Loader();
        });
  }

  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(UniconsLine.x),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
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
