// import 'package:cloud_firestore/cloud_firestore.dart';

// class Notification {
//   String senderId;
//   String senderName;
//   String senderProfieImage;
//   String notificationId;
//   String requestType;
//   /*
//   types of request
//   1.Friend Req => Friend
//   2.
//   3.
//   */

//   /*
//   bool accepted; // false
//   bool rejected; // false

//   Logic (initialized as pending in the constructor)
//   If accepted=false && rejected=false => request pending
//   If accepted=true  && rejected=false => request accepted
//   If accepted=false && rejected=false => request rejected
//   */

//   bool status;

//   Notification.createNewRequest(
//       String nortificationId, String type, String senderId, String recieverId) {
//     this.notificationId = nortificationId;
//     this.senderId = senderId;
//     this.requestType = requestType;
//     this.recieverId = recieverId;
//     this.status = false;
//   }

//   Map<String, dynamic> toJson() => {
//         'senderId': senderId,
//         'recieverId': recieverId,
//         'requestType': requestType,
//         'notificationId': notificationId,
//         'status': status
//       };

//   Notification.fromSnapshot(DocumentSnapshot snapshot)
//       : senderId = snapshot.data()['senderId'],
//         recieverId = snapshot.data()['recieverId'],
//         requestType = snapshot.data()['requestType'],
//         notificationId = snapshot.data()['notificationId'],
//         status = snapshot.data()['status'];
// }
// ----------------------------------------------------------------------------------
// Invite teams Is used To invite a player to a team
//
// ------------------------------------------------------------------------------------

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:runbhumi/models/models.dart';
import 'package:get_storage/get_storage.dart';

class NotificationClass {
  String? senderId;
  String? senderName;
  String? senderProfieImage;
  String? notificationId;
  String? type;

  NotificationClass.createNewRequest(String type, String nortificationId,
      String senderId, String senderName, String senderProfileImage) {
    this.notificationId = nortificationId;
    this.senderId = senderId;
    this.senderName = senderName;
    this.senderProfieImage = senderProfileImage;
    this.type = type;
  }

  Map<String, dynamic> toJson() => {
        'notificationId': notificationId,
        'senderId': senderId,
        'name': senderName,
        'profileImage': senderProfieImage,
        'type': type
      };

  NotificationClass({
    this.notificationId,
    this.senderId,
    this.senderName,
    this.senderProfieImage,
    this.type,
  });

  factory NotificationClass.fromJson(QueryDocumentSnapshot data) {
    var parsedJson = data.data();
    return NotificationClass(
        notificationId: (parsedJson as Map)['notificationId'],
        senderId: parsedJson['senderId'],
        senderName: parsedJson['name'],
        senderProfieImage: parsedJson['profileImage'],
        type: parsedJson['type']);
  }
}

class TeamNotification {
  String? notificationId;
  String? teamId;
  String? senderId;
  String? senderName;
  String? senderPic;
  String? type;
  String? teamName;
  String? teamSport;

  TeamNotification(
      {this.notificationId,
      this.teamId,
      this.senderId,
      this.senderName,
      this.senderPic,
      this.type,
      this.teamName,
      this.teamSport});
  TeamNotification.newNotification(
      String notificationId, String teamId, String teamName, String teamSport) {
    this.notificationId = notificationId;
    this.senderId = GetStorage().read('userId');
    this.senderName = GetStorage().read('name');
    this.senderPic = GetStorage().read('profileImage');
    this.type = "inviteTeams";
    this.teamId = teamId;
    this.teamName = teamName;
    this.teamSport = teamSport;
  }

  Map<String, dynamic> toJson() => {
        'notificationId': this.notificationId,
        'senderId': this.senderId,
        'senderName': this.senderName,
        'senderPic': this.senderPic,
        'teamName': this.teamName,
        'teamId': this.teamId,
        'teamSport': this.teamSport,
        'type': this.type
      };

  factory TeamNotification.fromJson(QueryDocumentSnapshot data) {
    var parsedJson = data.data();
    return TeamNotification(
        notificationId: (parsedJson as Map)['notificationId'],
        teamId: parsedJson['teamId'],
        senderId: parsedJson['senderId'],
        senderName: parsedJson['senderName'],
        senderPic: parsedJson['senderPic'],
        type: parsedJson['type'],
        teamName: parsedJson['teamName'],
        teamSport: parsedJson['teamSport']);
  }
}

class ChallengeNotification {
  String? notificationId;
  String? senderId;
  String? senderName;
  String? sport;
  String? opponentTeamName;
  String? myTeamName;
  String? type;
  String? myTeamId;
  String? opponentTeamId;

  ChallengeNotification.createNewRequest(
      String notificationId,
      String sport,
      TeamChallengeNotification myteam,
      TeamChallengeNotification opponentTeam) {
    this.notificationId = notificationId;
    this.senderId = GetStorage().read('userId')!;
    this.senderName = GetStorage().read('name')!;
    this.sport = sport;
    this.myTeamName = myteam.teamName!;
    this.opponentTeamName = opponentTeam.teamName!;
    this.myTeamId = myteam.teamId!;
    this.opponentTeamId = opponentTeam.teamId!;
    this.type = "challenge";
  }

  Map<String, dynamic> toJson() => {
        'notificationId': this.notificationId,
        'senderId': this.senderId,
        'name': this.senderName,
        'sport': this.sport,
        'myTeam': this.opponentTeamName,
        'opponentTeam': this.myTeamName,
        'type': this.type,
        'myTeamId': this.myTeamId,
        'opponentTeamId': this.opponentTeamId
      };

  ChallengeNotification({
    required this.notificationId,
    required this.senderId,
    required this.senderName,
    required this.sport,
    required this.myTeamName,
    required this.opponentTeamName,
    required this.type,
    required this.myTeamId,
    required this.opponentTeamId,
  });

  factory ChallengeNotification.fromJson(QueryDocumentSnapshot data) {
    var parsedJson = data.data();
    return ChallengeNotification(
        notificationId: (parsedJson as Map)['notificationId'],
        senderId: parsedJson['senderId'],
        senderName: parsedJson['name'],
        sport: parsedJson['sport'],
        myTeamName: parsedJson['myTeam'],
        opponentTeamName: parsedJson['opponentTeam'],
        type: parsedJson['type'],
        myTeamId: parsedJson['myTeamId'],
        opponentTeamId: parsedJson['opponentTeamId']);
  }
}

// there are two types of event notification one for team and other for the users

class EventNotification {
  String? notificationId;
  String? senderId;
  String? senderName;
  String? eventId;
  String? eventName;
  String? teamName;
  String? teamId;
  String? senderPic;
  String? type;
  String? subtype;

  //------------------ there are two types which are assigned ----------------
  // team - for teams reated private events
  // individual -for individual private events

  EventNotification.createIndividualNotification(
      String notificationId, String eventId, String eventName) {
    this.notificationId = notificationId;
    this.eventName = eventName;
    this.eventId = eventId;
    this.senderId = GetStorage().read('userId')!;
    this.senderName = GetStorage().read('name')!;
    this.senderPic = GetStorage().read('profileImage')!;
    this.type = 'event';
    this.subtype = 'individual';
  }

  EventNotification.createTeamsNotification(
    String? notificationId,
    String? eventId,
    String? eventName,
    String? teamId,
    String? teamName,
  ) {
    this.notificationId = notificationId!;
    this.eventId = eventId!;
    this.eventName = eventName!;
    this.senderId = GetStorage().read('userId')!;
    this.senderName = GetStorage().read('name')!;
    this.teamName = teamName!;
    this.teamId = teamId!;
    this.type = 'event';
    this.subtype = 'team';
  }

  Map<String, dynamic> toUserJson() => {
        'notificationId': this.notificationId,
        'senderId': this.senderId,
        'senderName': this.senderName,
        'eventId': this.eventId,
        'eventName': this.eventName,
        'senderPic': this.senderPic,
        'type': this.type,
        'subtype': this.subtype,
      };

  Map<String, dynamic> toTeamJson() => {
        'notificationId': this.notificationId,
        'senderId': this.senderId,
        'senderName': this.senderName,
        'eventId': this.eventId,
        'eventName': this.eventName,
        'type': this.type,
        'subtype': this.subtype,
        'teamName': this.teamName,
        'teamId': this.teamId
      };

  EventNotification.team({
    required this.notificationId,
    required this.senderId,
    required this.senderName,
    required this.eventId,
    required this.eventName,
    required this.teamId,
    required this.teamName,
    required this.subtype,
  });

  EventNotification.individual({
    required this.notificationId,
    required this.senderId,
    required this.senderName,
    required this.senderPic,
    required this.eventId,
    required this.eventName,
    required this.subtype,
  });

  factory EventNotification.fromJson(QueryDocumentSnapshot data) {
    var parsedJson = data.data();
    if ((parsedJson as Map)['subtype'] == 'individual')
      return EventNotification.individual(
          notificationId: parsedJson['notificationId'],
          senderId: parsedJson['senderId'],
          senderName: parsedJson['senderName'],
          senderPic: parsedJson['senderPic'],
          eventId: parsedJson['eventId'],
          eventName: parsedJson['eventName'],
          subtype: parsedJson['subtype']);

    return EventNotification.team(
        notificationId: parsedJson['notificationId'],
        senderId: parsedJson['senderId'],
        senderName: parsedJson['senderName'],
        eventId: parsedJson['eventId'],
        eventName: parsedJson['eventName'],
        teamId: parsedJson['teamId'],
        teamName: parsedJson['teamName'],
        subtype: parsedJson['subtype']);
  }
}
