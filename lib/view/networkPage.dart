import 'package:Runbhumi/services/EventService.dart';
import 'package:Runbhumi/widget/placeholder_widget.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import '../widget/widgets.dart';

/*
  Code For Network Page
*/
class Network extends StatefulWidget {
  @override
  _NetworkState createState() => _NetworkState();
}

class _NetworkState extends State<Network> {
  // for Title
  Widget _buildTitle(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: const Text(
        'Network',
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildTitle(context),
        automaticallyImplyLeading: false,
      ),
      body: /*DefaultTabController(
        length: 3,
        child:*/
          Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Text(
                'Schedule',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            //schedule
            Schedule(), //scheduleList: scheduleList)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 8.0,
              ),
              child: Text(
                'Chats',
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.start,
              ),
            ),
            // ChatsTabs(),
            // TODO: replace placeholders with actual UI
            Expanded(
              // child: TabBarView(
              //   children: [
              //     PlaceholderWidget(),
              //     PlaceholderWidget(),
              //     PlaceholderWidget(),
              //   ],
              // ),
              child: PlaceholderWidget(),
            ),
          ],
        ),
      ),
      // ),
    );
  }
}

class Schedule extends StatefulWidget {
  // const Schedule({
  //   Key key,
  //   @required this.scheduleList,
  // }) : super(key: key);

  // final List scheduleList;

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
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                        ),
                        child: Card(
                          shadowColor: Color(0x44393e46),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          elevation: 5,
                          child: Container(
                            width: 300,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    isThreeLine: true,
                                    title: Text(
                                      asyncSnapshot.data.documents[index].get(
                                          'eventName'), // widget.scheduleList[index][],
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
                                          asyncSnapshot.data.documents[index]
                                              .get('location'),
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
                                                .format(asyncSnapshot
                                                    .data.documents[index]
                                                    .get('dateTime')
                                                    .toDate())
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
        ));

    //   ListView.builder(
    //     scrollDirection: Axis.horizontal,
    //     itemBuilder: (context, index) {
    //       return Padding(
    //         padding: const EdgeInsets.symmetric(
    //           horizontal: 8.0,
    //         ),
    //         child: Card(
    //           shadowColor: Color(0x44393e46),
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.all(Radius.circular(20)),
    //           ),
    //           elevation: 5,
    //           child: Container(
    //             width: 300,
    //             child: Padding(
    //               padding: const EdgeInsets.all(8.0),
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   ListTile(
    //                     isThreeLine: true,
    //                     title: Text(
    //                       // widget.scheduleList[index][],
    //                       style: Theme.of(context).textTheme.headline6,
    //                     ),
    //                     subtitle: Row(
    //                       children: [
    //                         Icon(
    //                           Feather.map_pin,
    //                           size: 16.0,
    //                         ),
    //                         Text(
    //                           "Bahrain",
    //                           style: Theme.of(context).textTheme.subtitle1,
    //                         ),
    //                       ],
    //                     ),
    //                     trailing: Column(
    //                       children: [
    //                         //time
    //                         Row(
    //                           mainAxisSize: MainAxisSize.min,
    //                           children: [
    //                             Text(DateTime.now().hour.toString()),
    //                             Text(":"),
    //                             Text(DateTime.now().minute.toString()),
    //                           ],
    //                         ),
    //                         //day
    //                         // Text(DateTime.now().weekday.toString()),
    //                         if (DateTime.now().weekday == 1) Text("MON"),
    //                         if (DateTime.now().weekday == 2) Text("TUE"),
    //                         if (DateTime.now().weekday == 3) Text("WED"),
    //                         if (DateTime.now().weekday == 4) Text("THU"),
    //                         if (DateTime.now().weekday == 5) Text("FRI"),
    //                         if (DateTime.now().weekday == 6) Text("SAT"),
    //                         if (DateTime.now().weekday == 7) Text("SUN"),
    //                       ],
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ),
    //       );
    //     },
    //     itemCount: widget.scheduleList.length,
    //   ),
    // );
  }
}

class ChatsTabs extends StatelessWidget {
  const ChatsTabs({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x29000000),
            blurRadius: 6,
            offset: Offset(0, -1),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: TabBar(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(child: Text("Direct")),
            Tab(child: Text("Team")),
            Tab(child: Text("B/W Teams")),
          ],
          indicator: new BubbleTabIndicator(
            indicatorHeight: 30.0,
            indicatorColor: Theme.of(context).primaryColor,
            tabBarIndicatorSize: TabBarIndicatorSize.tab,
          ),
        ),
      ),
    );
  }
}
