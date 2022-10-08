import 'dart:async';

import 'package:Runbhumi/models/Teams.dart';
import 'package:Runbhumi/services/services.dart';

import 'package:Runbhumi/view/teams/challengeScreen.dart';
import 'package:Runbhumi/view/views.dart';
import 'package:Runbhumi/widget/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:unicons/unicons.dart';
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
    required this.teamID,
    Key? key,
  }) : super(key: key);
  final String teamID;
  @override
  _TeamInfoState createState() => _TeamInfoState();
}

class _TeamInfoState extends State<TeamInfo> {
  late StreamSubscription sub;
  late Map data;
  bool _loading = false;
  late String sportIcon;

  @override
  void initState() {
    super.initState();
    sub = FirebaseFirestore.instance
        .collection('teams')
        .doc(widget.teamID)
        .snapshots()
        .listen((snap) {
      setState(() {
        data = snap.data()!;
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
    if (_loading)
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
          TeamService().removeMeFromTeam(widget.teamID);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AnimatedBottomBar()));
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
        case 'Join Team':
          if (data['notificationPlayers']
              .contains(GetStorage().read('userId'))) {
            showDialog(
              context: context,
              builder: (context) {
                return notifcationPending(context);
              },
            );
          } else {
            if (data['status'] == 'private') {
              Teams teamView = Teams.newTeam(data['teamId'], data['sport'],
                  data['teamName'], data['bio'], data['status']);
              NotificationServices().createTeamNotification(
                  GetStorage().read('userId')!, data['manager'], teamView);
            }
            if (data['status'] == 'closed' || data['playerId'].length >= 20) {
              showDialog(
                context: context,
                builder: (context) {
                  return closedTeam(context);
                },
              );
            }
            if (data['status'] == 'public') {
              TeamService().addMeInTeam(data['teamId']);
              showDialog(
                context: context,
                builder: (context) {
                  return teamJoinSuccessDialog(context, data['teamname']);
                },
              );
            }
          }
          break;
        case 'Challenge':
          final TeamChallengeNotification teamData =
              new TeamChallengeNotification.newTeam(
                  data['teamId'], data['manager'], data['teamName']);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChallangeTeam(
                    sportName: data['sport'], teamData: teamData)),
          );
          break;
        case 'Make team closed':
          return closingATeam(context, data['teamId']);
          break;
        case 'Make team public':
          return publicisingATeam(context, data['teamId']);
          break;
        case 'Make team private':
          return privatizingATeam(context, data['teamId']);
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
          leading: CustomBackButton(),
          actions: [
            PopupMenuButton<String>(
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                if (!data['playerId'].contains(GetStorage().read('userId'))) {
                  //For all the users who are viwing the teamInfo and not part of the team
                  return {'Join Team', 'Challenge'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                } else {
                  //For the users who are in the team
                  if (data['status'] == 'closed') {
                    return GetStorage().read('userId') == data['manager']
                        ? data["verified"] == 'N'
                            ? {
                                'Delete team',
                                'Send Verification Application',
                                'Make team public',
                                'Make team private'
                              }.map((String choice) {
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
                  } else {
                    return GetStorage().read('userId') == data['manager']
                        ? data["verified"] == 'N'
                            ? {
                                'Delete team',
                                'Send Verification Application',
                                'Make team closed',
                                data['status'] == 'public'
                                    ? 'Make team private'
                                    : 'Make team public'
                              }.map((String choice) {
                                return PopupMenuItem<String>(
                                  value: choice,
                                  child: Text(choice),
                                );
                              }).toList()
                            : {'Delete team', 'Make team closed'}
                                .map((String choice) {
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
                  }
                }
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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            data['bio'],
                            style: TextStyle(fontSize: 20),
                            overflow: TextOverflow.fade,
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
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
                                    ? UniconsLine.globe
                                    : UniconsLine.lock,
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
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
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
                                          subtitle: Row(
                                            children: [
                                              if (data["players"][index]
                                                      ["id"] ==
                                                  data["manager"])
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: Container(
                                                    padding: EdgeInsets.all(4),
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
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                ),
                                              if (data["players"][index]
                                                      ["id"] ==
                                                  data["captain"])
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: Container(
                                                    padding: EdgeInsets.all(4),
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
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                          trailing: GetStorage()
                                                      .read('userId') ==
                                                  data['manager']
                                              ? (data["players"][index]["id"] !=
                                                      data["manager"])
                                                  ? PopupMenuButton(
                                                      icon:
                                                          Icon(Icons.more_vert),
                                                      itemBuilder: (_) =>
                                                          data["players"]
                                                                          [
                                                                          index]
                                                                      ["id"] !=
                                                                  data[
                                                                      "captain"]
                                                              ? <
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
                                                                ]
                                                              : <
                                                                  PopupMenuItem<
                                                                      String>>[
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
                                                                data['teamId'],
                                                                data["players"]
                                                                        [index]
                                                                    ["name"]);
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
    isCloseButton: true,
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
          "Please read the requirements for a verified team before applying for verifications. Our team will be in contact with you via email for any queries",
      buttons: [
        DialogButton(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Read More",
              style: TextStyle(
                color: Colors.yellow[600],
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Faq()));
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
                fontSize: 15,
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
            // Navigator.push(context,
            // MaterialPageRoute(builder: (context) => AnimatedBottomBar()));
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
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => AnimatedBottomBar()));
          },
          color: Color.fromRGBO(128, 128, 128, 0),
        )
      ]).show();
}

SimpleDialog notifcationPending(BuildContext context) {
  return SimpleDialog(
    title: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: Icon(
            UniconsLine.info,
            size: 64,
          )),
        ),
        Center(child: Text("Notification Pending")),
      ],
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    children: [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
            child: Text(
                "Your notification is still pending. Therefore you cannot send another join request",
                style: Theme.of(context).textTheme.subtitle1)),
      ),
    ],
  );
}

SimpleDialog closedTeam(BuildContext context) {
  return SimpleDialog(
    title: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: Icon(
            UniconsLine.info,
            size: 64,
          )),
        ),
        Center(child: Text("Closed Team")),
      ],
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    children: [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
            child: Text("This team is not open for players to join",
                style: Theme.of(context).textTheme.subtitle1)),
      ),
    ],
  );
}

SimpleDialog teamJoinSuccessDialog(BuildContext context, String teamName) {
  return SimpleDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    children: [
      Center(
          child: Text("You Have been added to the team " + teamName,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline4)),
      Image.asset("assets/confirmation-illustration.png")
    ],
  );
}

closingATeam(BuildContext context, String teamId) {
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
      title: "Close Team",
      desc:
          "Are you sure you want to close this team, after this others will not be able apply for joining your team",
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
              "Close",
              style: TextStyle(
                color: Colors.redAccent[400],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onPressed: () {
            TeamService().makeTeamClosed(teamId);
            Navigator.pop(context);
          },
          color: Color.fromRGBO(128, 128, 128, 0),
        )
      ]).show();
}

publicisingATeam(BuildContext context, String teamId) {
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
      title: "Close Team",
      desc: "Are you sure you want to make this team public?",
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
              "Yes",
              style: TextStyle(
                color: Colors.redAccent[400],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onPressed: () {
            TeamService().makeTeamPublic(teamId);
            Navigator.pop(context);
          },
          color: Color.fromRGBO(128, 128, 128, 0),
        )
      ]).show();
}

privatizingATeam(BuildContext context, String teamId) {
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
      title: "Make Team private",
      desc: "Are you sure you want to make this team private?",
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
              "Yes",
              style: TextStyle(
                color: Colors.redAccent[400],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onPressed: () {
            TeamService().makeTeamPrivate(teamId);
            Navigator.pop(context);
          },
          color: Color.fromRGBO(128, 128, 128, 0),
        )
      ]).show();
}
