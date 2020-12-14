import 'package:Runbhumi/models/models.dart';
import 'package:Runbhumi/utils/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Runbhumi/services/services.dart';

//import 'package:Runbhumi/models/Events.dart';

class EventService {
  CollectionReference _eventCollectionReference =
      FirebaseFirestore.instance.collection('events');

  addUserToEvent(String id) {
    _eventCollectionReference.doc(id).set({
      "playersId": FieldValue.arrayUnion([Constants.prefs.getString('userId')])
    }, SetOptions(merge: true));
  }

  addGivenUsertoEvent(String id, String userId) {
    _eventCollectionReference.doc(id).set({
      "playersId": FieldValue.arrayUnion([userId])
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

String createNewEvent(
    String eventName,
    String creatorId,
    String location,
    String sportName,
    String description,
    List<String> playersId,
    DateTime dateTime,
    int maxMembers,
    String status,
    int type,
    bool challenge,
    bool payed) {
  var newDoc = FirebaseFirestore.instance.collection('events').doc();
  String id = newDoc.id;
  newDoc.set(Events.newEvent(id, eventName, location, sportName, description,
          dateTime, maxMembers, status, type)
      .toJson());
  if (!challenge && payed) {
    addEventToUser(id, eventName, sportName, location, dateTime, creatorId);
    UserService().updateEventTokens(-1);
  } else if (!challenge && !payed) {
    addEventToUser(id, eventName, sportName, location, dateTime, creatorId);
  } else {
    EventService().addUserToEvent(id);
  }
  return id;
}

addEventToUser(String id, String eventName, String sportName, String location,
    DateTime dateTime, String creatorId) {
  FirebaseFirestore.instance
      .collection('users')
      .doc(Constants.prefs.get('userId'))
      .collection('userEvent')
      .doc(id)
      .set(Events.miniView(
              id, eventName, sportName, location, dateTime, creatorId)
          .minitoJson());
  UserService().updateEventCount(1);
  EventService().addUserToEvent(id);
}

registerUserToEvent(String id, String eventName, String sportName,
    String location, DateTime dateTime, String creatorId) {
  addEventToUser(id, eventName, sportName, location, dateTime, creatorId);
}

addScheduleToUser(String userId, String eventName, String sportName,
    String location, DateTime dateTime, String creatorId) {
  var newDoc = FirebaseFirestore.instance.collection('events').doc();
  String id = newDoc.id;
  FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('userEvent')
      .doc(id)
      .set(Events.miniView(
              id, eventName, sportName, location, dateTime, creatorId)
          .minitoJson());
}

Future<Events> getEventDetails(String notificationId) async {
  var snap = await FirebaseFirestore.instance
      .collection('events')
      .doc(notificationId)
      .get();
  Map<String, dynamic> map = snap.data();
  Events event = Events.fromMap(map);
  return event;
}

Future<bool> addTeamToEvent(Events event, TeamView team) async {
  bool availability = await Events().checkingAvailability(event.eventId);
  if (availability) {
    await FirebaseFirestore.instance
        .collection('events')
        .doc(event.eventId)
        .update({
      'playersId': FieldValue.arrayUnion([Constants.prefs.getString('userId')]),
      'teamsId': FieldValue.arrayUnion([team.teamId])
    });
    await CustomMessageServices().sendEventAcceptEventChatCustomMessage(
        event.eventId, team.teamName, event.eventName);
    await CustomMessageServices().sendEventAcceptTeamChatCustomMessage(
        team.teamId, Constants.prefs.getString('username'), event.eventName);
    return true;
  }

  return false;
}
// .set({
//    "eventsId": FieldValue.arrayUnion([id])
//  }, SetOptions(merge: true));

// leaving a event logic

leaveEvent(id) {
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
  CustomMessageServices().userLeftEventMessage(id, Constants.prefs.get('name'));
}

deleteEvent(id) async {
  await FirebaseFirestore.instance.collection('events').doc(id).delete();
  await FirebaseFirestore.instance
      .collection('users')
      .doc(Constants.prefs.get('userId'))
      .collection('userEvent')
      .doc(id)
      .delete();
  UserService().updateEventCount(-1);
  //Trigger a cloud function
  //TODO: Delete from all the people who joined the event as well;
}
