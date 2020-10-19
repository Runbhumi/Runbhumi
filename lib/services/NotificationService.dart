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

import 'package:Runbhumi/models/Friends.dart';
import 'package:Runbhumi/models/Notification.dart';
import 'package:Runbhumi/services/UserServices.dart';
import 'package:Runbhumi/utils/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationServices {
  final String _id = Constants.prefs.getString('userId');
  final String _name = Constants.prefs.getString('name');
  final String _profileImage = Constants.prefs.getString('profileImage');

  createRequest(String friendId) {
    var db = FirebaseFirestore.instance
        .collection('users')
        .doc(friendId)
        .collection('notification');
    var doc = db.doc();
    String id = doc.id;
    doc.set(NotificationClass.createNewRequest(
            "friend", id, _id, _name, _profileImage)
        .toJson());
  }

  declineRequest(String id) {
    var db = FirebaseFirestore.instance
        .collection('users')
        .doc(_id)
        .collection('notification');
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
    declineRequest(data.notificationId);

    UserService().updateMyFriendCount();
    UserService().updateFriendCount(data.senderId);
  }

  getNotification() async {
    print(_id);
    return FirebaseFirestore.instance
        .collection("users")
        .doc(_id)
        .collection('notification')
        .snapshots();
  }
}
