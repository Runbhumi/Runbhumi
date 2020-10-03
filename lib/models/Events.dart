import 'package:cloud_firestore/cloud_firestore.dart';

class Events {
  String eventId;
  String creatorId;
  String location;
  String sportName;
  String description;
  List<String> playersId;
  DateTime dateTime;

  Events(
      {this.eventId,
      this.creatorId,
      this.location,
      this.sportName,
      this.description,
      this.playersId,
      this.dateTime});

  Events.newEvent(
      String eventId,
      String creatorId,
      String location,
      String sportName,
      String description,
      List<String> playersId,
      DateTime dateTime) {
    this.eventId = eventId;
    this.creatorId = creatorId;
    this.location = location;
    this.sportName = sportName;
    this.description = description;
    this.playersId = playersId;
    this.dateTime = dateTime;
  }

  Map<String, dynamic> toJson() => {
        'eventId': eventId,
        'creatorId': creatorId,
        'location': location,
        'sportName': sportName,
        'description': description,
        'playersId': playersId,
        'dateTime': dateTime
      };
  Events.fromSnapshot(DocumentSnapshot snapshot)
      : eventId = snapshot.data()['eventId'],
        creatorId = snapshot.data()['creatorId'],
        location = snapshot.data()['location'],
        sportName = snapshot.data()['sportName'],
        description = snapshot.data()['desscription'],
        playersId = snapshot.data()['playerId'],
        dateTime = snapshot.data()['dateTime'].toDate();
}
