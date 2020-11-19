import 'package:Runbhumi/models/models.dart';
import 'package:Runbhumi/services/Services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import '../../widget/widgets.dart';

class Schedule extends StatefulWidget {
  const Schedule({
    Key key,
  }) : super(key: key);

  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  Stream currentFeed;
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
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

  @override
  void dispose() {
    super.dispose();
  }

  Widget feed() {
    return StreamBuilder(
      stream: currentFeed,
      builder: (context, asyncSnapshot) {
        print("Working");
        return asyncSnapshot.hasData
            ? asyncSnapshot.data.documents.length > 0
                ? ListView.builder(
                    itemCount: asyncSnapshot.data.documents.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      Events data = new Events.fromMiniJson(
                          asyncSnapshot.data.documents[index]);
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Card(
                          shadowColor: Color(0x44393e46),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          elevation: 5,
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ExpansionTile(
                                    children: [
                                      SmallButton(
                                        myColor: Color(0xffEB4758),
                                        myText: "Leave",
                                        onPressed: () =>
                                            {leaveEvent(data.eventId, 1)},
                                      ),
                                    ],
                                    title: Text(
                                      data.eventName,
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                    subtitle: Row(
                                      children: [
                                        Icon(
                                          Feather.map_pin,
                                          size: 16.0,
                                        ),
                                        Text(
                                          data.location,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1,
                                        ),
                                      ],
                                    ),
                                    trailing: Column(
                                      children: [
                                        //time
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(DateFormat('E\ndd/MM\nkk:mm')
                                                .format(data.dateTime)
                                                .toString()),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
