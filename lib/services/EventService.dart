import 'package:Runbhumi/models/Events.dart';
import 'package:Runbhumi/models/Teams.dart';
import 'package:Runbhumi/services/UserServices.dart';
import 'package:Runbhumi/utils/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//import 'package:Runbhumi/models/Events.dart';

class EventService {
  CollectionReference _eventCollectionReference =
      FirebaseFirestore.instance.collection('events');

  addUserToEvent(String id) {
    _eventCollectionReference.doc(id).set({
      "playersId": FieldValue.arrayUnion([Constants.prefs.getString('userId')])
    }, SetOptions(merge: true));
  }

  getCurrentFeed() async {
    return FirebaseFirestore.instance
        .collection("events")
        .where('type', isLessThan: 3)
        // .orderBy('dateTime', descending: true)
        .snapshots();
  }

  getSpecificFeed(String sportName) async {
    return FirebaseFirestore.instance
        .collection("events")
        .where('sportName', isEqualTo: sportName)
        // .orderBy('dateTime', descending: true)
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

  getCurrentUserEventChats() async {
    return FirebaseFirestore.instance
        .collection("events")
        .where('playersId', arrayContains: Constants.prefs.get('userId'))
        // .orderBy('dateTime', descending: true)
        .snapshots();
  }

  // Future getEventDetails(String eventId) async {
  //   try {
  //     var eventsData = await _eventCollectionReference.doc(eventId).get();
  //     return Events.fromSnapshot(eventsData);
  //   } catch (e) {
  //     return e.message;
  //   }
  // }
}

//id, userId, "", _chosenSport, _chosenPurpose,[userId], DateTime.now()

// type is private or public

createNewEvent(
    String eventName,
    String creatorId,
    String location,
    String sportName,
    String description,
    List<String> playersId,
    DateTime dateTime,
    int maxMembers,
    String status,
    int type) {
  var newDoc = FirebaseFirestore.instance.collection('events').doc();
  String id = newDoc.id;
  newDoc.set(Events.newEvent(id, eventName, location, sportName, description,
          dateTime, maxMembers, status, type)
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
  UserService().updateEventCount(1);
  EventService().addUserToEvent(id);
}

registerUserToEvent(String id, String eventName, String sportName,
    String location, DateTime dateTime) {
  addEventToUser(id, eventName, sportName, location, dateTime);
}

addScheduleToUser(String userId, String eventName, String sportName,
    String location, DateTime dateTime) {
  var newDoc = FirebaseFirestore.instance.collection('events').doc();
  String id = newDoc.id;
  FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('userEvent')
      .doc(id)
      .set(Events.miniView(id, eventName, sportName, location, dateTime)
          .minitoJson());
}

addTeamToEvent(Events event, TeamView team) async {
  await FirebaseFirestore.instance
      .collection('events')
      .doc(event.eventId)
      .update({
    'playersId': FieldValue.arrayUnion([Constants.prefs.getString('userId')]),
    'teamsId': FieldValue.arrayUnion([team.teamId])
  });
  await FirebaseFirestore.instance
      .collection('teams')
      .doc(team.teamId)
      .collection('chats')
      .doc()
      .set({
    'message':
        "${Constants.prefs.getString('name')} has registered you for ${event.eventName}",
    'type': 'custom',
    'dateTime': DateTime.now(),
  });
}
// .set({
//    "eventsId": FieldValue.arrayUnion([id])
//  }, SetOptions(merge: true));

// leaving a event logic

leaveEvent(id, fate) {
  var userId = Constants.prefs.get('userId');
  FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('userEvent')
      .doc(id)
      .delete();
  FirebaseFirestore.instance.collection('events').doc(id).set({
    'playersId': FieldValue.arrayRemove([userId])
  }, SetOptions(merge: true));
  UserService().updateEventCount(-1);
}
