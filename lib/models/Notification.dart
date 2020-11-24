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

import 'package:Runbhumi/utils/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Runbhumi/models/models.dart';

class NotificationClass {
  String senderId;
  String senderName;
  String senderProfieImage;
  String notificationId;
  String type;

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

  NotificationClass(
      {this.notificationId,
      this.senderId,
      this.senderName,
      this.senderProfieImage,
      this.type});

  factory NotificationClass.fromJson(QueryDocumentSnapshot data) {
    var parsedJson = data.data();
    return NotificationClass(
        notificationId: parsedJson['notificationId'],
        senderId: parsedJson['senderId'],
        senderName: parsedJson['name'],
        senderProfieImage: parsedJson['profileImage'],
        type: parsedJson['type']);
  }
}

class TeamNotification {
  String notificationId;
  String teamId;
  String senderId;
  String senderName;
  String type;
  String teamName;
  String teamSport;

  TeamNotification.newNotification(
      String notificationId, String teamId, String teamName, String teamSport) {
    this.notificationId = notificationId;
    this.senderId = Constants.prefs.getString('userId');
    this.senderName = Constants.prefs.getString('name');
    this.type = "inviteTeams";
    this.teamId = teamId;
    this.teamName = teamName;
    this.teamSport = teamSport;
  }

  Map<String, dynamic> toJson() => {
        'notificationId': this.notificationId,
        'senderId': this.senderId,
        'name': this.senderName,
        'teamName': this.teamName,
        'teamId': this.teamId,
        'teamSport': this.teamSport,
        'type': this.type
      };
}

class ChallengeNotification {
  String notificationId;
  String senderId;
  String senderName;
  String sport;
  String opponentTeamName;
  String myTeamName;
  String type;

  ChallengeNotification.createNewRequest(
      String notificationId,
      TeamChallengeNotification myteam,
      TeamChallengeNotification opponentTeam) {
    this.notificationId = notificationId;
    this.senderId = Constants.prefs.getString('userId');
    this.senderName = Constants.prefs.getString('name');
    this.sport = sport;
    this.myTeamName = myteam.teamName;
    this.opponentTeamName = opponentTeam.teamName;
    this.type = "challenge";
  }

  Map<String, dynamic> toJson() => {
        'notificationId': this.notificationId,
        'senderId': this.senderId,
        'name': this.senderName,
        'sport': this.sport,
        'myTeam': this.opponentTeamName,
        'opponentTeam': this.myTeamName,
        'type': type
      };

  ChallengeNotification(
      {this.notificationId,
      this.senderId,
      this.senderName,
      this.sport,
      this.myTeamName,
      this.opponentTeamName,
      this.type});

  factory ChallengeNotification.fromJson(QueryDocumentSnapshot data) {
    var parsedJson = data.data();
    return ChallengeNotification(
        notificationId: parsedJson['notificationId'],
        senderId: parsedJson['senderId'],
        senderName: parsedJson['name'],
        sport: parsedJson['sport'],
        myTeamName: parsedJson['myTeam'],
        opponentTeamName: parsedJson['opponentTeam'],
        type: parsedJson['type']);
  }
}
