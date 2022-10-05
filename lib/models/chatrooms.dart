import 'package:cloud_firestore/cloud_firestore.dart';

class Chatrooms {
  List<String> playersId;
  List<String> teamsId;
  List<String> captainsId;
  DateTime dateTime;
  String sentby;
  String message;
  String type;

  Chatrooms({
    required this.playersId,
    required this.teamsId,
    required this.captainsId,
    required this.dateTime,
    required this.sentby,
    required this.message,
    required this.type,
  });

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
      : playersId = (snapshot.data() as Map)['playersId'],
        teamsId = (snapshot.data() as Map)['teamsId'],
        captainsId = (snapshot.data() as Map)['captainsId'],
        dateTime = (snapshot.data() as Map)['dateTime'],
        sentby = (snapshot.data() as Map)['sentby'],
        message = (snapshot.data() as Map)['message'],
        type = (snapshot.data() as Map)['type'];
}
