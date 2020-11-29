// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:Runbhumi/models/Notification.dart';

// class FriendRequest {
//  this request will create a friend request

//   Future<void> createFriendRequest(String senderId, String recieverId) async {
//     try {
//       DocumentReference docRef =
//           FirebaseFirestore.instance.collection('notification').doc();
//       String notificationId = docRef.id;
//       FirebaseFirestore.instance.collection('notification').doc().set(
//           Notification.createNewRequest(
//                   docRef.id, "Friend", senderId, recieverId)
//               .toJson());
//       FirebaseFirestore.instance.collection('users').doc(senderId).update({
//         "notificationId": FieldValue.arrayUnion([notificationId])
//       });
//     } catch (e) {
//       print(e.toString());
//     }
//   }

//   // this will fetch the friend request with all the details

//   Future getFriendRequest(String notificationId) async {
//     try {
//       var notificationData = await FirebaseFirestore.instance
//           .collection('notification')
//           .doc(notificationId)
//           .get();
//       return Notification.fromSnapshot(notificationData);
//     } catch (e) {
//       return e.message;
//     }
//   }

//   // To add friends to databases

//   Future<void> addFriends(String recieverId, String senderId) async {
//     FirebaseFirestore.instance.collection("users").doc(recieverId).update({
//       "notificationId": FieldValue.arrayUnion([senderId])
//     });
//     FirebaseFirestore.instance.collection("users").doc(senderId).update({
//       "notificationId": FieldValue.arrayUnion([recieverId])
//     });
//   }

//   //Logic For removing a friend

//   Future<void> removeFriends(String recieverId, String senderId) async {
//     FirebaseFirestore.instance.collection("users").doc(recieverId).update({
//       "notificationId": FieldValue.arrayRemove([senderId])
//     });
//     FirebaseFirestore.instance.collection("users").doc(senderId).update({
//       "notificationId": FieldValue.arrayRemove([recieverId])
//     });
//   }

//   // Logic for accepting a friend request

//   Future<void> acceptFriendRequest(String notificationId) async {
//     try {
//       FirebaseFirestore.instance
//           .collection("notification")
//           .doc(notificationId)
//           .delete();
//       FirebaseFirestore.instance
//           .collection("users")
//           .doc(notificationId)
//           .update({
//         "notificationId": FieldValue.arrayRemove([notificationId])
//       });
//     } catch (e) {
//       print(e.toString());
//     }
//   }

//    Logic for rejecting a friend Request

//   Future<void> rejectFriendRequest(String notificationId) async {
//     try {
//       FirebaseFirestore.instance
//           .collection("notification")
//           .doc(notificationId)
//           .delete();
//       FirebaseFirestore.instance
//           .collection("users")
//           .doc(notificationId)
//           .update({
//         "notificationId": FieldValue.arrayRemove([notificationId])
//       });
//     } catch (e) {
//       print(e.toString());
//     }
//   }

// Logic For removing a friend

//   Future<void> removeFriend(String notificationId) async {
//     try {} catch (e) {
//       print(e.toString());
//     }
//   }
// }

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

    if (event.playersId.length < event.maxMembers) {
      await FirebaseFirestore.instance
          .collection('events')
          .doc(notification.eventId)
          .update({
        'playersId': FieldValue.arrayUnion([notification.senderId]),
        'notificationPlayers': FieldValue.arrayRemove([notification.senderId])
      });
      await addScheduleToUser(notification.senderId, event.eventName,
          event.sportName, event.location, event.dateTime);
      declineNotification(notification.notificationId);
      return true;
    }

    return false;
  }

  teamEventNotification(Events event, TeamView teamView) {
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
    final Friends user = Friends.newFriend(_id, _name, _profileImage);
    await FirebaseFirestore.instance.collection('users').doc(_id).update({
      'teams': FieldValue.arrayUnion([team.teamId])
    });
    await FirebaseFirestore.instance.collection('team').doc('team').update({
      'players': FieldValue.arrayUnion([user.toJson()]),
      'playerId': FieldValue.arrayUnion([user.friendId])
    });
    declineTeamInviteNotification(team);
  }

  declineTeamInviteNotification(TeamNotification teams) async {
    declineNotification(teams.notificationId);
    await FirebaseFirestore.instance
        .collection('teams')
        .doc(teams.teamId)
        .update({
      'notificationPlayers': FieldValue.arrayUnion([_id])
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

  acceptTeamEventNotification(EventNotification notification) async {
    await FirebaseFirestore.instance
        .collection('events')
        .doc(notification.eventId)
        .update({
      'playersId': FieldValue.arrayUnion([notification.senderId]),
      'teamsId': FieldValue.arrayUnion([notification.teamId])
    });
    declineNotification(notification.notificationId);
    await FirebaseFirestore.instance
        .collection('teams')
        .doc(notification.teamId)
        .collection('chats')
        .doc()
        .set({
      'message':
          "${notification.senderName} has registered you for ${notification.eventName}",
      'type': 'custom',
      'dateTime': DateTime.now(),
    });
  }

  acceptChallengeTeamNotification(String notificationId) {
    // here a chatroom logic can be written
    declineNotification(notificationId);
  }

  declineNotification(String notificationId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_id)
        .collection('notification')
        .doc(notificationId)
        .delete();
  }
}
