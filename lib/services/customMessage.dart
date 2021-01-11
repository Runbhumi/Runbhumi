import 'package:cloud_firestore/cloud_firestore.dart';

// Design messages for the chats
//Strat of the CustomMessageServices class
class CustomMessageServices {
  /* 
  This functions sends a custom message to the event chat room when a users registers for an event. 
  Paramaters - docId: EventId, team: teamName
  NOTE : Use this function with async/await
  */
  sendEventAcceptEventChatCustomMessage(String docId, String team) async {
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

  /* 
  This functions sends a custom message to the team chat room when a users registers for an event. 
  Paramaters - docId: EventId, team: teamName, eventName: name of the event
  NOTE : Use this function with async/await
  */
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

  /* 
  This functions sends a custom message to the team chat room when a users joins a team. 
  Paramaters - docId: teamId, name: user name
  NOTE : Use this function with async/await
  */
  sendTeamNewMemberJoinMessage(String docId, String name) async {
    await FirebaseFirestore.instance
        .collection('teams')
        .doc(docId)
        .collection('chats')
        .doc()
        .set({
      'message': "Welcome " + name + " to the team",
      'type': 'custom',
      'dateTime': DateTime.now(),
    });
  }

  /* 
  This functions sends a custom message to the team chat room when a users leaves a team. 
  Paramaters - docId: teamId, name: user name
  NOTE : Use this function with async/await
  */
  sendTeamLeaveMemberMessage(String docId, String name) async {
    await FirebaseFirestore.instance
        .collection('teams')
        .doc(docId)
        .collection('chats')
        .doc()
        .set({
      'message': name + " says goodbye!",
      'type': 'custom',
      'dateTime': DateTime.now(),
    });
  }

  /* 
  This functions sends a custom message to the event chat room when two managers connect for a challenge. 
  Paramaters - docId: event Id
  NOTE : Use this function with async/await
  */
  sendChallegeFirstRoomMessage(String docId) async {
    await FirebaseFirestore.instance
        .collection('events')
        .doc(docId)
        .collection('chats')
        .doc()
        .set({
      'message':
          "This chat room is to connect the managers of the respective teams",
      'type': 'custom',
      'dateTime': DateTime.now(),
    });
  }

  /* 
  This functions sends a custom message to the event chat room when user leaves an event. 
  Paramaters - id: Event Id, name: User name 
  NOTE : Use this function with async/await
  */
  userLeftEventMessage(String id, String name) async {
    await FirebaseFirestore.instance
        .collection('events')
        .doc(id)
        .collection('chats')
        .doc()
        .set({
      'message': name + " has left the event",
      'type': 'custom',
      'dateTime': DateTime.now(),
    });
  }

/* 
  This functions sends a custom message to the team chat room when manager assigns new captain for the team. 
  Paramaters - teamId: team Id, newCapName: User name 
  NOTE : Use this function with async/await
  */
  captainChangeMessage(String teamId, String newCapName) async {
    await FirebaseFirestore.instance
        .collection('teams')
        .doc(teamId)
        .collection('chats')
        .doc()
        .set({
      'message': newCapName + " is the new Captain!",
      'type': 'custom',
      'dateTime': DateTime.now(),
    });
  }

  //End of the CustomMessageServices class
}
