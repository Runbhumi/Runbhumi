import 'package:Runbhumi/models/models.dart';
import 'package:Runbhumi/services/services.dart';

import 'package:Runbhumi/services/friendsServices.dart';
import 'package:Runbhumi/utils/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationServices {
  final String _id = Constants.prefs.getString('userId');
  final String _name = Constants.prefs.getString('name');
  final String _profileImage = Constants.prefs.getString('profileImage');

  createRequest(String uid) {
    var db = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('notification');
    var doc = db.doc();
    String id = doc.id;
    doc.set(NotificationClass.createNewRequest(
            "friend", id, _id, _name, _profileImage)
        .toJson());
    FirebaseFirestore.instance.collection('users').doc(uid).update({
      'notification': FieldValue.arrayUnion([_id])
    });
  }

  declineRequest(String id, String uid) {
    var db = FirebaseFirestore.instance
        .collection('users')
        .doc(_id)
        .collection('notification');
    FirebaseFirestore.instance.collection('users').doc(_id).update({
      'notification': FieldValue.arrayRemove([uid])
    });
    db.doc(id).delete();
  }

  acceptFriendRequest(NotificationClass data) {
    // String notificationID, String id, String name, String profileImage) {
    var db = FirebaseFirestore.instance.collection('users');
    db.doc(_id).collection('friends').doc(data.senderId).set(Friends.newFriend(
            data.senderId, data.senderName, data.senderProfieImage)
        .toJson());

    db
        .doc(data.senderId)
        .collection('friends')
        .doc(_id)
        .set(Friends.newFriend(_id, _name, _profileImage).toJson());
    declineRequest(data.notificationId, data.senderId);

    FriendServices().addUpdateMyFriendCount(1, data.senderId, _id);
    FriendServices().addUpdateMyFriendCount(1, _id, data.senderId);
  }

  getNotification() async {
    print(_id);
    return FirebaseFirestore.instance
        .collection("users")
        .doc(_id)
        .collection('notification')
        .snapshots();
  }

  createIndividualNotification(Events event) async {
    var db = FirebaseFirestore.instance
        .collection('users')
        .doc(event.creatorId)
        .collection('notification');

    var doc = db.doc();
    String id = doc.id;
    final EventNotification eventNotification =
        new EventNotification.createIndividualNotification(
            id, event.eventId, event.eventName);
    doc.set(eventNotification.toUserJson());
    await FirebaseFirestore.instance
        .collection('events')
        .doc(event.eventId)
        .update({
      'notificationPlayers': FieldValue.arrayUnion([_id])
    });
  }

  Future<Events> checkPlayerCount(String notificationId) async {
    var snap = await FirebaseFirestore.instance
        .collection('events')
        .doc(notificationId)
        .get();
    Map<String, dynamic> map = snap.data();
    Events event = Events.fromMap(map);
    return event;
  }

  acceptIndividualNotification(EventNotification notification) async {
    Events event = await checkPlayerCount(notification.eventId);
    Friends friend = new Friends.newFriend(
        notification.senderId, notification.senderName, notification.senderPic);
    if (event.playersId.length < event.maxMembers) {
      await FirebaseFirestore.instance
          .collection('events')
          .doc(notification.eventId)
          .update({
        'playersId': FieldValue.arrayUnion([notification.senderId]),
        'notificationPlayers': FieldValue.arrayRemove([notification.senderId]),
        'playerInfo': FieldValue.arrayUnion([friend.toJson()])
      });
      await addScheduleToUser(
          notification.senderId,
          event.eventName,
          event.sportName,
          event.location,
          event.dateTime,
          event.creatorId,
          event.creatorName,
          event.eventId,
          event.status,
          event.type,
          event.playersId,
          event.paid);

      await declineNotification(notification.notificationId);
      return true;
    }

    return false;
  }

  declineEventNotification(EventNotification notificationData) async {
    declineNotification(notificationData.notificationId);
    await FirebaseFirestore.instance
        .collection('events')
        .doc(notificationData.eventId)
        .update({
      'notificationPlayers': FieldValue.arrayRemove([notificationData.senderId])
    });
  }

  teamEventNotification(Events event, TeamView teamView) async {
    var db = FirebaseFirestore.instance
        .collection('users')
        .doc(event.creatorId)
        .collection('notification');

    var doc = db.doc();
    String id = doc.id;
    final EventNotification eventNotification =
        new EventNotification.createTeamsNotification(id, event.eventId,
            event.eventName, teamView.teamId, teamView.teamName);
    doc.set(eventNotification.toTeamJson());
    await FirebaseFirestore.instance
        .collection('events')
        .doc(event.eventId)
        .update({
      'notificationPlayers': FieldValue.arrayUnion([_id])
    });
  }

  createTeamNotification(String from, String to, Teams teamView) async {
    var db = FirebaseFirestore.instance
        .collection('users')
        .doc(to)
        .collection('notification');
    var doc = db.doc();
    String id = doc.id;
    doc.set(TeamNotification.newNotification(
            id, teamView.teamId, teamView.teamName, teamView.sport)
        .toJson());
    await FirebaseFirestore.instance
        .collection('teams')
        .doc(teamView.teamId)
        .update({
      'notificationPlayers': FieldValue.arrayUnion([from])
    });
  }

  acceptTeamInviteNotification(TeamNotification team) async {
    //final Friends user = Friends.newFriend(_id, _name, _profileImage);
    // print(team.teamId);
    // print(team.senderId);
    final Friends user = Friends.newFriend(_id, _name, _profileImage);
    await FirebaseFirestore.instance.collection('users').doc(_id).update({
      'teams': FieldValue.arrayUnion([team.teamId])
    });
    await FirebaseFirestore.instance
        .collection('teams')
        .doc(team.teamId)
        .update({
      'players': FieldValue.arrayUnion([user.toJson()]),
      'playerId': FieldValue.arrayUnion([user.friendId]),
      'notificationPlayers': FieldValue.arrayRemove([user.friendId]),
    });
    CustomMessageServices().sendTeamNewMemberJoinMessage(team.teamId, _name);
    declineTeamInviteNotification(team);
  }

  declineTeamInviteNotification(TeamNotification teams) async {
    declineNotification(teams.notificationId);
    await FirebaseFirestore.instance
        .collection('teams')
        .doc(teams.teamId)
        .update({
      'notificationPlayers': FieldValue.arrayRemove([teams.senderId])
    });
  }

  challengeTeamNotification(
      String sport,
      TeamChallengeNotification teamViewOpponent,
      TeamChallengeNotification teamViewMe) async {
    var db = FirebaseFirestore.instance
        .collection('users')
        .doc(teamViewOpponent.manager)
        .collection('notification');

    var doc = db.doc();
    String id = doc.id;
    final ChallengeNotification challenge =
        new ChallengeNotification.createNewRequest(
            id, sport, teamViewOpponent, teamViewMe);

    doc.set(challenge.toJson());
  }

  Future<bool> acceptTeamEventNotification(
      EventNotification notification) async {
    Events event = await checkPlayerCount(notification.eventId);
    if (event.playersId.length < event.maxMembers) {
      await FirebaseFirestore.instance
          .collection('events')
          .doc(notification.eventId)
          .update({
        'playersId': FieldValue.arrayUnion([notification.senderId]),
        'teamsId': FieldValue.arrayUnion([notification.teamId]),
        'notificationPlayers': FieldValue.arrayRemove([notification.senderId]),
        'teamInfo': FieldValue.arrayUnion([
          {'teamName': notification.teamName, 'teamId': notification.teamId}
        ])
      });
      await addScheduleToUser(
          notification.senderId,
          event.eventName,
          event.sportName,
          event.location,
          event.dateTime,
          event.creatorId,
          event.creatorName,
          event.eventId,
          event.status,
          event.type,
          event.playersId,
          event.paid);
      await declineTeamRequest(notification.eventId,
          notification.notificationId, notification.senderId);
      await CustomMessageServices().sendEventAcceptEventChatCustomMessage(
          notification.eventId, notification.teamName);
      await CustomMessageServices().sendEventAcceptTeamChatCustomMessage(
          notification.teamId, notification.senderName, notification.eventName);
      return true;
    }
    return false;
  }

  acceptChallengeTeamNotification(
      ChallengeNotification notificationData) async {
    String nameOftheEvent = notificationData.myTeamName +
        ' Vs ' +
        notificationData.opponentTeamName;
    print('I am here yo');
    String eventId = createNewEvent(
        nameOftheEvent,
        notificationData.senderId,
        notificationData.senderName,
        "Challenge",
        notificationData.sport,
        "Challenge",
        [_id],
        DateTime.now(),
        2,
        "private",
        3,
        true,
        false,
        'free');
    EventService().addGivenUsertoEvent(eventId, notificationData.senderId);
    CustomMessageServices().sendChallegeFirstRoomMessage(eventId);
    // here a chatroom logic can be written
    declineNotification(notificationData.notificationId);
  }

  // getTeamInfo(String teamId) async {
  //   await FirebaseFirestore.instance
  //       .collection('teams')
  //       .doc(teamId)
  //       .snapshots()
  //       .listen((event) {
  //     return event.data();
  //   });
  // }

  declineNotification(String notificationId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_id)
        .collection('notification')
        .doc(notificationId)
        .delete();
  }

  declineTeamRequest(String eventId, String id, String uid) {
    var db = FirebaseFirestore.instance
        .collection('users')
        .doc(_id)
        .collection('notification');
    FirebaseFirestore.instance.collection('events').doc(eventId).update({
      'notificationPlayers': FieldValue.arrayRemove([uid])
    });
    db.doc(id).delete();
  }
}
