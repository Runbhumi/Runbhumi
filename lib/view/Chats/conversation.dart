import 'package:Runbhumi/services/chatroomServices.dart';
import 'package:Runbhumi/utils/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../views.dart';

class Conversation extends StatefulWidget {
  final String chatRoomId;
  final List<dynamic> usersNames;
  final List<dynamic> users;
  final List<dynamic> usersPics;
  //chatRoomId is used to identify which chat room we are in
  Conversation(
      {@required this.chatRoomId,
      @required this.usersNames,
      @required this.users,
      @required this.usersPics});
  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  Stream<QuerySnapshot> chats;
  TextEditingController messageEditingController = new TextEditingController();
  ScrollController _controller = ScrollController();
  addMessage() {
    //adding the message typed by the user
    if (messageEditingController.text.trim().isNotEmpty) {
      ChatroomService().sendNewMessage(
          DateTime.now(),
          Constants.prefs.getString('userId'),
          messageEditingController.text.trim(),
          widget.chatRoomId);
      setState(() {
        messageEditingController.text = "";
      });
    }
    _controller.jumpTo(_controller.position.maxScrollExtent);
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
                  return MessageTile(
                    //decides who sent the message and accordingly aligns the text
                    message: snapshot.data.documents[index].get('message'),
                    sendByMe: Constants.prefs.getString('userId') ==
                        snapshot.data.documents[index].get('sentby'),
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
    ChatroomService().getDirectMessages(widget.chatRoomId).then((value) {
      setState(() {
        chats = value;
      });
    });
    super.initState();
    Future.delayed(Duration(milliseconds: 400), () {
      _controller.jumpTo(_controller.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {},
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image(
                    height: 40,
                    image: NetworkImage(
                      Constants.prefs.getString('name') == widget.usersNames[0]
                          ? widget.usersPics[0]
                          : widget.usersPics[1],
                    )),
              ),
              SizedBox(
                width: 8,
              ),
              Constants.prefs.getString('name') == widget.usersNames[0]
                  ? Text(widget.usersNames[1])
                  : Text(widget.usersNames[0]),
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
                          chatRoomId: widget.chatRoomId,
                          usersNames: widget.usersNames,
                          users: widget.users,
                          usersPics: widget.usersPics)));
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
                              .jumpTo(_controller.position.maxScrollExtent);
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
          color: sendByMe
              ? Color(0xff393e46).withOpacity(0.8)
              : Color(0xff00adb5).withOpacity(0.8),
        ),
        child: Text(message,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w400)),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:async';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/painting.dart';
// import 'package:flutter_chat_bubble/bubble_type.dart';
// import 'package:flutter_chat_bubble/chat_bubble.dart';
// import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';

// class Chat extends StatefulWidget {
//   final String username;
//   final String userId;
//   Chat({this.username, this.userId});
//   @override
//   _ChatState createState() => _ChatState();
// }

// class _ChatState extends State<Chat> {
//   var chatMsg;
//   String token;
//   TextEditingController myMsgController = TextEditingController();
//   Future fetchToken() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var fetchedToken = prefs.getString('token');

//     setState(() {
//       token = fetchedToken;
//     });
//     // token = fetchedToken;
//   }

//   Future getMessages() async {
//     final response = await http
//         .post('https://guffgaffchat.herokuapp.com/api/chat/getall', body: {
//       "recipient_id": widget.userId
//     }, headers: {
//       'Authorization': 'Bearer $token',
//     });

//     if (response.statusCode == 200) {
//       var decodedResponse = jsonDecode(response.body);
//       print(decodedResponse);
//       return decodedResponse;
//     } else {
//       print(response.statusCode);
//       print(token);
//       // print(response.reasonPhrase);
//       // return Exception('failed to load user');
//       throw Exception('Failed to load messages');
//     }
//   }

//   Future sendMessage() async {
//     Map payload = {
//       "message": this.myMsgController.text,
//       "recipient_id": widget.userId
//     };

//     final response = await http.post(
//         'https://guffgaffchat.herokuapp.com/api/chat/create',
//         body: payload,
//         headers: {
//           'Authorization': 'Bearer $token',
//         });
//     this.myMsgController.clear();
//     // this.chatMsg = '';
//     if (response.statusCode == 200) {
//       print('message is sent');
//       getMessages();
//     } else {
//       print('error');
//       print(payload);
//       print(json.decode(response.body));
//     }
//   }

//   // var messages;
//   // @override
//   void initState() {
//     super.initState();
//     fetchToken();
//     // messages = getMessages();
//   }

//   void dispose() {
//     // Clean up the controller when the widget is removed from the widget tree.
//     myMsgController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.username),
//         centerTitle: true,
//       ),
//       body: FutureBuilder(
//           future: getMessages(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator());
//             }
//             if (snapshot.hasError) {
//               print(snapshot.error);
//               return Center(
//                 child: Icon(
//                   Icons.error_outline,
//                   color: Colors.red,
//                   size: 30,
//                 ),
//               );
//             } else {
//               var item = snapshot.data['messages'];
//               return ListView.builder(
//                 padding: EdgeInsets.only(bottom: 80),
//                 reverse: true,
//                 itemCount: item.length,
//                 itemBuilder: (context, index) {
//                   var name =
//                       (item[index]['full_name']).split(' ')[0].toUpperCase();
//                   print(index);
//                   return Container(
//                     margin: EdgeInsets.only(bottom: 8),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         Flexible(
//                           child: ChatBubble(
//                             alignment: Alignment.topRight,
//                             backGroundColor: Colors.redAccent,
//                             clipper:
//                                 ChatBubbleClipper1(type: BubbleType.sendBubble),
//                             child: Text(item[index]['msg']),
//                           ),
//                         ),
//                         CircleAvatar(
//                             child: widget.userId == item[index]['sender']
//                                 ? Text(name[0])
//                                 : Text('Me'))
//                       ],
//                     ),
//                   );
//                   // return ListTile(

//                   //   trailing: CircleAvatar(
//                   //       child: widget.userId == item[index]['sender']
//                   //           ? Text(name[0])
//                   //           : Text('Me')),
//                   //   // title: Text(item[index]['username']),
//                   //   // trailing: Text(item[index]['date'].split("T")[0]),
//                   //   subtitle: Text(item[index]['msg']),
//                   // );
//                 },
//               );
//             }
//           }),
//       bottomSheet: Container(
//         margin: EdgeInsets.only(bottom: 4),
//         child: TextFormField(
//           controller: myMsgController,
//           decoration: InputDecoration(
//               suffixIcon: IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: () {
//                     sendMessage();
//                   }),
//               border: OutlineInputBorder(
//                   borderSide:
//                       BorderSide(color: Colors.orangeAccent, width: 0.1),
//                   borderRadius: BorderRadius.all(Radius.circular(30.0))),
//               focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.white, width: 0.1),
//                   borderRadius: BorderRadius.all(Radius.circular(30.0))),
//               labelText: 'Your sweet message ....'),
//           onChanged: (value) {
//             // setState(() => this.chatMsg = value);
//           },
//         ),
//       ),
//     );
//   }
// }
// //flutter chat application
