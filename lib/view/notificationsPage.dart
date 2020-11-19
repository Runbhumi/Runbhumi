import 'package:Runbhumi/models/models.dart';
import 'package:Runbhumi/services/services.dart';
import 'package:Runbhumi/widget/widgets.dart';
import 'package:flutter/material.dart';

import 'package:flutter_icons/flutter_icons.dart';

import 'views.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  Stream notification;

  void initState() {
    super.initState();
    getUserNotifications();
  }

  getUserNotifications() async {
    NotificationServices().getNotification().then(
      (snapshots) {
        setState(
          () {
            notification = snapshots;
            print("we got the data");
          },
        );
      },
    );
  }

  Widget notificationList() {
    return StreamBuilder(
      stream: notification,
      builder: (context, asyncSnapshot) {
        print("Working " + asyncSnapshot.hasData.toString());
        return asyncSnapshot.hasData
            ? asyncSnapshot.data.documents.length > 0
                ? ListView.builder(
                    itemCount: asyncSnapshot.data.documents.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      NotificationClass notificationData =
                          new NotificationClass.fromJson(
                              asyncSnapshot.data.documents[index]);
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 4.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OtherUserProfile(
                                  userID: notificationData.senderId,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            shadowColor: Color(0x33393e46),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            elevation: 20,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    notificationData.type != "inviteTeams"
                                        // leading image for friend request
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                            child: Image(
                                                height: 75,
                                                image: NetworkImage(
                                                    notificationData
                                                        .senderProfieImage)),
                                          )
                                        // leading image for team join request
                                        : Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: GestureDetector(
                                              onTap: () {},
                                              child: Stack(
                                                  alignment:
                                                      AlignmentDirectional
                                                          .center,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    8.0)),
                                                        color: Colors.grey[200],
                                                      ),
                                                      width: 54,
                                                      height: 54,
                                                    ),
                                                    Icon(
                                                      Feather.hash,
                                                      color: Colors.grey[700],
                                                      size: 44,
                                                    ),
                                                  ]),
                                            ),
                                          ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          notificationData.senderName,
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          notificationData.type != "inviteTeams"
                                              ? "friend request"
                                              : "team invite",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          NotificationServices().declineRequest(
                                              notificationData.notificationId,
                                              notificationData.senderId);
                                        },
                                        child: Stack(
                                            alignment:
                                                AlignmentDirectional.center,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8.0)),
                                                  color: Colors.red[100],
                                                ),
                                                width: 42,
                                                height: 42,
                                              ),
                                              Icon(
                                                Feather.x,
                                                color: Colors.red,
                                                size: 36,
                                              ),
                                            ]),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          NotificationServices()
                                              .acceptFriendRequest(
                                                  notificationData);
                                        },
                                        child: Stack(
                                            alignment:
                                                AlignmentDirectional.center,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8.0)),
                                                  color: Colors.green[100],
                                                ),
                                                width: 42,
                                                height: 42,
                                              ),
                                              Icon(
                                                Feather.check,
                                                color: Colors.green,
                                                size: 36,
                                              ),
                                            ]),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : // if there is no notification you will get this illustration
                Container(
                    child: Center(
                      child: Image.asset("assets/notification.png"),
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
        title: buildTitle(context, "Notifications"),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: <Widget>[
                notificationList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
