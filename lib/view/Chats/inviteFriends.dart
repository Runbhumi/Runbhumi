// import 'package:Runbhumi/utils/Constants.dart';
import 'package:Runbhumi/models/models.dart';
import 'package:Runbhumi/services/services.dart';
import 'package:Runbhumi/widget/buildTitle.dart';
import 'package:Runbhumi/widget/button.dart';
import 'package:Runbhumi/widget/loader.dart';
import 'package:flutter/material.dart';

class InviteFriends extends StatefulWidget {
  final Teams team;
  //TeamId will help us trigger the notification for that particular team
  InviteFriends({
    @required this.team,
  });
  @override
  _InviteFriendsState createState() => _InviteFriendsState();
}

class _InviteFriendsState extends State<InviteFriends> {
  Stream userFriends;

  void initState() {
    super.initState();
    getUserFriends();
  }

  getUserFriends() async {
    UserService().getFriends().then((snapshots) {
      setState(() {
        userFriends = snapshots;
        print("we got the data for friends list ");
      });
    });
  }

  Widget friends() {
    //bool oneTimeCheck = false;
    return StreamBuilder(
      stream: userFriends,
      builder: (context, asyncSnapshot) {
        //print("friends list is loading");
        return asyncSnapshot.hasData
            ? asyncSnapshot.data.documents.length > 0
                ? ListView.builder(
                    itemCount: asyncSnapshot.data.documents.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      Friends data = new Friends.fromJson(
                          asyncSnapshot.data.documents[index]);

                      if (widget.team.playerId.contains(data.friendId))
                        return ListTile(
                          leading:
                              Image(image: NetworkImage(data.profileImage)),
                          title: Text(data.name),
                          trailing: Button(
                            myText: "Aready In Team",
                            myColor: Theme.of(context).primaryColor,
                            onPressed: () {
                              // ------- When the user in already in the team  ---------------
                            },
                          ),
                        );
                      else if (widget.team.notificationPlayers.length > 20)
                        return ListTile(
                          leading:
                              Image(image: NetworkImage(data.profileImage)),
                          title: Text(data.name),
                          trailing: Button(
                            myText: "Invite Sent",
                            myColor: Theme.of(context).primaryColor,
                            onPressed: () {
                              // Alert the user that he is exceeding the limit of members in the group
                            },
                          ),
                        );
                      else if (widget.team.notificationPlayers.length > 0 &&
                          widget.team.notificationPlayers
                              .contains(data.friendId))
                        return buttonInviteFriends(
                            data, context, "Invite Sent");
                      else
                        return ListTile(
                          leading:
                              Image(image: NetworkImage(data.profileImage)),
                          title: Text(data.name),
                          trailing: Button(
                            myText: "Invite",
                            myColor: Theme.of(context).primaryColor,
                            onPressed: () {
                              // ------- When the user is not in the team  ---------------
                              NotificationServices().createTeamNotification(
                                  data.friendId, data.friendId, widget.team);
                            },
                          ),
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

  ListTile buttonInviteFriends(
      Friends data, BuildContext context, String text) {
    return ListTile(
      leading: Image(image: NetworkImage(data.profileImage)),
      title: Text(data.name),
      trailing: Button(
        myText: text,
        myColor: Theme.of(context).primaryColor,
        onPressed: () {
          //------- Code to send a team joining notification ---------------
          //Use Team Id to refer to the team and pass on to the notification
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: buildTitle(context, "Invite Friends"),
        automaticallyImplyLeading: false,
      ),
      body: Column(children: [
        friends(),
        Button(
          myText: 'Leave',
          myColor: Colors.blue,
          onPressed: () {
            Navigator.pushNamed(context, '/mainapp');
          },
        ),
      ]),
    );
  }
}
