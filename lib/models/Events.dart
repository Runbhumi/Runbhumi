import 'package:cloud_firestore/cloud_firestore.dart';

class Events {
  String eventName;
  String eventId;
  String creatorId;
  String location;
  String sportName;
  String description;
  DateTime dateTime;

  Events(
      {this.eventId,
      this.eventName,
      this.creatorId,
      this.location,
      this.sportName,
      this.description,
      this.dateTime});

  Events.newEvent(
      String eventId,
      String eventName,
      String creatorId,
      String location,
      String sportName,
      String description,
      DateTime dateTime) {
    this.eventId = eventId;
    this.eventName = eventName;
    this.creatorId = creatorId;
    this.location = location;
    this.sportName = sportName;
    this.description = description;
    this.dateTime = dateTime;
  }

  Events.miniView(String eventId, String eventName, String sportName,
      String location, DateTime dateTime) {
    this.eventId = eventId;
    this.eventName = eventName;
    this.location = location;
    this.dateTime = dateTime;
    this.sportName = sportName;
  }

  Map<String, dynamic> minitoJson() => {
        'eventId': eventId,
        'eventName': eventName,
        'location': location,
        'sportName': sportName,
        'dateTime': dateTime
      };

  Map<String, dynamic> toJson() => {
        'eventId': eventId,
        'eventName': eventName,
        'creatorId': creatorId,
        'location': location,
        'sportName': sportName,
        'description': description,
        'dateTime': dateTime
      };
  Events.fromSnapshot(DocumentSnapshot snapshot)
      : eventId = snapshot.data()['eventId'],
        eventName = snapshot.data()['eventName'],
        creatorId = snapshot.data()['creatorId'],
        location = snapshot.data()['location'],
        sportName = snapshot.data()['sportName'],
        description = snapshot.data()['desscription'],
        dateTime = snapshot.data()['dateTime'].toDate();
}
