import 'package:Runbhumi/utils/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Events {
  final String creator = Constants.prefs.getString('userId');

  String eventName;
  String eventId;
  String creatorId;
  String location;
  String sportName;
  String description;
  List<dynamic> playersId;
  List notification;
  DateTime dateTime;
  int maxMembers;
  String status;
  int type;

  Events(
      {this.eventId,
      this.eventName,
      this.creatorId,
      this.location,
      this.sportName,
      this.description,
      this.playersId,
      this.dateTime,
      this.maxMembers,
      this.status,
      this.notification,
      this.type});

  Events.newEvent(
      String eventId,
      String eventName,
      String location,
      String sportName,
      String description,
      DateTime dateTime,
      int maxMembers,
      String status,
      int type) {
    this.eventId = eventId;
    this.eventName = eventName;
    this.creatorId = creator;
    this.location = location;
    this.sportName = sportName;
    this.playersId = [creator]; // here the teams id can be stored too
    this.description = description;
    this.dateTime = dateTime;
    this.maxMembers = maxMembers; // members can deonote the max number of teams
    this.type = type;
    this.status = status;
    this.notification = [];
  }

  Events.miniEvent(
      {this.eventId,
      this.eventName,
      this.location,
      this.dateTime,
      this.sportName});

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

  factory Events.fromMiniJson(QueryDocumentSnapshot snapshot) {
    var data = snapshot.data();
    return Events(
      eventId: data['eventId'],
      eventName: data['eventName'],
      creatorId: data['creatorId'],
      location: data['location'],
      sportName: data['sportName'],
      dateTime: data['dateTime'].toDate(),
    );
  }

  Map<String, dynamic> toJson() => {
        'eventId': this.eventId,
        'eventName': this.eventName,
        'creatorId': this.creatorId,
        'location': this.location,
        'sportName': this.sportName,
        'description': this.description,
        'playersId': this.playersId,
        'dateTime': this.dateTime,
        'max': this.maxMembers,
        'type': this.type,
        'status': this.status,
        'notificationPlayers': this.notification
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
        maxMembers: data['max'],
        type: data['type'],
        status: data['status'],
        notification: data['notificationPlayers']);
  }

  factory Events.fromMap(Map<String, dynamic> data) {
    return Events(
        eventId: data['eventId'],
        eventName: data['eventName'],
        creatorId: data['creatorId'],
        location: data['location'],
        sportName: data['sportName'],
        description: data['description'],
        playersId: data['playersId'],
        dateTime: data['dateTime'].toDate(),
        maxMembers: data['max'],
        type: data['type'],
        status: data['status'],
        notification: data['notificationPlayers']);
  }
}
