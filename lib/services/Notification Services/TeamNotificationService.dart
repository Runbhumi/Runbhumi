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

import 'package:Runbhumi/utils/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeamsNotification {
  final String _id = Constants.prefs.getString('userId');
  final String _name = Constants.prefs.getString('name');
  final String _profileImage = Constants.prefs.getString('profileImage');

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
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_id)
        .collection('notification')
        .doc(teams.notificationId)
        .delete();
    await FirebaseFirestore.instance
        .collection('teams')
        .doc(teams.teamId)
        .update({
      'notificationPlayers': FieldValue.arrayUnion([_id])
    });
  }
}
