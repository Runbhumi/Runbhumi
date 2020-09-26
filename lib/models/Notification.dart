import 'package:cloud_firestore/cloud_firestore.dart';

class Notification {
  String senderId;
  String recieverId;
  String notificationId;
  String requestType;
  /*
  types of request
  1.Friend Req => Friend
  2.
  3.
  */
  bool accepted; // false
  bool rejected; // false

  /*
  Logic (initialized as pending in the constructor)
  If accepted=false && rejected=false => request pending
  If accepted=true  && rejected=false => request accepted
  If accepted=false && rejected=false => request rejected
  */

  Notification.createNewRequest(
      String nortificationId, String type, String senderId, String recieverId) {
    this.notificationId = nortificationId;
    this.senderId = senderId;
    this.requestType = requestType;
    this.recieverId = recieverId;
    this.accepted = false;
    this.rejected = false;
  }

  Map<String, dynamic> toJson() => {
        'senderId': senderId,
        'recieverId': recieverId,
        'accepted': accepted,
        'rejected': rejected,
        'requestType': requestType,
        'notificationId': notificationId,
      };

  Notification.fromSnapshot(DocumentSnapshot snapshot)
      : senderId = snapshot.data()['senderId'],
        recieverId = snapshot.data()['recieverId'],
        accepted = snapshot.data()['accepted'],
        rejected = snapshot.data()['rejected'],
        requestType = snapshot.data()['requestType'],
        notificationId = snapshot.data()['notificationId'];
}
