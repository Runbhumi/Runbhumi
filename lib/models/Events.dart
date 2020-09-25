import 'package:cloud_firestore/cloud_firestore.dart';

class Events {
  String eventId;
  final String creatorId;
  String eventName;
  String location;
  String image;
  String description;
  List<String> playersId;
  DateTime dateTime;

  Events(
      {this.creatorId,
      this.eventName,
      this.location,
      this.image,
      this.description,
      this.playersId,
      this.dateTime});

  Map<String, dynamic> toJson() => {
        'creatorId': creatorId,
        'eventName': eventName,
        'location': location,
        'image': image,
        'playersId': playersId,
        'dateTime': dateTime
      };
  Events.fromSnapshot(DocumentSnapshot snapshot)
      : eventId = snapshot.data()['eventId'],
        creatorId = snapshot.data()['creatorId'],
        eventName = snapshot.data()['eventName'],
        location = snapshot.data()['location'],
        image = snapshot.data()['image'],
        description = snapshot.data()['desscription'],
        playersId = snapshot.data()['playerId'],
        dateTime = snapshot.data()['dateTime'].toDate();
}
