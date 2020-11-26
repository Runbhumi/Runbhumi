import 'dart:async';
import 'package:Runbhumi/services/services.dart';
import 'package:Runbhumi/utils/Constants.dart';
import 'package:Runbhumi/widget/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class OtherUserProfile extends StatefulWidget {
  const OtherUserProfile({
    @required this.userID,
    Key key,
  }) : super(key: key);
  final String userID;

  @override
  _OtherUserProfileState createState() => _OtherUserProfileState();
}

class _OtherUserProfileState extends State<OtherUserProfile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: buildTitle(context, "Profile"),
        leading: BackButton(),
      ),
      body: OtherProfileBody(
        userID: widget.userID,
      ),
    );
  }
}

class OtherProfileBody extends StatefulWidget {
  const OtherProfileBody({
    @required this.userID,
    Key key,
  }) : super(key: key);
  final String userID;

  @override
  _OtherProfileBodyState createState() => _OtherProfileBodyState();
}

class _OtherProfileBodyState extends State<OtherProfileBody> {
  final db = FirebaseFirestore.instance;
  StreamSubscription sub;
  Map data;
  bool _loading = false;
  @override
  void initState() {
    super.initState();
    sub = db.collection('users').doc(widget.userID).snapshots().listen((snap) {
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

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: UserProfile(data: data),
              ),
            ],
          ),
        ),
      );
    } else {
      return Loader();
    }
  }
}

class UserProfile extends StatelessWidget {
  const UserProfile({
    Key key,
    @required this.data,
  }) : super(key: key);

  final Map data;

  @override
  Widget build(BuildContext context) {
    // if (data['friends'].contains(Constants.prefs.getString('userId')))
    //   print('Its is true');
    String _id = Constants.prefs.getString('userId');
    return Column(
      children: [
        //profile image
        if (data['profileImage'] != null)
          Container(
            width: 115,
            height: 115,
            margin: EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(32)),
              image: DecorationImage(
                image: NetworkImage(data['profileImage']),
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
        //Name
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            data['name'],
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
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        // button
        if (data['friends'].contains(_id) && data['userId'] != _id)
          // remove friend btn
          Button(
            myColor: Colors.redAccent[400],
            myText: "Remove Friend",
            onPressed: () {
              // a confirmation is required because its a serious action
              confirmationPopup(context, data['name'], data['userId'], _id);
            },
          ),

        if (data['userId'] != _id &&
            !(data['friends'].contains(_id)) &&
            data['notification'].contains(_id))
          //request sent btn
          OutlineButton(
            padding: const EdgeInsets.all(16.0),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2.0,
            ),
            highlightedBorderColor: Theme.of(context).primaryColor,
            color: Theme.of(context).primaryColor,
            child: Text(
              "Request Sent",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            onPressed: () {},
          ),
        if (data['userId'] != _id &&
            !(data['friends'].contains(_id)) &&
            !(data['notification'].contains(_id)))
          //add friend btn
          Button(
            myColor: Theme.of(context).primaryColor,
            myText: "Add Friend",
            onPressed: () {
              NotificationServices().createRequest(data['userId']);
            },
          ),
        //stats
        Card(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      data['eventCount'].toString(),
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "events",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      data['teamsCount'].toString(),
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "teams",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      data['friendCount'].toString(),
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "friends",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        //details
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (data["age"] != "")
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
                        data["age"],
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                if (data["location"] != "")
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Feather.map_pin,
                          size: 24.0,
                        ),
                      ),
                      Text(
                        data["location"],
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Feather.mail,
                        size: 24.0,
                      ),
                    ),
                    Text(
                      data["emailId"],
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                if (data['phoneNumber']['show'])
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Feather.phone,
                          size: 24.0,
                        ),
                      ),
                      Text(
                        data['phoneNumber']['ph'],
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
      ],
    );
  }
}

confirmationPopup(BuildContext context, String name, String id1, String id2) {
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
      title: "Remove Friend",
      desc: "Are you sure you want to remove " + name + " as friend",
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
              "Remove",
              style: TextStyle(
                color: Colors.redAccent[400],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onPressed: () {
            FriendServices().removeFriend(id1, id2);
            Navigator.pop(context);
          },
          color: Color.fromRGBO(128, 128, 128, 0),
        )
      ]).show();
}
