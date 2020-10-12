import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  DateTime dateTime;
  String sentby;
  String message;

  Message({
    this.dateTime,
    this.sentby,
    this.message,
  });

  Message.newMessage(
    DateTime dateTime,
    String sentby,
    String message,
  ) {
    this.dateTime = dateTime;
    this.sentby = sentby;
    this.message = message;
  }

  Map<String, dynamic> toJson() =>
      {'dateTime': dateTime, 'sentby': sentby, 'message': message};
  Message.fromSnapshot(DocumentSnapshot snapshot)
      : dateTime = snapshot.data()['dateTime'],
        sentby = snapshot.data()['sentby'],
        message = snapshot.data()['message'];
}
