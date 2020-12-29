import 'package:Runbhumi/models/message.dart';
import 'package:Runbhumi/utils/Constants.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:Runbhumi/models/Events.dart';

class ChatroomService {
  //Searching a user by his username, while searching for friends
  searchByName(String searchField) {
    return FirebaseFirestore.instance
        .collection("users")
        .where('username', isEqualTo: searchField)
        .snapshots();
  }

  // getAllusers() {
  //   return FirebaseFirestore.instance.collection("users").snapshots();
  // }

  //This method creates a chatroom for two user for direct chats
  addChatRoom(chatRoom, chatRoomId) {
    FirebaseFirestore.instance
        .collection("DirectChats")
        .doc(chatRoomId)
        .set(chatRoom)
        .catchError((e) {
      print(e);
    });
  }

  //This method adds a new message whenever a user sends a new message to the chatroom
  void sendNewMessage(DateTime dateTime, String sentby, String message,
      String sentByName, chatRoomId) {
    FirebaseFirestore.instance
        .collection("DirectChats")
        .doc(chatRoomId)
        .collection("chats")
        .add(Message.newMessage(dateTime, sentby, message, sentByName).toJson())
        .catchError((e) {
      print(e.toString());
    });
  }

  //This method adds a new message whenever a user sends a new message to the Team chatroom
  void sendNewMessageTeam(DateTime dateTime, String sentby, String message,
      String sentByName, teamId) {
    FirebaseFirestore.instance
        .collection("teams")
        .doc(teamId)
        .collection("chats")
        .add(Message.newMessage(dateTime, sentby, message, sentByName).toJson())
        .catchError((e) {
      print(e.toString());
    });
  }

  //This method adds a new message whenever a user sends a new message to the Event chatroom
  void sendNewMessageEvent(DateTime dateTime, String sentby, String message,
      String sentByName, eventId) {
    FirebaseFirestore.instance
        .collection("events")
        .doc(eventId)
        .collection("chats")
        .add(Message.newMessage(dateTime, sentby, message, sentByName).toJson())
        .catchError((e) {
      print(e.toString());
    });
  }

  //This method calls back all the previous messages for the team Chat room, note the limit
  getTeamMessages(String teamId, int limit) async {
    return FirebaseFirestore.instance
        .collection("teams")
        .doc(teamId)
        .collection("chats")
        .orderBy('dateTime', descending: true)
        .limit(limit)
        .snapshots();
  }

  //This method calls back all the previous messages for the Event Chat room, note the limit
  getEventMessages(String eventId, int limit) async {
    return FirebaseFirestore.instance
        .collection("events")
        .doc(eventId)
        .collection("chats")
        .orderBy('dateTime', descending: true)
        .limit(limit)
        .snapshots();
  }

  getDirectMessages(String chatRoomId, int limit) async {
    return FirebaseFirestore.instance
        .collection("DirectChats")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('dateTime', descending: true)
        .limit(limit)
        .snapshots();
  }

  getUsersDirectChats() async {
    print("I am here");
    return FirebaseFirestore.instance
        .collection("DirectChats")
        .where('users', arrayContains: Constants.prefs.getString('userId'))
        .snapshots();
  }
}
