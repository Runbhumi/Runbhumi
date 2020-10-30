import 'package:cloud_firestore/cloud_firestore.dart';

class Events {
  String eventName;
  String eventId;
  String creatorId;
  String location;
  String sportName;
  String description;
  List<dynamic> playersId;
  DateTime dateTime;
  int maxMembers;

  Events(
      {this.eventId,
      this.eventName,
      this.creatorId,
      this.location,
      this.sportName,
      this.description,
      this.playersId,
      this.dateTime,
      this.maxMembers});

  Events.newEvent(
      String eventId,
      String eventName,
      String creatorId,
      String location,
      String sportName,
      String description,
      DateTime dateTime,
      int maxMembers) {
    this.eventId = eventId;
    this.eventName = eventName;
    this.creatorId = creatorId;
    this.location = location;
    this.sportName = sportName;
    this.playersId = [creatorId];
    this.description = description;
    this.dateTime = dateTime;
    this.maxMembers = maxMembers;
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
        'playersId': playersId,
        'dateTime': dateTime,
        'max': maxMembers
      };
  factory Events.fromJson(QueryDocumentSnapshot snapshot) {
    var data = snapshot.data();
    return Events(
        eventId: data['eventId'],
        eventName: data['eventName'],
        creatorId: data['creatorId'],
        location: data['location'],
        sportName: data['sportName'],
        description: data['description'],
        playersId: data['playersId'],
        dateTime: data['dateTime'].toDate(),
        maxMembers: data['max']);
  }
}
