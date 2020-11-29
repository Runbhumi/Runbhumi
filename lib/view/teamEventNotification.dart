import 'package:Runbhumi/models/models.dart';
import 'package:Runbhumi/services/services.dart';
import 'package:Runbhumi/widget/widgets.dart';
import 'package:flutter/material.dart';

class TeamEventNotification extends StatefulWidget {
  final Events data;
  TeamEventNotification({Key key, @required this.data}) : super(key: key);
  @override
  _TeamEventNotificationState createState() => _TeamEventNotificationState();
}

class _TeamEventNotificationState extends State<TeamEventNotification> {
  Stream currentTeams;
  void initState() {
    super.initState();
    getUserManagingTeams(widget.data.sportName);
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
                                  myText: "Register Team",
                                  myColor: Theme.of(context).primaryColor,
                                  //TODO: Change it to the theme
                                  onPressed: () {
                                    if (widget.data.type == 2) {
                                      //private
                                      NotificationServices()
                                          .teamEventNotification(
                                              widget.data, data)
                                          .then(Navigator.pushNamed(
                                              context, '/mainapp'));
                                    } else {
                                      addTeamToEvent(widget.data, data);
                                      Navigator.pushNamed(context, '/mainapp');
                                      //TODO: Directly add the team to the event.
                                    }
                                    // TeamChallengeNotification myTeam =
                                    //     new TeamChallengeNotification.newTeam(
                                    //         data.teamId,
                                    //         Constants.prefs.getString('userId'),
                                    //         data.teamName);
                                    // NotificationServices()
                                    //     .challengeTeamNotification(
                                    //         widget.sportName,
                                    //         widget.teamData,
                                    //         myTeam)
                                    //     .then(() {
                                    //   //TODO : add a success notification that a challenge is created will be notified when opponents accepts it
                                    // });
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
