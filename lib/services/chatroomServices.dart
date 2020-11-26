import 'package:Runbhumi/models/message.dart';
import 'package:Runbhumi/utils/Constants.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:Runbhumi/models/Events.dart';

class ChatroomService {
  searchByName(String searchField) {
    return FirebaseFirestore.instance
        .collection("users")
        .where('username', isEqualTo: searchField)
        .snapshots();
  }

  getAllusers() {
    return FirebaseFirestore.instance.collection("users").snapshots();
  }

  addChatRoom(chatRoom, chatRoomId) {
    FirebaseFirestore.instance
        .collection("DirectChats")
        .doc(chatRoomId)
        .set(chatRoom)
        .catchError((e) {
      print(e);
    });
  }

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

  getTeamMessages(String teamId) async {
    return FirebaseFirestore.instance
        .collection("teams")
        .doc(teamId)
        .collection("chats")
        .orderBy('dateTime', descending: true)
        .snapshots();
  }

  getEventMessages(String eventId) async {
    return FirebaseFirestore.instance
        .collection("events")
        .doc(eventId)
        .collection("chats")
        .orderBy('dateTime', descending: true)
        .snapshots();
  }

  getDirectMessages(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("DirectChats")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('dateTime', descending: true)
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
