import 'dart:async';

import 'package:Runbhumi/widget/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

// addMeInTeam(String teamId) => can pe used in a public team to join directly as a player
// removeMeFromTeam(String teamId) => every player has a right to leave team if  they want but not the manager

class TeamInfo extends StatefulWidget {
  const TeamInfo({
    @required this.teamID,
    Key key,
  }) : super(key: key);
  final String teamID;
  @override
  _TeamInfoState createState() => _TeamInfoState();
}

class _TeamInfoState extends State<TeamInfo> {
  StreamSubscription sub;
  Map data;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    sub = FirebaseFirestore.instance
        .collection('teams')
        .doc(widget.teamID)
        .snapshots()
        .listen((snap) {
      setState(() {
        data = snap.data();
        _loading = true;
      });
    });
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    if (_loading)
      return Column(
        children: [
          //profile image
          if (data['image'] != null)
            Container(
              width: 125,
              height: 125,
              margin: EdgeInsets.only(top: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(32)),
                image: DecorationImage(
                  image: NetworkImage(data['image']),
                  fit: BoxFit.contain,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x44393e46),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
            ),
          //Name
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              data['teamname'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
          ),
          //Bio
          Padding(
            padding: const EdgeInsets.only(
              bottom: 8.0,
              left: 32.0,
              right: 32.0,
            ),
            child: Center(
              child: Text(
                data['bio'],
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (data["sport"] != "")
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Feather.user,
                            size: 24.0,
                          ),
                        ),
                        Text(
                          data["status"],
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          // ListView.builder(
          //     itemCount: data['players'].length(),
          //     shrinkWrap: true,
          //     itemBuilder: (context, index) {
          //       return SingleFriendCard(
          //         imageLink: data['players']['profileImage'],
          //         name: data['players']['name'],
          //         userId: data['players']['userId'],
          //       );
          //     })
        ],
      );
    else
      return Loader();
  }
}
