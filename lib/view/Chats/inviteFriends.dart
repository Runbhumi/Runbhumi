import 'package:Runbhumi/services/UserServices.dart';
import 'package:Runbhumi/widget/buildTitle.dart';
import 'package:Runbhumi/widget/button.dart';
import 'package:Runbhumi/widget/loader.dart';
import 'package:flutter/material.dart';

class InviteFriends extends StatefulWidget {
  final String teamId;
  //TeamId will help us trigger the notification for that particular team
  InviteFriends({
    @required this.teamId,
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
    return StreamBuilder(
      stream: userFriends,
      builder: (context, asyncSnapshot) {
        print("friends list is loading");
        return asyncSnapshot.hasData
            ? asyncSnapshot.data.documents.length > 0
                ? ListView.builder(
                    itemCount: asyncSnapshot.data.documents.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Image(
                            image: NetworkImage(asyncSnapshot
                                .data.documents[index]
                                .get('profileImage'))),
                        title: Text(
                            asyncSnapshot.data.documents[index].get('name')),
                        trailing: Button(
                          myText: "Invite",
                          myColor: Theme.of(context).primaryColor,
                          onPressed: () {
                            //------- Code to send a team joining notification ---------------
                            //Use Team Id to refer to the team and pass on to the notification
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: buildTitle(context, "Invite Friends"),
        automaticallyImplyLeading: false,
      ),
      body: friends(),
    );
  }
}
