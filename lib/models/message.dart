import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  DateTime dateTime;
  String sentby;
  String message;
  // List<dynamic> reaction;

  Message({
    this.dateTime,
    this.sentby,
    this.message,
  }); //this.reaction});

  Message.newMessage(
    DateTime dateTime,
    String sentby,
    String message,
  ) {
    this.dateTime = dateTime;
    this.sentby = sentby;
    this.message = message;
    // this.reaction = [0, 0, 0, 0, 0];
  }

  Map<String, dynamic> toJson() => {
        'dateTime': dateTime,
        'sentby': sentby,
        'message': message,
        // 'reaction': reaction
      };

  // Message.fromSnapshot(DocumentSnapshot snapshot)
  //     : dateTime = snapshot.data()['dateTime'],
  //       sentby = snapshot.data()['sentby'],
  //       message = snapshot.data()['message'],
  //       reaction = snapshot.data()['reaction'];

  factory Message.fromJson(QueryDocumentSnapshot data) {
    var parsedJson = data.data();
    return Message(
        dateTime: parsedJson['dateTime'].toDate(),
        sentby: parsedJson['sentby'],
        message: parsedJson['message']);
    //    reaction: parsedJson['reaction']);
  }
}
