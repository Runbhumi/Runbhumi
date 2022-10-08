import 'dart:math';

import 'package:Runbhumi/models/Teams.dart';
import 'package:Runbhumi/models/message.dart';
import 'package:Runbhumi/services/chatroomServices.dart';

import 'package:Runbhumi/view/teams/teaminfo.dart';
import 'package:Runbhumi/widget/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:unicons/unicons.dart';

import 'chatSchedule.dart';

class TeamConversation extends StatefulWidget {
  final Teams data;
  TeamConversation({required this.data});
  @override
  _TeamConversationState createState() => _TeamConversationState();
}

class _TeamConversationState extends State<TeamConversation> {
  late Stream<QuerySnapshot> chats;
  TextEditingController messageEditingController = new TextEditingController();
  ScrollController _controller = ScrollController();
  int limit = 20;
  addMessage() {
    //adding the message typed by the user
    if (messageEditingController.text.trim().isNotEmpty) {
      ChatroomService().sendNewMessageTeam(
          DateTime.now(),
          GetStorage().read('userId')!,
          messageEditingController.text.trim(),
          GetStorage().read('name')!,
          widget.data.teamId);
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
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                reverse: true,
                controller: _controller,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  Message data =
                      new Message.fromJson(snapshot.data.documents[index]);
                  // custom message
                  if (data.type != "") {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 8.0),
                      child: Card(
                        child: Center(
                          child: ListTile(
                            leading: Icon(
                              UniconsLine.info,
                              size: 20,
                            ),
                            title: Text(
                              data.message!,
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return MessageTile(
                    //decides who sent the message and accordingly aligns the text
                    message: data.message!,
                    sendByMe: GetStorage().read('userId') == data.sentby,
                    sentByName: data.sentByName!,
                    dateTime: data.dateTime!,
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
    ChatroomService().getTeamMessages(widget.data.teamId!, limit).then((value) {
      setState(() {
        chats = value;
      });
    });
    super.initState();
    _controller.addListener(_scrollListener);
    Future.delayed(Duration(milliseconds: 400), () {
      _controller.jumpTo(_controller.position.minScrollExtent);
    });
  }

  void _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      print("at the end of list");
      print(limit);
      setState(() {
        limit += limit;
        ChatroomService()
            .getTeamMessages(widget.data.teamId!, limit)
            .then((value) {
          setState(() {
            chats = value;
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    late String sportIcon;
    // IconData sportIcon;
    switch (widget.data.sport) {
      case "Volleyball":
        sportIcon = "assets/icons8-volleyball-96.png";
        break;
      case "Basketball":
        sportIcon = "assets/icons8-basketball-96.png";
        break;
      case "Cricket":
        sportIcon = "assets/icons8-cricket-96.png";
        break;
      case "Football":
        sportIcon = "assets/icons8-soccer-ball-96.png";
        break;
    }
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(),
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return TeamInfo(
                    teamID: widget.data.teamId!,
                  );
                },
              ),
            );
          },
          child: Row(
            children: [
              CircleAvatar(
                child: Image.asset(sportIcon),
                backgroundColor: Colors.transparent,
              ),
              SizedBox(
                width: 8,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.5,
                child: Text(widget.data.teamName!,
                    overflow: TextOverflow.fade,
                    style: TextStyle(color: Theme.of(context).backgroundColor)),
              ),
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
                    chatRoomId: widget.data.teamId!,
                    usersNames: widget.data.player!,
                    users: widget.data.playerId!,
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
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/chat background.png"),
                fit: BoxFit.cover)),
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
                        maxLength: 256,
                        onTap: () {
                          _controller
                              .jumpTo(_controller.position.minScrollExtent);
                        },
                        controller: messageEditingController,
                        decoration: InputDecoration(
                            counterText: "",
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

class MessageTile extends StatefulWidget {
  final String message;
  //sendByMe boolean to check if the currentuser sent the message before.
  final bool sendByMe;
  final String sentByName; //Sent By (Unused till now)
  final DateTime dateTime;

  MessageTile({
    required this.message,
    required this.sendByMe,
    required this.sentByName,
    required this.dateTime,
  });

  @override
  _MessageTileState createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  List colors = [
    Colors.yellow[200],
    Colors.grey[200],
  ];
  Random random = new Random();

  int colorIndex = 0;

  void initState() {
    super.initState();
    setState(() => colorIndex = random.nextInt(2));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // these are margins which go around each message tile
      margin: EdgeInsets.only(
        top: 4,
        bottom: 4,
        left: widget.sendByMe ? 48 : 0,
        right: widget.sendByMe ? 0 : 48,
      ),
      //alignment of the message tile
      alignment: widget.sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: widget.sendByMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(24), bottomLeft: Radius.circular(24))
              : BorderRadius.only(
                  topRight: Radius.circular(24),
                  bottomRight: Radius.circular(24)),
          color: widget.sendByMe
              ? Color(0xff004E52).withOpacity(0.9)
              : Theme.of(context).primaryColor.withOpacity(0.9),
        ),
        child: widget.sendByMe
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      widget.message,
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
                      DateFormat().add_jm().format(widget.dateTime).toString(),
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
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.sentByName,
                    style: TextStyle(
                      color: colors[colorIndex],
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                          DateFormat()
                              .add_jm()
                              .format(widget.dateTime)
                              .toString(),
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
                          widget.message,
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
                ],
              ),
      ),
    );
  }
}
