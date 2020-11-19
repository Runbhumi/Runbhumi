import 'package:Runbhumi/models/models.dart';

import 'package:Runbhumi/services/FriendsServices.dart';
import 'package:Runbhumi/utils/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendRequestServices {
  final String _id = Constants.prefs.getString('userId');
  final String _name = Constants.prefs.getString('name');
  final String _profileImage = Constants.prefs.getString('profileImage');

  createRequest(String uid) async {
    var db = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('notification');
    var doc = db.doc();
    String id = doc.id;
    doc.set(NotificationClass.createNewRequest(
            "friend", id, _id, _name, _profileImage)
        .toJson());
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
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
    return FirebaseFirestore.instance
        .collection("users")
        .doc(_id)
        .collection('notification')
        .snapshots();
  }
}
