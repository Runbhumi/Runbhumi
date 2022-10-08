import 'package:runbhumi/models/models.dart';
import 'package:runbhumi/services/services.dart';

import 'package:runbhumi/utils/theme_config.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:unicons/unicons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../widget/widgets.dart';

class Schedule extends StatefulWidget {
  const Schedule({
    Key? key,
  }) : super(key: key);

  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  late Stream currentFeed;
  void initState() {
    super.initState();
    getUserInfoEvents();
  }

  getUserInfoEvents() async {
    EventService().getCurrentUserFeed().then((snapshots) {
      setState(() {
        currentFeed = snapshots;
        print("we got the data + ${currentFeed.toString()} ");
      });
    });
  }

  Widget feed() {
    return StreamBuilder(
      stream: currentFeed,
      builder: (context, asyncSnapshot) {
        final ThemeNotifier theme = Provider.of<ThemeNotifier>(context);
        print("schedule loading");
        return asyncSnapshot.hasData
            ? asyncSnapshot.data.documents.length > 0
                ? ListView.builder(
                    itemCount: asyncSnapshot.data.documents.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      Events data = new Events.fromMiniJson(
                          asyncSnapshot.data.documents[index]);
                      late String sportIcon;
                      // IconData sportIcon;
                      switch (data.sportName) {
                        case "Volleyball":
                          sportIcon = "assets/icons8-volleyball-96.png";
                          break;
                        case "Basketball":
                          // sportIcon = Icons.sports_basketball;
                          sportIcon = "assets/icons8-basketball-96.png";
                          break;
                        case "Cricket":
                          sportIcon = "assets/icons8-cricket-96.png";
                          break;
                        case "Football":
                          sportIcon = "assets/icons8-soccer-ball-96.png";
                          break;
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Card(
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                      dividerColor: Colors.transparent),
                                  child: ExpansionTile(
                                    tilePadding: EdgeInsets.all(0),
                                    maintainState: true,
                                    onExpansionChanged: (expanded) {
                                      if (expanded) {
                                      } else {}
                                    },
                                    children: [
                                      SmallButton(
                                        myColor: Color(0xffEB4758),
                                        myText: GetStorage().read('userId') !=
                                                data.creatorId
                                            ? "Leave"
                                            : "Delete",
                                        onPressed: () {
                                          print(GetStorage().read('userId'));
                                          print(GetStorage().read('userId'));
                                          if (GetStorage().read('userId') ==
                                              data.creatorId) {
                                            confirmationPopupForDeleting(
                                                context, data);
                                            // print(
                                            //     GetStorage().get('userId') ==
                                            //         data.creatorId);
                                            // Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //       builder: (context) =>
                                            //           EventConversation(
                                            //         data: data,
                                            //       ),
                                            //     ));
                                          } else {
                                            confirmationPopupForLeaving(
                                                context, data);
                                          }
                                        },
                                      ),
                                    ],
                                    title: Text(
                                      data.eventName!,
                                      style: TextStyle(
                                        color:
                                            theme.currentTheme.backgroundColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          DateFormat('MMM dd -')
                                              .add_jm()
                                              .format(data.dateTime!)
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              UniconsLine.map_pin,
                                              size: 16.0,
                                            ),
                                            Text(
                                              data.location!,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: theme.currentTheme
                                                    .backgroundColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    leading: Image.asset(sportIcon),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : //if you have no events you will get this illustration
                Container(
                    child: Center(
                      child: Image.asset("assets/events.png", height: 200),
                    ),
                  )
            : Loader();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 5,
      child: Stack(
        children: <Widget>[feed()],
      ),
    );
  }
}

confirmationPopupForDeleting(BuildContext context, Events data) {
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
      title: "Delete Event",
      desc: "Are you user you want to delete this event " + data.eventName!,
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
              "Delete",
              style: TextStyle(
                color: Colors.redAccent[400],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onPressed: () {
            if (data.type! < 4) {
              deleteEvent(data.eventId);
            } else {
              List<dynamic> playerId = data.playersId!;
              for (int i = 0; i < playerId.length; i++) {
                deleteIndividualUserMini(data.eventId!, playerId[i]);
              }
              //deleting the chatroom events.
            }
            Navigator.pop(context);
          },
          color: Color.fromRGBO(128, 128, 128, 0),
        )
      ]).show();
}

confirmationPopupForLeaving(BuildContext context, Events data) {
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
      title: "Leave Event",
      desc: "Are you user you want to leave this event " + data.eventName!,
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
              "Leave",
              style: TextStyle(
                color: Colors.redAccent[400],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onPressed: () {
            if (data.type! < 4) {
              leaveEvent(data);
            } else {
              deleteIndividualUserMini(
                  data.eventId!, GetStorage().read('userId')!);
            }
            Navigator.pop(context);
          },
          color: Color.fromRGBO(128, 128, 128, 0),
        )
      ]).show();
}
// logic for removing a event

/*

Remove the event from collection in user

Firestore.instance.collection("users").document("userid")  
    .collection("events").document(docid)
    .delete();

Remove the player from the event

if(playersId.remove(userId)) => true means its successfuly removed from event // user id can be taken from the shared preferences
else not success


If the user is a captain then allow him to pass his captainship to other player
ownership will be transfered

A new page will be required to show the details of all the players
to transfer his cap to the others

if(playerId == creatorId)
{
  // remove him with the same logic just show him a page
  from where he can transfer the captainship to other player
}

*/
