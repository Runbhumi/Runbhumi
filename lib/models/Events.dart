import 'package:cloud_firestore/cloud_firestore.dart';

class Events {
  final String eventId;
  final String creatorId;
  String eventName;
  String location;
  String image;
  String sportName;
  String description;
  List<String> playersId;
  DateTime dateTime;

  Events(
      {this.eventId,
      this.creatorId,
      this.eventName,
      this.location,
      this.image,
      this.sportName,
      this.description,
      this.playersId,
      this.dateTime});

  Map<String, dynamic> toJson() => {
        'eventId': eventId,
        'creatorId': creatorId,
        'eventName': eventName,
        'location': location,
        'image': image,
        'sportName': sportName,
        'description': description,
        'playersId': playersId,
        'dateTime': dateTime
      };
  Events.fromSnapshot(DocumentSnapshot snapshot)
      : eventId = snapshot.data()['eventId'],
        creatorId = snapshot.data()['creatorId'],
        eventName = snapshot.data()['eventName'],
        location = snapshot.data()['location'],
        image = snapshot.data()['image'],
        sportName = snapshot.data()['sportName'],
        description = snapshot.data()['desscription'],
        playersId = snapshot.data()['playerId'],
        dateTime = snapshot.data()['dateTime'].toDate();
}
