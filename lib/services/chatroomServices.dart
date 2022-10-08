import 'package:Runbhumi/models/message.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';

//Start of ChatroomService class
class ChatroomService {
  /*
    Searching a user by his username, while searching for friends
    Parameters: searchField: String
  */
  searchByName(String searchField) {
    return FirebaseFirestore.instance
        .collection("users")
        .where('username', isEqualTo: searchField)
        .snapshots();
  }

  /*
  This method creates a chatroom for two user for direct chats
  Parameters: chatroom:  Map<String, dynamic> of the details of the chatroom, chatRoomId: String  unique Chat Room Id
  */
  addChatRoom(Map<String, dynamic> chatRoom, String chatRoomId) {
    FirebaseFirestore.instance
        .collection("DirectChats")
        .doc(chatRoomId)
        .set(chatRoom)
        .catchError((e) {
      print(e);
    });
  }

  /*
  This method adds a new message whenever a user sends a new message to the chatroom
  Parameters:
  dateTime: DateTime of the message, sentby: String of the user Id, message: String which is the message
  sentByName: String name the user, chatRoomId: unique Chat Room Id
  */
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

  /*
  This method adds a new message whenever a user sends a new message to the Team chatroom
  Parameters:
  dateTime: DateTime of the message, sentby: String of the user Id, message: String which is the message
  sentByName: String name the user, teamId: unique teamId
  */
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

  /*
  This method adds a new message whenever a user sends a new message to the Event chatroom
  Parameters: dateTime: DateTime of the message, sentby: String of the user Id, message: String which is the message, 
  sentByName: String name the user, eventId: unique event Id
  */
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

  /*
  This method calls back all the previous messages for the team Chat room, note the limit
  Parameters: teamId: unique teamId, limit: int which limits the number of documents
  NOTE : Use this function with async/await
  */
  getTeamMessages(String teamId, int limit) async {
    return FirebaseFirestore.instance
        .collection("teams")
        .doc(teamId)
        .collection("chats")
        .orderBy('dateTime', descending: true)
        .limit(limit)
        .snapshots();
  }

  /*
  This method calls back all the previous messages for the Event Chat room, note the limit
  Parameters: eventId: unique event Id, limit: int which limits the number of documents
  NOTE : Use this function with async/await
  */
  getEventMessages(String eventId, int limit) async {
    return FirebaseFirestore.instance
        .collection("events")
        .doc(eventId)
        .collection("chats")
        .orderBy('dateTime', descending: true)
        .limit(limit)
        .snapshots();
  }

  /*
  This method calls back all the previous messages for the Direct Chat room, note the limit
  Parameters: chatRoomId: unique Chat Room Id, limit: int which limits the number of documents
  NOTE : Use this function with async/await
  */
  getDirectMessages(String chatRoomId, int limit) async {
    return FirebaseFirestore.instance
        .collection("DirectChats")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('dateTime', descending: true)
        .limit(limit)
        .snapshots();
  }

  /*
  This method calls back all the  Direct Chat room of the user
  NOTE : Use this function with async/await
  */
  getUsersDirectChats() async {
    print("I am here");
    return FirebaseFirestore.instance
        .collection("DirectChats")
        .where('users', arrayContains: GetStorage().read('userId'))
        .snapshots();
  }

  /*
  This method will be deleting the message 
  NOTE : Use this function with async/await
  */

  deleteThisMessage(
      String chatroomType, String chatRoomId, String messageId) async {
    FirebaseFirestore.instance
        .collection(chatroomType)
        .doc(chatRoomId)
        .collection("chats")
        .doc(messageId)
        .delete();
  }

  //End of ChatroomService class
}
