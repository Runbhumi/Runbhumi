import 'package:cloud_firestore/cloud_firestore.dart';

// Design messages for the chats

class CustomMessageServices {
  sendEventAcceptEventChatCustomMessage(
      String docId, String team, String eventName) async {
    await FirebaseFirestore.instance
        .collection('events')
        .doc(docId)
        .collection('chats')
        .doc()
        .set({
      'message': team + " just Joined!",
      'type': 'custom',
      'dateTime': DateTime.now(),
    });
  }

  sendEventAcceptTeamChatCustomMessage(
      String docId, String name, String eventName) async {
    await FirebaseFirestore.instance
        .collection('teams')
        .doc(docId)
        .collection('chats')
        .doc()
        .set({
      'message': "Team sucessfully got registered for " + eventName,
      'type': 'custom',
      'dateTime': DateTime.now(),
    });
  }

  sendTeamNewMemberJoinMessage(String docId, String name) async {
    await FirebaseFirestore.instance
        .collection('teams')
        .doc(docId)
        .collection('chats')
        .doc()
        .set({
      'message': "Welcome " + name + "to the team",
      'type': 'custom',
      'dateTime': DateTime.now(),
    });
  }

  sendTeamLeaveMemberMessage(String docId, String name) async {
    await FirebaseFirestore.instance
        .collection('teams')
        .doc(docId)
        .collection('chats')
        .doc()
        .set({
      'message': name + "says goodbye!",
      'type': 'custom',
      'dateTime': DateTime.now(),
    });
  }
}
