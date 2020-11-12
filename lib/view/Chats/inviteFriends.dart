import 'package:Runbhumi/widget/buildTitle.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: buildTitle(context, "Invite Friends"),
        automaticallyImplyLeading: false,
      ),
      //TODO: List of all freinds with an invite button.
    );
  }
}
