import 'package:cloud_firestore/cloud_firestore.dart';

class Chatrooms {
  List<String> playersId;
  List<String> teamsId;
  List<String> captainsId;
  DateTime dateTime;
  String sentby;
  String message;
  String type;

  Chatrooms(
      {this.playersId,
      this.teamsId,
      this.captainsId,
      this.dateTime,
      this.sentby,
      this.message,
      this.type});

  Map<String, dynamic> toJson() => {
        'playersId': playersId,
        'teamsId': teamsId,
        'captainsId': captainsId,
        'dateTime': dateTime,
        'sentby': sentby,
        'message': message,
        'type': type
      };
  Chatrooms.fromSnapshot(DocumentSnapshot snapshot)
      : playersId = snapshot.data()['playersId'],
        teamsId = snapshot.data()['teamsId'],
        captainsId = snapshot.data()['captainsId'],
        dateTime = snapshot.data()['dateTime'],
        sentby = snapshot.data()['sentby'],
        message = snapshot.data()['message'],
        type = snapshot.data()['type'];
}
