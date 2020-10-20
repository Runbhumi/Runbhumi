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

import 'package:cloud_firestore/cloud_firestore.dart';

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
