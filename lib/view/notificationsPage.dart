import 'package:Runbhumi/models/models.dart';
import 'package:Runbhumi/services/services.dart';
import 'package:Runbhumi/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
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
            print("✅we got the notifications data");
          },
        );
      },
    );
  }

  Widget notificationList() {
    return StreamBuilder(
      stream: notification,
      builder: (context, asyncSnapshot) {
        print("⌚data loading " + asyncSnapshot.hasData.toString());
        if (asyncSnapshot.hasData) {
          if (asyncSnapshot.data.documents.length > 0) {
            return ListView.builder(
              itemCount: asyncSnapshot.data.documents.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                NotificationClass notificationData =
                    new NotificationClass.fromJson(
                        asyncSnapshot.data.documents[index]);
                if (notificationData.type == 'challenge') {
                  ChallengeNotification notificationData =
                      new ChallengeNotification.fromJson(
                          asyncSnapshot.data.documents[index]);
                  //Challenge notification Card
                  return ChallengeNotificationCard(
                      notificationData: notificationData);
                } else if (notificationData.type == 'inviteTeams') {
                  TeamNotification notificationData =
                      new TeamNotification.fromJson(
                          asyncSnapshot.data.documents[index]);
                  //Invite Team Notification Card
                  return TeamJoinRequestNotificationCard(
                      notificationData: notificationData);
                } else if (notificationData.type == 'event') {
                  EventNotification notificationData =
                      new EventNotification.fromJson(
                          asyncSnapshot.data.documents[index]);
                  if (notificationData.subtype == 'individual') {
                    //Individual Event Notification Card
                    return IndividualEventNotificationCard(
                        notificationData: notificationData);
                  } else {
                    //Team Event Notification Card
                    return TeamEventNotificationCard(
                        notificationData: notificationData);
                  }
                }
                //friend request
                return FriendRequestNotificationCard(
                    notificationData: notificationData);
              },
            );
          } else {
            return Container(
              child: Center(
                child: Image.asset("assets/notification.png"),
              ),
            );
          }
        } else {
          return Loader();
        }
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

class FriendRequestNotificationCard extends StatelessWidget {
  const FriendRequestNotificationCard({
    Key key,
    @required this.notificationData,
  }) : super(key: key);

  final NotificationClass notificationData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
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
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            child: Image(
                              height: 48,
                              width: 48,
                              fit: BoxFit.fitWidth,
                              image: NetworkImage(
                                notificationData.senderProfieImage,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            notificationData.senderName,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
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
                        padding: const EdgeInsets.all(4.0),
                        child: GestureDetector(
                          onTap: () {
                            NotificationServices().declineRequest(
                                notificationData.notificationId,
                                notificationData.senderId);
                          },
                          child: Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    color: Colors.red[100],
                                  ),
                                  width: 36,
                                  height: 36,
                                ),
                                Icon(
                                  UniconsLine.x,
                                  color: Colors.red,
                                  size: 24,
                                ),
                              ]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 4.0, bottom: 4, left: 4, right: 8),
                        child: GestureDetector(
                          onTap: () {
                            NotificationServices()
                                .acceptFriendRequest(notificationData);
                          },
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  color: Colors.green[100],
                                ),
                                width: 36,
                                height: 36,
                              ),
                              Icon(
                                UniconsLine.check,
                                color: Colors.green,
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                child: Row(
                  children: [
                    Icon(
                      UniconsLine.info,
                      size: 13.0,
                    ),
                    SizedBox(width: 4),
                    Text(
                      "friend request",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TeamEventNotificationCard extends StatelessWidget {
  const TeamEventNotificationCard({
    Key key,
    @required this.notificationData,
  }) : super(key: key);

  final EventNotification notificationData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Card(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: GestureDetector(
                //     child: ClipRRect(
                //       borderRadius: BorderRadius.all(Radius.circular(20)),
                //       child: Image(
                //         height: 48,
                //         width: 48,
                //         fit: BoxFit.fitWidth,
                //         image: NetworkImage(
                //           "https://images.vexels.com/media/users/3/180359/isolated/preview/d4db35c3bd47285887403268f0db298a-go-team-badge-by-vexels.png",
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notificationData.teamName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "wants to join",
                        style: TextStyle(
                          color: Theme.of(context)
                              .backgroundColor
                              .withOpacity(0.45),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        notificationData.eventName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: GestureDetector(
                        onTap: () async {
                          await NotificationServices().declineTeamRequest(
                              notificationData.eventId,
                              notificationData.notificationId,
                              notificationData.senderId);
                        },
                        child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  color: Colors.red[100],
                                ),
                                width: 36,
                                height: 36,
                              ),
                              Icon(
                                UniconsLine.x,
                                color: Colors.red,
                                size: 24,
                              ),
                            ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 4.0, bottom: 4, left: 4, right: 8),
                      child: GestureDetector(
                        onTap: () {
                          NotificationServices()
                              .acceptTeamEventNotification(notificationData);
                        },
                        child: Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                color: Colors.green[100],
                              ),
                              width: 36,
                              height: 36,
                            ),
                            Icon(
                              UniconsLine.check,
                              color: Colors.green,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
              child: Row(
                children: [
                  Icon(
                    UniconsLine.info,
                    size: 13.0,
                  ),
                  SizedBox(width: 4),
                  Text(
                    "team event join request",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IndividualEventNotificationCard extends StatelessWidget {
  const IndividualEventNotificationCard({
    Key key,
    @required this.notificationData,
  }) : super(key: key);

  final EventNotification notificationData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Card(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          child: Image(
                            height: 48,
                            width: 48,
                            fit: BoxFit.fitWidth,
                            image: NetworkImage(
                              notificationData.senderPic,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notificationData.senderName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "wants to join",
                          style: TextStyle(
                            color: Theme.of(context)
                                .backgroundColor
                                .withOpacity(0.45),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          notificationData.eventName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
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
                      padding: const EdgeInsets.all(4.0),
                      child: GestureDetector(
                        onTap: () {
                          NotificationServices()
                              .declineEventNotification(notificationData);
                        },
                        child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  color: Colors.red[100],
                                ),
                                width: 36,
                                height: 36,
                              ),
                              Icon(
                                UniconsLine.x,
                                color: Colors.red,
                                size: 24,
                              ),
                            ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 4.0, bottom: 4, left: 4, right: 8),
                      child: GestureDetector(
                        onTap: () {
                          NotificationServices()
                              .acceptIndividualNotification(notificationData);
                        },
                        child: Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                color: Colors.green[100],
                              ),
                              width: 36,
                              height: 36,
                            ),
                            Icon(
                              UniconsLine.check,
                              color: Colors.green,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
              child: Row(
                children: [
                  Icon(
                    UniconsLine.info,
                    size: 13.0,
                  ),
                  SizedBox(width: 4),
                  Text(
                    "individual event join request",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TeamJoinRequestNotificationCard extends StatelessWidget {
  const TeamJoinRequestNotificationCard({
    Key key,
    @required this.notificationData,
  }) : super(key: key);

  final TeamNotification notificationData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Card(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
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
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            child: Image(
                              height: 48,
                              width: 48,
                              fit: BoxFit.fitWidth,
                              image: NetworkImage(
                                notificationData.senderPic,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notificationData.senderName,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "wants you to join",
                            style: TextStyle(
                              color: Theme.of(context)
                                  .backgroundColor
                                  .withOpacity(0.45),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            notificationData.teamName,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: GestureDetector(
                        onTap: () {
                          NotificationServices()
                              .declineTeamInviteNotification(notificationData);
                        },
                        child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  color: Colors.red[100],
                                ),
                                width: 36,
                                height: 36,
                              ),
                              Icon(
                                UniconsLine.x,
                                color: Colors.red,
                                size: 24,
                              ),
                            ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 4.0, bottom: 4, left: 4, right: 8),
                      child: GestureDetector(
                        onTap: () {
                          NotificationServices()
                              .acceptTeamInviteNotification(notificationData);
                        },
                        child: Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                color: Colors.green[100],
                              ),
                              width: 36,
                              height: 36,
                            ),
                            Icon(
                              UniconsLine.check,
                              color: Colors.green,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
              child: Row(
                children: [
                  Icon(
                    UniconsLine.info,
                    size: 13.0,
                  ),
                  SizedBox(width: 4),
                  Text(
                    "team join request",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChallengeNotificationCard extends StatelessWidget {
  const ChallengeNotificationCard({
    Key key,
    @required this.notificationData,
  }) : super(key: key);

  final ChallengeNotification notificationData;

  @override
  Widget build(BuildContext context) {
    String sportIcon;
    switch (notificationData.sport) {
      case "Volleyball":
        sportIcon = "assets/icons8-volleyball-96.png";
        break;
      case "Basketball":
        sportIcon = "assets/icons8-basketball-96.png";
        break;
      case "Cricket":
        sportIcon = "assets/icons8-cricket-96.png";
        break;
      case "Football":
        sportIcon = "assets/icons8-soccer-ball-96.png";
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Card(
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.6,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            child: Image(
                              height: 48,
                              width: 48,
                              fit: BoxFit.fitWidth,
                              image: AssetImage(sportIcon),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: Center(
                              child: Text(
                                notificationData.opponentTeamName,
                                overflow: TextOverflow.fade,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "VS",
                            style: TextStyle(
                              color: Theme.of(context)
                                  .backgroundColor
                                  .withOpacity(0.45),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: Center(
                              child: Text(
                                notificationData.myTeamName,
                                overflow: TextOverflow.fade,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: GestureDetector(
                        onTap: () {
                          NotificationServices().declineNotification(
                              notificationData.notificationId);
                        },
                        child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  color: Colors.red[100],
                                ),
                                width: 36,
                                height: 36,
                              ),
                              Icon(
                                UniconsLine.x,
                                color: Colors.red,
                                size: 24,
                              ),
                            ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 4.0, bottom: 4, left: 4, right: 8),
                      child: GestureDetector(
                        onTap: () {
                          NotificationServices()
                              .acceptChallengeTeamNotification(
                                  notificationData);
                        },
                        child: Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                color: Colors.green[100],
                              ),
                              width: 36,
                              height: 36,
                            ),
                            Icon(
                              UniconsLine.check,
                              color: Colors.green,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
              child: Row(
                children: [
                  Icon(
                    UniconsLine.info,
                    size: 13.0,
                  ),
                  SizedBox(width: 4),
                  Text(
                    notificationData.type,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
