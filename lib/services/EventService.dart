import 'package:Runbhumi/models/Events.dart';
import 'package:Runbhumi/utils/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:Runbhumi/models/Events.dart';

class EventService {
  CollectionReference _eventCollectionReference =
      FirebaseFirestore.instance.collection('events');

  getCurrentFeed() async {
    return FirebaseFirestore.instance
        .collection("events")
        .orderBy('dateTime', descending: true)
        .snapshots();
  }

  getCurrentUserFeed() async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(Constants.prefs.get('userId'))
        .collection('userEvent')
        .orderBy('dateTime')
        .snapshots();
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

//id, userId, "", _chosenSport, _chosenPurpose,[userId], DateTime.now()

void createNewEvent(
    String eventName,
    String creatorId,
    String location,
    String sportName,
    String description,
    List<String> playersId,
    DateTime dateTime) {
  var newDoc = FirebaseFirestore.instance.collection('events').doc();
  String id = newDoc.id;
  newDoc.set(Events.newEvent(
          id, eventName, creatorId, location, sportName, description, dateTime)
      .toJson());
  addEventToUser(id, eventName, sportName, location, dateTime);
}

addEventToUser(String id, String eventName, String sportName, String location,
    DateTime dateTime) {
  FirebaseFirestore.instance
      .collection('users')
      .doc(Constants.prefs.get('userId'))
      .collection('userEvent')
      .doc(id)
      .set(Events.miniView(id, eventName, sportName, location, dateTime)
          .minitoJson());
}

registerUserToEvent(String id, String eventName, String sportName,
    String location, DateTime dateTime) {
  addEventToUser(id, eventName, sportName, location, dateTime);
}

// .set({
//    "eventsId": FieldValue.arrayUnion([id])
//  }, SetOptions(merge: true));
