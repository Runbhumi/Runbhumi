import 'dart:async';

import 'package:Runbhumi/services/services.dart';
import 'package:Runbhumi/utils/Constants.dart';
import 'package:Runbhumi/view/views.dart';
import 'package:Runbhumi/widget/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

// addMeInTeam(String teamId) => can pe used in a public team to join directly as a player
// removeMeFromTeam(String teamId) => every player has a right to leave team if  they want but not the manager
/*
Sai Rohan Bangari12:32 PM
(playersId.contains(Constant.prefs.getString(userId)) == true)
Leave

(playersId.contains(Constant.prefs.getString(userId)) == true && Constant.prefs.getString(userId) == manager)
Delete Team
Verify Team


 (playersId.contains(Constant.prefs.getString(userId)) == false)
Join Team
Challenge Team
(playersId.contains(Constant.prefs.getString(userId)) == true)
Leave
Chat

(playersId.contains(Constant.prefs.getString(userId)) == true && Constant.prefs.getString(userId) == manager)
Delete Team
Verify Team
Chat


 (playersId.contains(Constant.prefs.getString(userId)) == false)
Join Team
Challenge Team

*/
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
  String sportIcon;

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
    // IconData sportIcon;
    switch (data['sport']) {
      case "Volleyball":
        sportIcon = "assets/icons8-volleyball-96.png";
        break;
      case "Basketball":
        // sportIcon = Icons.sports_basketball;
        sportIcon = "assets/icons8-basketball-96.png";
        break;
      case "Cricket":
        sportIcon = "assets/icons8-cricket-96.png";
        break;
      case "Football":
        sportIcon = "assets/icons8-soccer-ball-96.png";
        break;
    }
    void handleClick(String value) {
      switch (value) {
        case 'Leave team':
          //TODO: add funtionality
          TeamService().removeMeFromTeam(widget.teamID);
          Navigator.pushNamed(context, '/mainapp');
          break;
        case 'Transfer Captainship':
          //Can we have this option for every player in the list builder.
          break;
        case 'Send Verification Application':
          //Method to send verification.
          break;
        case 'Delete team':
          //Still facing issues with this code
          TeamService().deleteTeam(data['manager'], widget.teamID);
          Navigator.pushNamed(context, '/mainapp');
          break;
      }
    }

    if (_loading)
      return Scaffold(
        appBar: AppBar(
          title: buildTitle(
            context,
            data['teamname'],
          ),
          leading: BackButton(),
          actions: [
            PopupMenuButton<String>(
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                return Constants.prefs.getString('userId') == data['manager']
                    ? {
                        'Delete team',
                        'Transfer Captainship',
                        'Send Verification Application'
                      }.map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),
                        );
                      }).toList()
                    : {'Leave team'}.map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),
                        );
                      }).toList();
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // for image
            Stack(
              children: [
                // Container(
                //   width: 115,
                //   height: 115,
                //   child: Loader(),
                //   margin: EdgeInsets.only(top: 8),
                // ),
                Container(
                  width: 115,
                  height: 115,
                  margin: EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(32)),
                    // I didnt had images
                    image: DecorationImage(
                      image: AssetImage(sportIcon),
                      fit: BoxFit.fitWidth,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x0800d2ff),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            //Bio
            Padding(
              padding: const EdgeInsets.only(
                bottom: 8.0,
                left: 16.0,
                right: 32.0,
              ),
              child: Text(
                data['bio'],
                style: TextStyle(fontSize: 14),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                data["status"] == "public"
                                    ? Feather.globe
                                    : Feather.lock,
                                size: 20,
                                color: data["status"] == "public"
                                    ? Colors.green[400]
                                    : Colors.red[400],
                              ),
                            ),
                            Text(
                              data["status"] == 1 ? "Public" : "private",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: data["status"] == "public"
                                    ? Colors.green[400]
                                    : Colors.red[400],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          ListView.builder(
                            itemCount: data["playerId"].length,
                            itemBuilder: (context, index) {
                              return Padding(
                                //TODO: For each tile can you please check if the person is not a captain and
                                //not a manager then display the button to make him captain
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 0.0),
                                child: Card(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              OtherUserProfile(
                                            userID: data["players"][index]
                                                ["id"],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: ListTile(
                                            contentPadding: EdgeInsets.all(0),
                                            leading: Container(
                                              height: 48,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                child: Image.network(
                                                    data["players"][index]
                                                        ["profileImage"],
                                                    height: 48),
                                              ),
                                            ),
                                            title: Text(
                                              data["players"][index]["name"],
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            trailing: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                if (data["players"][index]
                                                        ["id"] ==
                                                    data["manager"])
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            2.0),
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(4),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    8)),
                                                      ),
                                                      child: Text(
                                                        "Manager",
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ),
                                                  ),
                                                if (data["players"][index]
                                                        ["id"] ==
                                                    data["captain"])
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            2.0),
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(4),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    8)),
                                                      ),
                                                      child: Text(
                                                        "Captain",
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    else
      return Loader();
  }
}
