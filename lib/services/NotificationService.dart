import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Runbhumi/models/Notification.dart';

class FriendRequest {
  // dont forget to await this function while calling
  Future addFriendReq(String senderId, String recieverId) async {
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
}
