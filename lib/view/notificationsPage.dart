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
                  //TODO: Challenge notification Card
                  return ChallengeNotificationCard(
                      notificationData: notificationData);
                } else if (notificationData.type == 'inviteTeams') {
                  TeamNotification notificationData =
                      new TeamNotification.fromJson(
                          asyncSnapshot.data.documents[index]);
                  //TODO: Invite Team Notification Card
                  return TeamNotificationCard(
                      notificationData: notificationData);
                } else if (notificationData.type == 'event') {
                  EventNotification notificationData =
                      new EventNotification.fromJson(
                          asyncSnapshot.data.documents[index]);
                  if (notificationData.subtype == 'individual') {
                    //TODO: Individual Event Notification Card
                    return IndividualEventNotificationCard(
                        notificationData: notificationData);
                  } else {
                    //TODO: Team Event Notification Card
                    return TeamEventNotificationCard(
                        notificationData: notificationData);
                  }
                }
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
          child: Row(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notificationData.senderName,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "friend request",
                        style: TextStyle(
                          fontSize: 12,
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
                              Feather.x,
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
                            Feather.check,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      "https://images.vexels.com/media/users/3/180359/isolated/preview/d4db35c3bd47285887403268f0db298a-go-team-badge-by-vexels.png",
                    ),
                  ),
                ),
              ),
            ),
            Text(notificationData.teamName +
                "\nwants to join\n" +
                notificationData.eventName),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: GestureDetector(
                    onTap: () {
                      NotificationServices()
                          .declineNotification(notificationData.notificationId);
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
                            Feather.x,
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
                          Feather.check,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      // notificationData.senderId,
                      "https://avatars0.githubusercontent.com/u/55529269?s=460&u=f6804866eacc30ccb04f1a6db11c20a292732cd6&v=4",
                    ),
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Text(notificationData.senderName +
                    "\nwants to join\n" +
                    notificationData.eventName),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: GestureDetector(
                    onTap: () {
                      // NotificationServices()
                      //     .declineNotification(
                      //         notificationData.notificationId);
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
                            Feather.x,
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
                      // NotificationServices()
                      //     .acceptTeamEventNotification(
                      //         notificationData);
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
                          Feather.check,
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
      ),
    );
  }
}

class TeamNotificationCard extends StatelessWidget {
  const TeamNotificationCard({
    Key key,
    @required this.notificationData,
  }) : super(key: key);

  final TeamNotification notificationData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      // notificationData.senderId,
                      "https://avatars0.githubusercontent.com/u/55529269?s=460&u=f6804866eacc30ccb04f1a6db11c20a292732cd6&v=4",
                    ),
                  ),
                ),
              ),
            ),
            Text(notificationData.senderName +
                "\nsent request to join\n" +
                notificationData.teamName),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: GestureDetector(
                    onTap: () {
                      // NotificationServices()
                      //     .declineNotification(
                      //         notificationData.notificationId);
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
                            Feather.x,
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
                      // NotificationServices()
                      //     .acceptTeamEventNotification(
                      //         notificationData);
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
                          Feather.check,
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      // notificationData.senderId,
                      "https://avatars0.githubusercontent.com/u/55529269?s=460&u=f6804866eacc30ccb04f1a6db11c20a292732cd6&v=4",
                    ),
                  ),
                ),
              ),
            ),
            Text(notificationData.myTeamName),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: GestureDetector(
                    onTap: () {
                      // NotificationServices()
                      //     .declineNotification(
                      //         notificationData.notificationId);
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
                            Feather.x,
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
                      // NotificationServices()
                      //     .acceptTeamEventNotification(
                      //         notificationData);
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
                          Feather.check,
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
      ),
    );
  }
}
