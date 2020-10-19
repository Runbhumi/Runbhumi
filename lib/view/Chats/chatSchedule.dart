import 'package:flutter/material.dart';

class ChatSchedule extends StatefulWidget {
  final String chatRoomId;
  final List<dynamic> usersNames;
  final List<dynamic> users;
  final List<dynamic> usersPics;
  ChatSchedule(
      {@required this.chatRoomId,
      @required this.usersNames,
      @required this.users,
      @required this.usersPics});
  @override
  _ChatScheduleState createState() => _ChatScheduleState();
}

class _ChatScheduleState extends State<ChatSchedule> {
  // Use widget.chatRoomId for corresponding chatroomId
  // Use widget.userNames for displaying the names og the people in the chat Id
  // Use widget.users fot the users ID's to be put into the backend.
  //Use the widget.usersPics for the Url for the pictures of the Partiipants.
  //TODO: Make UI for this page, backend to be discussed.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Schedule"),
      ),
    );
  }
}
