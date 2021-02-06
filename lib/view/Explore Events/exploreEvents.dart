import 'package:Runbhumi/models/models.dart';
import 'package:Runbhumi/services/EventService.dart';
import 'package:Runbhumi/services/services.dart';
import 'package:Runbhumi/utils/theme_config.dart';
import 'package:Runbhumi/view/Explore%20Events/eventInfo.dart';
import 'package:Runbhumi/view/teamEventNotification.dart';
import 'package:Runbhumi/view/teams/teaminfo.dart';
import 'package:Runbhumi/view/views.dart';
import 'package:Runbhumi/widget/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:Runbhumi/utils/Constants.dart';
import 'package:url_launcher/url_launcher.dart';

class ExploreEvents extends StatefulWidget {
  @override
  _ExploreEventsState createState() => _ExploreEventsState();
}

class _ExploreEventsState extends State<ExploreEvents> {
  Stream currentFeed;
  void initState() {
    super.initState();
    getUserInfoEvents();
  }

  SimpleDialog successDialog(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      children: [
        Center(
            child: Text("You Have been added",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline4)),
        Image.asset("assets/confirmation-illustration.png")
      ],
    );
  }

  final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'runbhumi12@gmail.com',
      queryParameters: {'subject': 'Token Request'});
  SimpleDialog infoDialog(BuildContext context) {
    return SimpleDialog(
      title: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Icon(
              Feather.info,
              size: 64,
            )),
          ),
          Center(child: Text("This is a premium feature")),
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: RichText(
              text: TextSpan(children: [
                new TextSpan(
                    text:
                        "In order to use Runbhumi as a platform to host and advertise sporting tournaments you would need tokens. \n",
                    style: Theme.of(context).textTheme.subtitle1),
                new TextSpan(
                    //TODO: update the UI for this part
                    text: "Please click here to contact sales for tokens",
                    style: Theme.of(context).textTheme.subtitle1,
                    recognizer: new TapGestureRecognizer()
                      ..onTap = () {
                        launch(_emailLaunchUri.toString());
                      }),
              ]),
            ),
          ),
        ),
      ],
    );
  }

  SimpleDialog infoDialog2(BuildContext context) {
    return SimpleDialog(
      title: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Icon(
              Feather.info,
              size: 64,
            )),
          ),
          Center(child: Text("This Event is full!")),
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
              child: Text(
                  "The event is currently full, please try again later.",
                  style: Theme.of(context).textTheme.subtitle1)),
        ),
      ],
    );
  }

  getUserInfoEvents() async {
    EventService().getCurrentFeed().then((snapshots) {
      setState(() {
        currentFeed = snapshots;
        print("we got the data for UserInfoEvents");
      });
    });
  }

  Widget feed({ThemeNotifier theme}) {
    return StreamBuilder(
      stream: currentFeed,
      builder: (context, asyncSnapshot) {
        print("Events are loading");
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          child: asyncSnapshot.hasData
              ? asyncSnapshot.data.documents.length > 0
                  ? ListView.builder(
                      itemCount: asyncSnapshot.data.documents.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        Events data = new Events.fromJson(
                            asyncSnapshot.data.documents[index]);
                        String sportIcon;
                        switch (data.sportName) {
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
                        bool registrationCondition = data.playersId.contains(
                            Constants.prefs
                                .getString('userId')); //asyncSnapshot
                        // .data.documents[index]
                        // .get('playersId')
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Card(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: GestureDetector(
                                    onLongPress: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return EventInfo(
                                              eventId: data.eventId,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: ExpansionCard(
                                      maintainState: true,
                                      // main column
                                      alwaysShowingChild: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          //1st row
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Image(
                                                      image:
                                                          AssetImage(sportIcon),
                                                      width: 70,
                                                    ),
                                                    SizedBox(width: 4),
                                                    // title time and location
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          //event name
                                                          Container(
                                                            child: Text(
                                                              data.eventName,
                                                              style: TextStyle(
                                                                color: theme
                                                                    .currentTheme
                                                                    .backgroundColor,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .visible,
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                Feather.clock,
                                                                size: 14.0,
                                                              ),
                                                              SizedBox(
                                                                  width: 4),
                                                              Text(
                                                                DateFormat(
                                                                        'MMM dd -')
                                                                    .add_jm()
                                                                    .format(data
                                                                        .dateTime)
                                                                    .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                Feather.map_pin,
                                                                size: 14.0,
                                                              ),
                                                              SizedBox(
                                                                  width: 4),
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    2.4,
                                                                child: Text(
                                                                  data.location,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .visible,
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Stack(
                                                  alignment:
                                                      AlignmentDirectional
                                                          .center,
                                                  children: [
                                                    Text(
                                                      (data.playersId.length
                                                              .toString() +
                                                          "/" +
                                                          data.maxMembers
                                                              .toString()),
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    CircularProgressIndicator(
                                                      value: data.playersId
                                                              .length /
                                                          data.maxMembers,
                                                      backgroundColor: theme
                                                          .currentTheme
                                                          .backgroundColor
                                                          .withOpacity(0.15),
                                                      strokeWidth: 7,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      data.type == 1
                                                          ? Feather.globe
                                                          : Feather.lock,
                                                      size: 18,
                                                      color: data.type == 1
                                                          ? Colors.green[400]
                                                          : Colors.red[400],
                                                    ),
                                                    Text(
                                                      data.type == 1
                                                          ? "Public"
                                                          : "Private",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: data.type == 1
                                                            ? Colors.green[400]
                                                            : Colors.red[400],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Text(data.status + "s can join",
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Description",
                                                  style: TextStyle(
                                                    color: theme.currentTheme
                                                        .backgroundColor
                                                        .withOpacity(0.45),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  textAlign: TextAlign.start,
                                                ),
                                                Text(data.description.trim()),
                                                SizedBox(height: 4),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      children: [
                                        data.notification.contains(Constants
                                                .prefs
                                                .getString('userId'))
                                            ? SmallButton(
                                                myColor: Theme.of(context)
                                                    .primaryColor,
                                                myText: "Notification Sent")
                                            : SmallButton(
                                                myColor: !registrationCondition
                                                    ? Theme.of(context)
                                                        .primaryColor
                                                    : Theme.of(context)
                                                        .primaryColorDark,
                                                myText: !registrationCondition
                                                    ? data.type == 1
                                                        ? "Join"
                                                        : "Send Request"
                                                    : "Already Registered",
                                                onPressed: () async {
                                                  if (!registrationCondition) {
                                                    if (data.type == 2) {
                                                      //For Private
                                                      if (data.status ==
                                                          'team') {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  TeamEventNotification(
                                                                      data:
                                                                          data)),
                                                        );
                                                      } else {
                                                        if (!data.notification
                                                            .contains(Constants
                                                                .prefs
                                                                .getString(
                                                                    'userId'))) {
                                                          NotificationServices()
                                                              .createIndividualNotification(
                                                                  data);
                                                        }
                                                        if (data.notification
                                                            .contains(Constants
                                                                .prefs
                                                                .getString(
                                                                    'userId'))) {
                                                          showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return notifcationPending(
                                                                  context);
                                                            },
                                                          );
                                                        }
                                                        //Private Individual Event
                                                      }
                                                    } else {
                                                      //public
                                                      if (data.status ==
                                                          'team') {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  TeamEventNotification(
                                                                      data:
                                                                          data)),
                                                        );
                                                      } else {
                                                        print('Here is the me');
                                                        if (await Events()
                                                            .checkingAvailability(
                                                                data.eventId)) {
                                                          registerUserToEvent(
                                                              data.eventId,
                                                              data.eventName,
                                                              data.sportName,
                                                              data.location,
                                                              data.dateTime,
                                                              data.creatorId,
                                                              data.creatorName,
                                                              data.status,
                                                              data.type,
                                                              data.playersId,
                                                              data.paid);
                                                          print(
                                                              "User Registered");
                                                          EventService()
                                                              .addUserToEvent(
                                                                  data.eventId);
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return successDialog(
                                                                    context);
                                                              });
                                                        } else {
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return infoDialog2(
                                                                    context);
                                                                // A dialouge box for people who are not in the event
                                                              });
                                                        }
                                                      }
                                                    }
                                                  } else {
                                                    print("Already Registered");
                                                  }
                                                },
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  :
                  // this comes when there is no event happening
                  ExploreEventEmptyState()
              : Loader(),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeNotifier theme = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        // leading: _isSearching ? BackButton() : null,
        // title:
        //     _isSearching ? _buildSearchField() : buildTitle(context, "My Feed"),
        title: buildTitle(context, "Explore Events"),
        actions: [
          IconButton(
              icon: Icon(Feather.info),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return infoDialog(context);
                  },
                );
              })
        ],
        // actions: _buildActions(),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            BodyHeader(theme: theme, text: "Nearby you"),
            Expanded(
              child: Stack(
                children: <Widget>[
                  feed(theme: theme),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // child: Container(
        //   width: 60,
        //   height: 60,
        //   child: Icon(
        //     Feather.plus,
        //     size: 40,
        //   ),
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.all(Radius.circular(20)),
        //       // shape: BoxShape.circle,
        //       gradient: LinearGradient(
        //         begin: Alignment.topLeft,
        //         colors: [Color(0xff00d2ff), Color(0xff0052ff)])),
        // ),
        onPressed: () {
          Navigator.pushNamed(context, "/addpost");
        },
        child: Icon(
          Feather.plus,
          size: 32,
        ),
      ),
    );
  }
}

class ExploreEventEmptyState extends StatelessWidget {
  const ExploreEventEmptyState({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: Image.asset("assets/post_online.png", width: 300),
          ),
          Text(
            "Didn't find any event, create one",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Button(
            myColor: Theme.of(context).primaryColor,
            myText: "Add Event",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return AddPost();
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class BodyHeader extends StatelessWidget {
  const BodyHeader({
    Key key,
    @required this.theme,
    @required this.text,
  }) : super(key: key);

  final ThemeNotifier theme;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
      child: Text(
        text,
        style: TextStyle(
          color: theme.currentTheme.backgroundColor.withOpacity(0.35),
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }
}
