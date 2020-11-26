import 'package:Runbhumi/models/Events.dart';
import 'package:Runbhumi/models/message.dart';
import 'package:Runbhumi/services/chatroomServices.dart';
import 'package:Runbhumi/utils/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'chatSchedule.dart';

class EventConversation extends StatefulWidget {
  final Events data;
  EventConversation({@required this.data});
  @override
  _EventConversationState createState() => _EventConversationState();
}

class _EventConversationState extends State<EventConversation> {
  Stream<QuerySnapshot> chats;
  TextEditingController messageEditingController = new TextEditingController();
  ScrollController _controller = ScrollController();
  addMessage() {
    //adding the message typed by the user
    if (messageEditingController.text.trim().isNotEmpty) {
      ChatroomService().sendNewMessageEvent(
          DateTime.now(),
          Constants.prefs.getString('userId'),
          messageEditingController.text.trim(),
          Constants.prefs.getString('name'),
          widget.data.eventId);
      setState(() {
        messageEditingController.text = "";
        _controller.jumpTo(_controller.position.minScrollExtent);
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
                reverse: true,
                controller: _controller,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  Message data =
                      new Message.fromJson(snapshot.data.documents[index]);
                  return MessageTile(
                    //decides who sent the message and accordingly aligns the text
                    message: data.message,
                    sendByMe:
                        Constants.prefs.getString('userId') == data.sentby,
                    sentByName: data.sentByName,
                    dateTime: data.dateTime,
                  );
                })
            : Center(
                child: Container(
                  child: Text("Start taliking"),
                ),
              );
      },
    );
  }

  @override
  void initState() {
    ChatroomService().getEventMessages(widget.data.eventId).then((value) {
      setState(() {
        chats = value;
      });
    });
    super.initState();
    Future.delayed(Duration(milliseconds: 400), () {
      _controller.jumpTo(_controller.position.minScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    // String sportIcon;
    // IconData sportIcon;
    // switch (widget.data.sport) {
    //   case "Volleyball":
    //     sportIcon = "assets/icons8-volleyball-96.png";
    //     break;
    //   case "Basketball":
    //     // sportIcon = Icons.sports_basketball;
    //     sportIcon = "assets/icons8-basketball-96.png";
    //     break;
    //   case "Cricket":
    //     sportIcon = "assets/icons8-cricket-96.png";
    //     break;
    //   case "Football":
    //     sportIcon = "assets/icons8-soccer-ball-96.png";
    //     break;
    // }
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {},
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
              ),
              SizedBox(
                width: 8,
              ),
              Text(widget.data.eventName),
            ],
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatSchedule(
                    chatRoomId: widget.data.eventId,
                    usersNames: widget.data.playersId,
                    users: widget.data.playersId,
                  ),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(Icons.add_circle),
            ),
          )
        ],
      ),
      body: Container(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 70.0),
              child: chatMessages(),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onTap: () {
                          _controller
                              .jumpTo(_controller.position.minScrollExtent);
                        },
                        controller: messageEditingController,
                        decoration: InputDecoration(
                            hintText: "Message ...",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          addMessage();
                        },
                        color: Colors.white,
                      ),
                    )
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
  //sendByMe boolean to check if the currentuser sent the message before.
  final bool sendByMe;
  final String sentByName; //Sent By (Unused till now)
  final DateTime dateTime;

  MessageTile({
    @required this.message,
    @required this.sendByMe,
    @required this.sentByName,
    @required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // these are margins which go around each message tile
      margin: EdgeInsets.only(
        top: 4,
        bottom: 4,
        left: sendByMe ? 48 : 0,
        right: sendByMe ? 0 : 48,
      ),
      //alignment of the message tile
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: sendByMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(24), bottomLeft: Radius.circular(24))
              : BorderRadius.only(
                  topRight: Radius.circular(24),
                  bottomRight: Radius.circular(24)),
          color: sendByMe
              ? Color(0xff004E52).withOpacity(0.9)
              : Theme.of(context).primaryColor.withOpacity(0.9),
        ),
        child: sendByMe
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      message,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      DateFormat().add_jm().format(dateTime).toString(),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      DateFormat().add_jm().format(dateTime).toString(),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      message,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
