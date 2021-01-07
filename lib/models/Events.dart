import 'package:Runbhumi/utils/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Events {
  final String creator = Constants.prefs.getString('userId');
  final String creatorN = Constants.prefs.getString('name');

  String eventName;
  String eventId;
  String creatorId;
  String creatorName;
  String location;
  String sportName;
  String description;
  List<dynamic> playersId;
  List<dynamic> participants;
  List playerInfo;
  List<dynamic> teamId;
  List teamInfo;
  List notification;
  DateTime dateTime;
  int maxMembers;
  String status;
  int type;

  Events(
      {this.eventId,
      this.eventName,
      this.creatorId,
      this.creatorName,
      this.location,
      this.sportName,
      this.description,
      this.playersId,
      this.participants,
      this.playerInfo,
      this.teamInfo,
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
    this.creatorName = creatorN;
    this.location = location;
    this.sportName = sportName;
    this.playersId = [];
    this.description = description;
    this.dateTime = dateTime;
    this.maxMembers = maxMembers; // members can deonote the max number of teams
    this.type = type;
    this.participants = [creator];
    this.status = status;
    this.notification = [];
  }

  Events.miniEvent(
      {this.eventId,
      this.eventName,
      this.location,
      this.dateTime,
      this.sportName,
      this.creatorId,
      this.creatorName,
      this.type,
      this.playersId});

  Events.miniView(
      String eventId,
      String eventName,
      String sportName,
      String location,
      DateTime dateTime,
      String creatorId,
      String creatorName,
      int type,
      List<dynamic> playersId) {
    this.eventId = eventId;
    this.eventName = eventName;
    this.location = location;
    this.dateTime = dateTime;
    this.sportName = sportName;
    this.creatorId = creatorId;
    this.creatorName = creatorName;
    this.type = type;
    this.playersId = playersId;
  }

  Map<String, dynamic> minitoJson() => {
        'eventId': eventId,
        'eventName': eventName,
        'location': location,
        'sportName': sportName,
        'dateTime': dateTime,
        'creatorId': creatorId,
        'creatorName': creatorName,
        'type': type,
        'playersId': playersId,
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
      creatorName: data['creatorName'],
      type: data['type'],
      playersId: data['playersId'],
    );
  }
  Map<String, dynamic> toJson() => {
        'eventId': this.eventId,
        'eventName': this.eventName,
        'creatorId': this.creatorId,
        'creatorName': this.creatorName,
        'location': this.location,
        'sportName': this.sportName,
        'description': this.description,
        'playersId': this.playersId,
        'dateTime': this.dateTime,
        'max': this.maxMembers,
        'type': this.type,
        'status': this.status,
        'notificationPlayers': this.notification,
        'participants': this.participants
      };
  factory Events.fromJson(QueryDocumentSnapshot snapshot) {
    var data = snapshot.data();
    return Events(
        eventId: data['eventId'],
        eventName: data['eventName'],
        creatorId: data['creatorId'],
        creatorName: data['creatorName'],
        location: data['location'],
        sportName: data['sportName'],
        description: data['description'],
        playersId: data['playersId'],
        dateTime: data['dateTime'].toDate(),
        maxMembers: data['max'],
        teamInfo: data['teamInfo'],
        playerInfo: data['playerInfo'],
        type: data['type'],
        status: data['status'],
        notification: data['notificationPlayers'],
        participants: data['participants']);
  }

  factory Events.fromMap(Map<String, dynamic> data) {
    return Events(
        eventId: data['eventId'],
        eventName: data['eventName'],
        creatorId: data['creatorId'],
        creatorName: data['creatorName'],
        location: data['location'],
        sportName: data['sportName'],
        description: data['description'],
        playersId: data['playersId'],
        dateTime: data['dateTime'].toDate(),
        maxMembers: data['max'],
        type: data['type'],
        status: data['status'],
        notification: data['notificationPlayers'],
        participants: data['participants']);
  }

  Future<bool> checkingAvailability(String id) async {
    var snap =
        await FirebaseFirestore.instance.collection('events').doc(id).get();
    Map<String, dynamic> data = snap.data();
    return data['playersId'].length < data['max'] ? true : false;
  }

  Future<List<dynamic>> players(String id) async {
    var snap =
        await FirebaseFirestore.instance.collection('events').doc(id).get();
    Map<String, dynamic> data = snap.data();
    return data['playersId'];
  }
}
