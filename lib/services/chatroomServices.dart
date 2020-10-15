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

  void sendNewMessage(
      DateTime dateTime, String sentby, String message, chatRoomId) {
    FirebaseFirestore.instance
        .collection("DirectChats")
        .doc(chatRoomId)
        .collection("chats")
        .add(Message.newMessage(dateTime, sentby, message).toJson())
        .catchError((e) {
      print(e.toString());
    });
  }

  getDirectMessages(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("DirectChats")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('dateTime')
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
