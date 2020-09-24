import 'package:Runbhumi/models/Events.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventService {
  final CollectionReference _eventCollectionReference =
      FirebaseFirestore.instance.collection('events');

  Future addPost(Events event) async {
    try {
      await _eventCollectionReference.add(event.toJson());
      return true;
    } catch (e) {
      return e.toString();
    }
  }

  Future getEvent(String eventId) async {
    try {
      var eventsData = await _eventCollectionReference.doc(eventId).get();
      return Events.fromSnapshot(eventsData);
    } catch (e) {
      return e.message;
    }
  }
}
