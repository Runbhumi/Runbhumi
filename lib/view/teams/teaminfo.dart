import 'dart:async';

import 'package:Runbhumi/services/services.dart';
import 'package:Runbhumi/utils/Constants.dart';
import 'package:Runbhumi/view/views.dart';
import 'package:Runbhumi/widget/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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
        case 'Send Verification Application':
          confirmationPopup(
              context, data['teamId'], data['sport'], data['teamname']);
          //Method to send verification.
          break;
        case 'Delete team':
          //Still facing issues with this code
          // setState(() {
          //   _loading = false;
          // });
          confirmationPopup2(context, data['teamId'], data['manager']);
          // setState(() {
          //   _loading = true;
          // });
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
                    ? data["verified"] == 'N'
                        ? {'Delete team', 'Send Verification Application'}
                            .map((String choice) {
                            return PopupMenuItem<String>(
                              value: choice,
                              child: Text(choice),
                            );
                          }).toList()
                        : {
                            'Delete team',
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
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //Bio
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 8.0,
                          left: 16.0,
                          right: 16.0,
                        ),
                        child: Text(
                          data['bio'],
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
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
                              data["status"] == "public" ? "Public" : "private",
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
                  ),
                  if (data["verified"] == 'Y')
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image(
                                  image: AssetImage("assets/verified.png"),
                                ),
                              ),
                              Text(
                                "Verified",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).primaryColor,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: Stack(
                      children: [
                        ListView.builder(
                          itemCount: data["playerId"].length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Card(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OtherUserProfile(
                                          userID: data["players"][index]["id"],
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
                                              // child: Image.network(
                                              //   data["players"][index]
                                              //       ["profileImage"],
                                              //   height: 48,
                                              // ),
                                              child: FadeInImage(
                                                placeholder: AssetImage(
                                                    "assets/ProfilePlaceholder.png"),
                                                image: NetworkImage(
                                                  data["players"][index]
                                                      ["profileImage"],
                                                ),
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            data["players"][index]["name"],
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          subtitle: (Constants.prefs.getString(
                                                          'userId') ==
                                                      data['manager'] ||
                                                  Constants.prefs.getString(
                                                          'userId') ==
                                                      data['captain'])
                                              ? Row(
                                                  children: [
                                                    if (data["players"][index]
                                                            ["id"] ==
                                                        data["manager"])
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(2.0),
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(4),
                                                          decoration:
                                                              BoxDecoration(
                                                            border:
                                                                Border.all(),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
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
                                                            const EdgeInsets
                                                                .all(2.0),
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(4),
                                                          decoration:
                                                              BoxDecoration(
                                                            border:
                                                                Border.all(),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
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
                                                )
                                              : null,
                                          trailing: Constants.prefs
                                                      .getString('userId') ==
                                                  data['manager']
                                              ? (data["players"][index]["id"] !=
                                                      data["manager"])
                                                  ? PopupMenuButton(
                                                      icon:
                                                          Icon(Icons.more_vert),
                                                      itemBuilder: (_) => <
                                                          PopupMenuItem<
                                                              String>>[
                                                        new PopupMenuItem<
                                                                String>(
                                                            child: new Text(
                                                                'Transfer captainship'),
                                                            value:
                                                                'Transfer captainship'),
                                                        new PopupMenuItem<
                                                                String>(
                                                            child: new Text(
                                                                'Remove member'),
                                                            value:
                                                                'Remove member'),
                                                      ],
                                                      onSelected:
                                                          (theChosenOne) {
                                                        switch (theChosenOne) {
                                                          case 'Transfer captainship':
                                                            //add functionality
                                                            TeamService().setCaptain(
                                                                data["players"]
                                                                        [index]
                                                                    ["id"],
                                                                data['teamId']);
                                                            break;
                                                          case 'Remove member':
                                                            //add functionality
                                                            TeamService().removePlayerFromTeam(
                                                                data['teamId'],
                                                                data["players"]
                                                                        [index]
                                                                    ['id'],
                                                                data["players"]
                                                                        [index]
                                                                    ['name'],
                                                                data["players"]
                                                                        [index][
                                                                    'profileImage']);
                                                            break;
                                                        }
                                                      },
                                                    )
                                                  : null
                                              : null,
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
          ],
        ),
      );
    else
      return Loader();
  }
}

confirmationPopup(
    BuildContext context, String teamId, String sport, String teamName) {
  var alertStyle = AlertStyle(
    animationType: AnimationType.fromBottom,
    isCloseButton: false,
    isOverlayTapDismiss: true,
    titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    descStyle: TextStyle(
        fontWeight: FontWeight.w500, fontSize: 18, color: Colors.grey[600]),
    alertAlignment: Alignment.center,
    animationDuration: Duration(milliseconds: 400),
  );

  Alert(
      context: context,
      style: alertStyle,
      title: "Apply for Verification",
      desc:
          "Please read the requirmnets for a verified team before applying for verifications. Our team will be in contact with you via email for any queries",
      buttons: [
        DialogButton(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Cancel",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Color.fromRGBO(128, 128, 128, 0),
        ),
        DialogButton(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Apply",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onPressed: () {
            TeamService().sendVerificationApplication(teamId, sport, teamName);
            Navigator.pop(context);
          },
          color: Color.fromRGBO(128, 128, 128, 0),
        )
      ]).show();
}

confirmationPopup2(BuildContext context, String teamId, String manager) {
  var alertStyle = AlertStyle(
    animationType: AnimationType.fromBottom,
    isCloseButton: false,
    isOverlayTapDismiss: true,
    titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    descStyle: TextStyle(
        fontWeight: FontWeight.w500, fontSize: 18, color: Colors.grey[600]),
    alertAlignment: Alignment.center,
    animationDuration: Duration(milliseconds: 400),
  );

  Alert(
      context: context,
      style: alertStyle,
      title: "Delete Team",
      desc: "Are you sure you want to delete this team",
      buttons: [
        DialogButton(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Cancel",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
            // Navigator.pushNamed(context, '/mainapp');
          },
          color: Color.fromRGBO(128, 128, 128, 0),
        ),
        DialogButton(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Delete",
              style: TextStyle(
                color: Colors.redAccent[400],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onPressed: () {
            // FriendServices().removeFriend(id1, id2);
            TeamService().deleteTeam(manager, teamId);
            Navigator.pop(context);
            Navigator.pushNamed(context, '/mainapp');
          },
          color: Color.fromRGBO(128, 128, 128, 0),
        )
      ]).show();
}
