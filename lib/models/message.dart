import 'package:cloud_firestore/cloud_firestore.dart';

//Start of the Meassage class
class Message {
  //Date and time of the message being sent
  DateTime dateTime;
  //Id of the user who sent the message
  String sentby;
  //What the message consists of
  String message;
  //Name of the user who sent the message
  String sentByName;
  //type of message, used to differentiate custom messages
  String type;

  //Constructor of the message class
  Message(
      {this.dateTime,
      this.sentby,
      this.message,
      this.sentByName,
      this.type}); //this.reaction});
  //Method for creating a new message and assigning values to the class variables
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

  //Converting the information to a Map to save it in the database
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

  // takes a query snapshot as a input and returns a the Message class
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
  //End of the Message class
}
