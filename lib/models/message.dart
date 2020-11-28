import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  DateTime dateTime;
  String sentby;
  String message;
  String sentByName;
  String type;
  // List<dynamic> reaction;

  Message(
      {this.dateTime,
      this.sentby,
      this.message,
      this.sentByName,
      this.type}); //this.reaction});

  Message.newMessage(
    DateTime dateTime,
    String sentby,
    String message,
    String sentByName,
  ) {
    this.dateTime = dateTime;
    this.sentby = sentby;
    this.message = message;
    this.sentByName = sentByName;
    // this.reaction = [0, 0, 0, 0, 0];
  }

  Map<String, dynamic> toJson() => {
        'dateTime': dateTime,
        'sentby': sentby,
        'message': message,
        'sentByName': sentByName,
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
        message: parsedJson['message'],
        sentByName: parsedJson['sentByName'],
        type: parsedJson['type'] ?? "");
    //    reaction: parsedJson['reaction']);
  }
}
