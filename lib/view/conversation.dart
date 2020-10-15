import 'package:Runbhumi/services/chatroomServices.dart';
import 'package:Runbhumi/utils/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Conversation extends StatefulWidget {
  final String chatRoomId;
  //chatRoomId is used to identify which chat room we are in
  Conversation({this.chatRoomId});
  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  Stream<QuerySnapshot> chats;
  TextEditingController messageEditingController = new TextEditingController();
  addMessage() {
    //adding the message typed by the user
    if (messageEditingController.text.isNotEmpty) {
      ChatroomService().sendNewMessage(
          DateTime.now(),
          Constants.prefs.getString('userId'),
          messageEditingController.text,
          widget.chatRoomId);
      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  Widget chatMessages() {
    //displaying previous chats
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                    //decides who sent the message and accordingly aligns the text
                    message: snapshot.data.documents[index].get('message'),
                    sendByMe: Constants.prefs.getString('userId') ==
                        snapshot.data.documents[index].get('sentby'),
                  );
                })
            : Container(
                child: Text("Start taliking"),
              );
      },
    );
  }

  @override
  void initState() {
    ChatroomService().getDirectMessages(widget.chatRoomId).then((value) {
      setState(() {
        chats = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //TODO: Making the chat box look like the prototype.
    return Scaffold(
      appBar: AppBar(
        title: Text("ChatBox"),
      ),
      body: Container(
        child: Stack(
          children: [
            chatMessages(),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                color: Colors.green,
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: messageEditingController,
                      decoration: InputDecoration(
                          hintText: "Message ...",
                          hintStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          border: InputBorder.none),
                    )),
                    SizedBox(
                      width: 16,
                    ),
                    GestureDetector(
                      onTap: () {
                        addMessage();
                      },
                      child: Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;
  //sendByMe boolean to check if the currentuser sent the message before.

  MessageTile({@required this.message, @required this.sendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8, bottom: 8, left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin:
            sendByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: sendByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23))
                : BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
                colors: sendByMe
                    ? [const Color(0xff007EF4), const Color(0xff2A75BC)]
                    : [Colors.red, Colors.red])),
        child: Text(message,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'OverpassRegular',
                fontWeight: FontWeight.w300)),
      ),
    );
  }
}
