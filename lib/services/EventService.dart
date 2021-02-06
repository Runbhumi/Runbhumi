import 'package:Runbhumi/models/models.dart';
import 'package:Runbhumi/utils/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Runbhumi/services/services.dart';

//import 'package:Runbhumi/models/Events.dart';

class EventService {
  CollectionReference _eventCollectionReference =
      FirebaseFirestore.instance.collection('events');

  addUserToEvent(String id) {
    var userId = Constants.prefs.get('userId');
    var userName = Constants.prefs.get('name');
    var profileImage = Constants.prefs.get('profileImage');
    Friends friend = new Friends.newFriend(userId, userName, profileImage);
    _eventCollectionReference.doc(id).set({
      "playersId": FieldValue.arrayUnion([userId]),
      'playerInfo': FieldValue.arrayUnion([friend.toJson()]),
      'participants': FieldValue.arrayUnion([userId]),
    }, SetOptions(merge: true));
  }

  addGivenUsertoEvent(String id, String userId) {
    _eventCollectionReference.doc(id).set({
      "playersId": FieldValue.arrayUnion([userId]),
      'participants': FieldValue.arrayUnion([userId]),
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
        .where('participants', arrayContains: Constants.prefs.get('userId'))
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
    String creatorName,
    String location,
    String sportName,
    String description,
    List<dynamic> playersId,
    DateTime dateTime,
    int maxMembers,
    String status,
    int type,
    bool challenge,
    bool payed,
    String paid) {
  var newDoc = FirebaseFirestore.instance.collection('events').doc();
  String id = newDoc.id;
  newDoc.set(Events.newEvent(id, eventName, location, sportName, description,
          dateTime, maxMembers, status, type, paid)
      .toJson());
  if (!challenge && payed) {
    addEventToUser(id, eventName, sportName, location, dateTime, creatorId,
        creatorName, status, type, playersId, paid);
    UserService().updateEventTokens(-1);
  } else if (!challenge && !payed) {
    addEventToUser(id, eventName, sportName, location, dateTime, creatorId,
        creatorName, status, type, playersId, paid);
  } else {
    EventService().addUserToEvent(id);
  }
  return id;
}

addEventToUser(
    String id,
    String eventName,
    String sportName,
    String location,
    DateTime dateTime,
    String creatorId,
    String creatorName,
    String status,
    int type,
    List<dynamic> playersId,
    String paid) {
  FirebaseFirestore.instance
      .collection('users')
      .doc(Constants.prefs.get('userId'))
      .collection('userEvent')
      .doc(id)
      .set(Events.miniView(id, eventName, sportName, location, dateTime, status,
              creatorId, creatorName, type, playersId, paid)
          .minitoJson());
  //UserService().updateEventCount(1);
  //EventService().addUserToEvent(id);
}

addTeamEventToUser(
    String id,
    String eventName,
    String sportName,
    String location,
    DateTime dateTime,
    String creatorId,
    String creatorName,
    String status,
    int type,
    List<dynamic> playersId,
    String teamName,
    String teamId,
    String paid) {
  FirebaseFirestore.instance
      .collection('users')
      .doc(Constants.prefs.get('userId'))
      .collection('userEvent')
      .doc(id)
      .set(Events.miniTeamView(
              id,
              eventName,
              sportName,
              location,
              dateTime,
              status,
              creatorId,
              creatorName,
              type,
              playersId,
              teamName,
              teamId,
              paid)
          .miniTeamtoJson());
  //UserService().updateEventCount(1);
  //EventService().addUserToEvent(id);
}

registerUserToEvent(
    String id,
    String eventName,
    String sportName,
    String location,
    DateTime dateTime,
    String creatorId,
    String creatorName,
    String status,
    int type,
    List<dynamic> playersId,
    String paid) {
  addEventToUser(id, eventName, sportName, location, dateTime, creatorId,
      creatorName, status, type, playersId, paid);
}

addScheduleToUser(
    String userId,
    String eventName,
    String sportName,
    String location,
    DateTime dateTime,
    String creatorId,
    String creatorName,
    String eventId,
    String status,
    int type,
    List<dynamic> playersId,
    String paid) {
  FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('userEvent')
      .doc(eventId)
      .set(Events.miniView(eventId, eventName, sportName, location, dateTime,
              status, creatorId, creatorName, type, playersId, paid)
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
      'participants':
          FieldValue.arrayUnion([Constants.prefs.getString('userId')]),
      'teamsId': FieldValue.arrayUnion([team.teamId]),
      'teamInfo': FieldValue.arrayUnion([
        {'teamName': team.teamName, 'teamId': team.teamId}
      ])
    });
    addTeamEventToUser(
        event.eventId,
        event.eventName,
        event.sportName,
        event.location,
        event.dateTime,
        event.creatorId,
        event.creatorName,
        event.status,
        event.type,
        event.playersId,
        team.teamName,
        team.teamId,
        event.paid);
    await CustomMessageServices()
        .sendEventAcceptEventChatCustomMessage(event.eventId, team.teamName);
    await CustomMessageServices().sendEventAcceptTeamChatCustomMessage(
        team.teamId, Constants.prefs.getString('name'), event.eventName);
    return true;
  }

  return false;
}
// .set({
//    "eventsId": FieldValue.arrayUnion([id])
//  }, SetOptions(merge: true));

// leaving a event logic

leaveEvent(Events data) async {
  var userId = Constants.prefs.get('userId');
  var userName = Constants.prefs.get('name');
  var profileImage = Constants.prefs.get('profileImage');
  FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('userEvent')
      .doc(data.eventId)
      .delete();
  if (data.status == 'individual') {
    Friends friend = new Friends.newFriend(userId, userName, profileImage);
    FirebaseFirestore.instance.collection('events').doc(data.eventId).set({
      'playersId': FieldValue.arrayRemove([userId]),
      'playerInfo': FieldValue.arrayRemove([friend.toJson()]),
      'participants': FieldValue.arrayRemove([userId]),
    }, SetOptions(merge: true));
  } else if (data.status == 'team') {
    FirebaseFirestore.instance.collection('events').doc(data.eventId).set({
      'playersId': FieldValue.arrayRemove([userId]),
      'participants': FieldValue.arrayRemove([userId]),
      'teamsId': FieldValue.arrayRemove([data.teamId]),
      'teamInfo': FieldValue.arrayRemove([
        {'teamName': data.teamName, 'teamId': data.teamId}
      ])
    }, SetOptions(merge: true));
  }
  //UserService().updateEventCount(-1);
  CustomMessageServices()
      .userLeftEventMessage(data.eventId, Constants.prefs.get('name'));
}

deleteEvent(id) async {
  getEventInfo(id);
  await FirebaseFirestore.instance
      .collection('users')
      .doc(Constants.prefs.get('userId'))
      .collection('userEvent')
      .doc(id)
      .delete();
  await FirebaseFirestore.instance.collection('events').doc(id).delete();
}

getEventInfo(String eventId) async {
  List<dynamic> players = await Events().players(eventId);
  for (int i = 0; i < players.length; i++) {
    if (players[i] != Constants.prefs.get('userId'))
      deleteIndividualUserMini(eventId, players[i]);
  }
}

deleteIndividualUserMini(String eventId, String userId) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('userEvent')
      .doc(eventId)
      .delete();
}
