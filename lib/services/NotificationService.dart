import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Runbhumi/models/Notification.dart';

class FriendRequest {
  // this request will create a friend request

  Future<void> createFriendRequest(String senderId, String recieverId) async {
    try {
      DocumentReference docRef =
          FirebaseFirestore.instance.collection('notification').doc();
      String notificationId = docRef.id;
      FirebaseFirestore.instance.collection('notification').doc().set(
          Notification.createNewRequest(
                  docRef.id, "Friend", senderId, recieverId)
              .toJson());
      FirebaseFirestore.instance.collection('users').doc(senderId).update({
        "notificationId": FieldValue.arrayUnion([notificationId])
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // this will fetch the friend request with all the details

  Future getFriendRequest(String notificationId) async {
    try {
      var notificationData = await FirebaseFirestore.instance
          .collection('notification')
          .doc(notificationId)
          .get();
      return Notification.fromSnapshot(notificationData);
    } catch (e) {
      return e.message;
    }
  }

  // To add friends to databases

  Future<void> addFriends(String recieverId, String senderId) async {
    FirebaseFirestore.instance.collection("users").doc(recieverId).update({
      "notificationId": FieldValue.arrayUnion([senderId])
    });
    FirebaseFirestore.instance.collection("users").doc(senderId).update({
      "notificationId": FieldValue.arrayUnion([recieverId])
    });
  }

  //Logic For removing a friend

  Future<void> removeFriends(String recieverId, String senderId) async {
    FirebaseFirestore.instance.collection("users").doc(recieverId).update({
      "notificationId": FieldValue.arrayRemove([senderId])
    });
    FirebaseFirestore.instance.collection("users").doc(senderId).update({
      "notificationId": FieldValue.arrayRemove([recieverId])
    });
  }

  // Logic for accepting a friend request

  Future<void> acceptFriendRequest(String notificationId) async {
    try {
      FirebaseFirestore.instance
          .collection("notification")
          .doc(notificationId)
          .delete();
      FirebaseFirestore.instance
          .collection("users")
          .doc(notificationId)
          .update({
        "notificationId": FieldValue.arrayRemove([notificationId])
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // Logic for rejecting a friend Request

  Future<void> rejectFriendRequest(String notificationId) async {
    try {
      FirebaseFirestore.instance
          .collection("notification")
          .doc(notificationId)
          .delete();
      FirebaseFirestore.instance
          .collection("users")
          .doc(notificationId)
          .update({
        "notificationId": FieldValue.arrayRemove([notificationId])
      });
    } catch (e) {
      print(e.toString());
    }
  }

//Logic For removing a friend

  Future<void> removeFriend(String notificationId) async {
    try {} catch (e) {
      print(e.toString());
    }
  }
}
