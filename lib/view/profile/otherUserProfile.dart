import 'dart:async';
import 'package:Runbhumi/services/Services.dart';
import 'package:Runbhumi/utils/Constants.dart';
import 'package:Runbhumi/widget/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../views.dart';

class OtherUserProfile extends StatefulWidget {
  const OtherUserProfile({
    @required this.userID,
    Key key,
  }) : super(key: key);
  final String userID;

  @override
  _OtherUserProfileState createState() => _OtherUserProfileState();
}

class _OtherUserProfileState extends State<OtherUserProfile>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Widget _buildTitle(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: new Column(
        children: <Widget>[
          const Text(
            'Profile',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
  }

  //toggle for drawer(menu)
  void toggle() {
    animationController.isDismissed
        ? animationController.forward()
        : animationController.reverse();
    print("menu toggle");
  }

  //distance for profile to move right when the drawer is opened
  //variables for drawer animations
  static const double maxSlide = 250.0;
  static const double minDragStartEdge = 60;
  static const double maxDragStartEdge = maxSlide - 16;
  bool _canBeDragged = false;

  @override
  Widget build(BuildContext context) {
    var myDrawer = SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          // to close drawer
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Feather.x,
                  color: Colors.white,
                ),
                onPressed: toggle,
              );
            },
          ),
        ),
        body: DrawerBody(),
      ),
    );
    var myChild = Scaffold(
      appBar: AppBar(
        title: _buildTitle(context),
        centerTitle: true,
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Feather.arrow_left,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
      body: OtherProfileBody(
        userID: widget.userID,
      ),
    );
    return GestureDetector(
      onHorizontalDragStart: _onDragStart,
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, _) {
          double slide = maxSlide * animationController.value;
          double scale = 1 - (animationController.value * 0.3);
          return Stack(
            children: [
              myDrawer,
              Transform(
                child: myChild,
                transform: Matrix4.identity()
                  ..translate(slide)
                  ..scale(scale),
                alignment: Alignment.centerLeft,
              ),
            ],
          );
        },
      ),
    );
  }

  void _onDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft = animationController.isDismissed &&
        details.globalPosition.dx < minDragStartEdge;
    bool isDragCloseFromRight = animationController.isCompleted &&
        details.globalPosition.dx > maxDragStartEdge;

    _canBeDragged = isDragOpenFromLeft || isDragCloseFromRight;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_canBeDragged) {
      double delta = details.primaryDelta / maxSlide;
      animationController.value += delta;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    //I have no idea what it means, copied from Drawer
    double _kMinFlingVelocity = 365.0;

    if (animationController.isDismissed || animationController.isCompleted) {
      return;
    }
    if (details.velocity.pixelsPerSecond.dx.abs() >= _kMinFlingVelocity) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx /
          MediaQuery.of(context).size.width;

      animationController.fling(velocity: visualVelocity);
    } else if (animationController.value < 0.5) {
      animationController.reverse();
    } else {
      animationController.forward();
    }
  }
}

class OtherProfileBody extends StatefulWidget {
  const OtherProfileBody({
    @required this.userID,
    Key key,
  }) : super(key: key);
  final String userID;

  @override
  _OtherProfileBodyState createState() => _OtherProfileBodyState();
}

class _OtherProfileBodyState extends State<OtherProfileBody> {
  final db = FirebaseFirestore.instance;
  StreamSubscription sub;
  Map data;
  bool _loading = false;
  @override
  void initState() {
    super.initState();
    sub = db.collection('users').doc(widget.userID).snapshots().listen((snap) {
      setState(() {
        data = snap.data();
        _loading = true;
      });
    });
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: UserProfile(data: data),
              ),
            ],
          ),
        ),
      );
    } else {
      return Loader();
    }
  }
}

class UserProfile extends StatelessWidget {
  const UserProfile({
    Key key,
    @required this.data,
  }) : super(key: key);

  final Map data;

  @override
  Widget build(BuildContext context) {
    // if (data['friends'].contains(Constants.prefs.getString('userId')))
    //   print('Its is true');
    String _id = Constants.prefs.getString('userId');
    return Column(
      children: [
        //profile image
        if (data['profileImage'] != null)
          Container(
            width: 150,
            height: 150,
            margin: EdgeInsets.only(top: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(40)),
              image: DecorationImage(
                image: NetworkImage(data['profileImage']),
                fit: BoxFit.contain,
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x44393e46),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
          ),
        //Name
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            data['name'],
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
        ),
        //Bio
        Padding(
          padding: const EdgeInsets.only(
            bottom: 8.0,
            left: 32.0,
            right: 32.0,
          ),
          child: Center(
            child: Text(
              data['bio'],
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        if (data['friends'] != null &&
            data['friends'].contains(_id) &&
            data['userId'] != _id)
          Button(
            myColor: Colors.redAccent[400],
            myText: "Remove Friend",
            onPressed: () {
              // a confirmation is required because its a serious action

              confirmationPopup(context, data['name'], data['userId'], _id);

              // showDialog(
              //     context: context,
              //     builder: (context) {
              //       return successDialog(context, data['userId'], _id);
              //     });
            },
          ),

        if (data['notification'] != null &&
            data['userId'] != _id &&
            !(data['friends'].contains(_id)) &&
            data['notification'].contains(_id))
          OutlineButton(
            padding: const EdgeInsets.all(16.0),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2.0,
            ),
            highlightedBorderColor: Theme.of(context).primaryColor,
            color: Theme.of(context).primaryColor,
            child: Text(
              "Request Sent",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            onPressed: () {},
          ),
        if (data['userId'] != _id &&
            !(data['friends'].contains(_id)) &&
            !(data['notification'].contains(_id)))
          Button(
            myColor: Theme.of(context).primaryColor,
            myText: "Add Friend",
            onPressed: () {
              FriendRequestServices().createRequest(data['userId']);
            },
          ),

        // if ()
        //   Button(
        //     myColor: Theme.of(context).primaryColor,
        //     myText: "Remove Friends",
        //     onPressed: () {
        //       NotificationServices().createRequest(data['userId']);
        //     },
        //   ),
        //stats
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Container(
            color: Colors.grey.withOpacity(0.1),
            width: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            data['eventCount'].toString(),
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w500),
                          ),
                          Text("events"),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            data['teamsCount'].toString(),
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w500),
                          ),
                          Text("teams"),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            data['friendCount'].toString(),
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w500),
                          ),
                          Text("friends"),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        //details
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (data["age"] != "")
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Feather.user,
                          size: 24.0,
                        ),
                      ),
                      Text(
                        data["age"],
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                if (data["location"] != "")
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Feather.map_pin,
                          size: 24.0,
                        ),
                      ),
                      Text(
                        data["location"],
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Feather.mail,
                        size: 24.0,
                      ),
                    ),
                    Text(
                      data["emailId"],
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                if (data['phoneNumber']['show'])
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Feather.phone,
                          size: 24.0,
                        ),
                      ),
                      Text(
                        data['phoneNumber']['ph'],
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

confirmationPopup(BuildContext context, String name, String id1, String id2) {
  var alertStyle = AlertStyle(
    animationType: AnimationType.fromBottom,
    isCloseButton: false,
    isOverlayTapDismiss: true,
    titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    descStyle: TextStyle(
        fontWeight: FontWeight.w500, fontSize: 18, color: Colors.grey[600]),
    alertAlignment: Alignment.center,
    animationDuration: Duration(milliseconds: 400),
  );

  Alert(
      context: context,
      style: alertStyle,
      title: "Remove Friend",
      desc: "Are you sure you want to remove " + name + " as friend",
      buttons: [
        DialogButton(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Cancel",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Color.fromRGBO(128, 128, 128, 0),
        ),
        DialogButton(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Remove",
              style: TextStyle(
                color: Colors.redAccent[400],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onPressed: () {
            FriendServices().removeFriend(id1, id2);
            Navigator.pop(context);
          },
          color: Color.fromRGBO(128, 128, 128, 0),
        )
      ]).show();
}

//   SimpleDialog successDialog(BuildContext context, String id1, String id2) {
//     return SimpleDialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.all(Radius.circular(20)),
//       ),
//       children: [
//         Center(
//             child: Text("You serious ??",
//                 textAlign: TextAlign.center,
//                 style: Theme.of(context).textTheme.headline4)),
//         Button(
//           onPressed: () => {},
//           myColor: Theme.of(context).accentColor,
//           myText: "Cancel",
//         ),
//         Button(
//           onPressed: () => {
//             FriendServices().removeFriend(id1, id2),
//           },
//           myColor: Theme.of(context).accentColor,
//           myText: "I hate Him",
//         ),
//       ],
//     );
//   }
// }
