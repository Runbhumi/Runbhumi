import 'dart:async';

import 'package:Runbhumi/utils/theme_config.dart';
import 'package:Runbhumi/view/profile/otherUserProfile.dart';
import 'package:Runbhumi/widget/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class EventInfo extends StatefulWidget {
  final String eventId;
  const EventInfo({
    @required this.eventId,
    Key key,
  }) : super(key: key);
  @override
  _EventInfoState createState() => _EventInfoState();
}

class _EventInfoState extends State<EventInfo> {
  StreamSubscription sub;
  Map data;
  bool _loading = false;
  String sportIcon;
  @override
  void initState() {
    super.initState();
    sub = FirebaseFirestore.instance
        .collection('events')
        .doc(widget.eventId)
        .snapshots()
        .listen((snap) {
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
    switch (data['sportName']) {
      case "Volleyball":
        sportIcon = "assets/volleyball-image.jpg";
        break;
      case "Basketball":
        sportIcon = "assets/basketball-image.jpg";
        break;
      case "Cricket":
        sportIcon = "assets/cricket-image.jpg";
        break;
      case "Football":
        sportIcon = "assets/football-image.jpg";
        break;
    }
    final ThemeNotifier theme = Provider.of<ThemeNotifier>(context);
    if (_loading) {
      return Scaffold(
        //For all the team events
        appBar: AppBar(
          title: buildTitle(
            context,
            data['eventName'],
          ),
          leading: CustomBackButton(),
        ),
        body: SlidingUpPanel(
          // header: Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Container(
          //         padding: EdgeInsets.all(4),
          //         height: 12,
          //         width: 50,
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.all(
          //             Radius.circular(50.0),
          //           ),
          //           color: Colors.grey,
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          parallaxEnabled: true,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
          color: Theme.of(context).canvasColor,
          backdropEnabled: true,
          panel: Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.0),
                topRight: Radius.circular(24.0),
              ),
              color: Theme.of(context).canvasColor,
            ),
            child: Flexible(
              child: data["status"] == "individual"
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: data["playersId"].length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OtherUserProfile(
                                  userID: data["playerInfo"][index]["id"],
                                ),
                              ),
                            );
                          },
                          child: Card(
                            child: ListTile(
                              leading: Container(
                                height: 48,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: FadeInImage(
                                    placeholder: AssetImage(
                                        "assets/ProfilePlaceholder.png"),
                                    image: NetworkImage(
                                      data["playerInfo"][index]["profileImage"],
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                data["playerInfo"][index]["name"],
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Container(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: data["teamsId"].length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: ListTile(
                              title: Text("bye"),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ),
          collapsed: Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.0),
                topRight: Radius.circular(24.0),
              ),
              color: Theme.of(context).canvasColor,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Feather.chevrons_up,
                    size: 32,
                  ),
                  Text(
                    data["status"] == "individual"
                        ? "People who joined"
                        : "Teams who joined",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: NestedScrollView(
            headerSliverBuilder: eventInfoSliverAppBar,
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          data["sportName"],
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            Text(
                              (data["playersId"].length.toString() +
                                  "/" +
                                  data["max"].toString()),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            CircularProgressIndicator(
                              value: data["playersId"].length / data["max"],
                              backgroundColor: theme
                                  .currentTheme.backgroundColor
                                  .withOpacity(0.15),
                              strokeWidth: 7,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Icon(
                              Feather.file_text,
                              size: 24.0,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            data['description'].trim(),
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Icon(
                              data["type"] == 1 ? Feather.globe : Feather.lock,
                              size: 24.0,
                            ),
                          ),
                        ),
                        Text(
                          data["type"] == 1 ? "Public" : "Private",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Icon(
                              Feather.calendar,
                              size: 24.0,
                            ),
                          ),
                        ),
                        Text(
                          DateFormat('MMM dd')
                              .format(data["dateTime"].toDate())
                              .toString(),
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Icon(
                              Feather.clock,
                              size: 24.0,
                            ),
                          ),
                        ),
                        Text(
                          DateFormat()
                              .add_jm()
                              .format(data["dateTime"].toDate())
                              .toString(),
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Icon(
                              Feather.map_pin,
                              size: 24.0,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            data["location"],
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 124)
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return Loader();
    }
  }

  List<Widget> eventInfoSliverAppBar(
      BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      SliverAppBar(
        expandedHeight: 250.0,
        automaticallyImplyLeading: false,
        elevation: 0,
        floating: false,
        stretch: true,
        pinned: false,
        flexibleSpace: FlexibleSpaceBar(
          titlePadding: EdgeInsets.all(0),
          // centerTitle: true,
          // title: Container(
          //     child: buildTitle(context, "Schedule"),
          //     color: Theme.of(context).canvasColor.withOpacity(0.5)),
          background: Image(
            width: MediaQuery.of(context).size.width,
            image: AssetImage(sportIcon),
            fit: BoxFit.cover,
          ),
        ),
      ),
    ];
  }
}
