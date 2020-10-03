import 'package:Runbhumi/models/Events.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventService {
  final CollectionReference _eventCollectionReference =
      FirebaseFirestore.instance.collection('events');

  Future addPlayerToEvent(Events _event, String playerId) async {
    try {
      await _eventCollectionReference
          .doc(_event.eventId)
          .update({"playerId": FieldValue.arrayUnion(_event.playersId)});
      return true;
    } catch (e) {
      return e.toString();
    }
  }

  Future getEventDetails(String eventId) async {
    try {
      var eventsData = await _eventCollectionReference.doc(eventId).get();
      return Events.fromSnapshot(eventsData);
    } catch (e) {
      return e.message;
    }
  }
}
