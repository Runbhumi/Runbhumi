import 'package:Runbhumi/models/models.dart';
import 'package:Runbhumi/services/services.dart';
import 'package:Runbhumi/utils/theme_config.dart';
import 'package:Runbhumi/view/teamEventNotification.dart';
import 'package:Runbhumi/widget/widgets.dart';
// import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:Runbhumi/utils/Constants.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // TextEditingController _searchQuery;

  // bool _isSearching = false;

  // String searchQuery = "";

  Stream currentFeed;
  void initState() {
    super.initState();

    // _searchQuery = new TextEditingController();
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

  getUserInfoEvents() async {
    EventService().getCurrentFeed().then((snapshots) {
      setState(() {
        currentFeed = snapshots;
        // print("we got the data + ${currentFeed.toString()} ");
        print("we got the data for UserInfoEvents");
      });
    });
  }

  // void _startSearch() {
  //   print("clicked search");
  //   ModalRoute.of(context)
  //       .addLocalHistoryEntry(new LocalHistoryEntry(onRemove: _stopSearching));

  //   setState(() {
  //     _isSearching = true;
  //   });
  // }

  // void _stopSearching() {
  //   _clearSearchQuery();

  //   setState(() {
  //     _isSearching = false;
  //   });
  // }

  // void _clearSearchQuery() {
  //   print("close search");
  //   setState(() {
  //     _searchQuery.clear();
  //     updateSearchQuery("");
  //   });
  // }

  // Widget _buildSearchField() {
  //   return new TextField(
  //     controller: _searchQuery,
  //     autofocus: true,
  //     decoration: const InputDecoration(
  //       hintText: 'Search...',
  //       border: InputBorder.none,
  //       focusedBorder: InputBorder.none,
  //       hintStyle: const TextStyle(color: Colors.grey),
  //     ),
  //     style: const TextStyle(fontSize: 16.0),
  //     onChanged: updateSearchQuery,
  //   );
  // }

  // void updateSearchQuery(String newQuery) {
  //   setState(() {
  //     searchQuery = newQuery;
  //   });
  //   print("searched " + newQuery);
  // }

  // List<Widget> _buildActions() {
  //   if (_isSearching) {
  //     return <Widget>[
  //       new IconButton(
  //         icon: const Icon(Feather.x),
  //         onPressed: () {
  //           if (_searchQuery == null || _searchQuery.text.isEmpty) {
  //             Navigator.pop(context);
  //             return;
  //           }
  //           _clearSearchQuery();
  //         },
  //       ),
  //     ];
  //   }

  //   return <Widget>[
  //     new IconButton(
  //       icon: const Icon(Feather.search),
  //       onPressed: _startSearch,
  //     ),
  //   ];
  // }

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
                          // String sportName = asyncSnapshot.data.documents[index]
                          //     .get('sportName')
                          //     .toString();
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
                                                Image(
                                                  image: AssetImage(sportIcon),
                                                  width: 70,
                                                ),
                                                // title time and location
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      data.eventName,
                                                      style: TextStyle(
                                                        color: theme
                                                            .currentTheme
                                                            .backgroundColor,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Feather.clock,
                                                          size: 14.0,
                                                        ),
                                                        SizedBox(width: 4),
                                                        Text(
                                                          DateFormat('MMM dd -')
                                                              .add_jm()
                                                              .format(
                                                                  data.dateTime)
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w600,
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
                                                        SizedBox(width: 4),
                                                        Text(
                                                          data.location,
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    )
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
                                                      Feather.globe,
                                                      size: 18,
                                                      color: data.type == 1
                                                          ? Colors.green[400]
                                                          : Colors.red[400],
                                                    ),
                                                    Text(
                                                      data.type == 1
                                                          ? "Public"
                                                          : "private",
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
                                        SmallButton(
                                            myColor: !registrationCondition
                                                ? Theme.of(context).primaryColor
                                                : Theme.of(context)
                                                    .primaryColorDark,
                                            myText: !registrationCondition
                                                ? data.type == 1
                                                    ? "Join"
                                                    : "Send Request"
                                                : "Already Registered",
                                            onPressed: () {
                                              if (!registrationCondition) {
                                                if (data.type == 2) {
                                                  //For Private
                                                  if (data.status == 'team') {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              TeamEventNotification(
                                                                  data: data)),
                                                    );
                                                  } else {
                                                    NotificationServices()
                                                        .createIndividualNotification(
                                                            data);
                                                    //TODO: Change the button to invite sent
                                                    //Private Individual Event
                                                  }
                                                } else {
                                                  //public
                                                  if (data.status == 'team') {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              TeamEventNotification(
                                                                  data: data)),
                                                    );
                                                  } else {
                                                    registerUserToEvent(
                                                        data.eventId,
                                                        data.eventName,
                                                        data.sportName,
                                                        data.location,
                                                        data.dateTime);
                                                    print("User Registered");
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return successDialog(
                                                              context);
                                                        });
                                                  }
                                                }
                                              } else {
                                                print("Already Registered");
                                              }
                                            })
                                      ],
                                    ),
                                    // child: Theme(
                                    //   data: Theme.of(context).copyWith(
                                    //       dividerColor: Colors.transparent),
                                    //   child: ExpansionTile(
                                    //     tilePadding: EdgeInsets.all(0),
                                    //     maintainState: true,
                                    //     onExpansionChanged: (expanded) {
                                    //       if (expanded) {
                                    //       } else {}
                                    //     },
                                    //     children: [
                                    //       SmallButton(
                                    //           myColor: !registrationCondition
                                    //               ? Theme.of(context)
                                    //                   .primaryColor
                                    //               : Theme.of(context)
                                    //                   .accentColor,
                                    //           myText: !registrationCondition
                                    //               ? "Join"
                                    //               : "Already Registered",
                                    //           onPressed: () {
                                    //             if (!registrationCondition) {
                                    //               if (data.type == 2) {
                                    //                 //For Private
                                    //                 if (data.status == 'team') {
                                    //                   Navigator.push(
                                    //                     context,
                                    //                     MaterialPageRoute(
                                    //                         builder: (context) =>
                                    //                             TeamEventNotification(
                                    //                                 data:
                                    //                                     data)),
                                    //                   );
                                    //                 } else {
                                    //                   NotificationServices()
                                    //                       .createIndividualNotification(
                                    //                           data);
                                    //                   //TODO: Change the button to invite sent
                                    //                   //Private Individual Event
                                    //                 }
                                    //               } else {
                                    //                 //public
                                    //                 if (data.status == 'team') {
                                    //                   Navigator.push(
                                    //                     context,
                                    //                     MaterialPageRoute(
                                    //                         builder: (context) =>
                                    //                             TeamEventNotification(
                                    //                                 data:
                                    //                                     data)),
                                    //                   );
                                    //                 } else {
                                    //                   registerUserToEvent(
                                    //                       data.eventId,
                                    //                       data.eventName,
                                    //                       data.sportName,
                                    //                       data.location,
                                    //                       data.dateTime);
                                    //                   print("User Registered");
                                    //                   showDialog(
                                    //                       context: context,
                                    //                       builder: (context) {
                                    //                         return successDialog(
                                    //                             context);
                                    //                       });
                                    //                 }
                                    //               }
                                    //             } else {
                                    //               print("Already Registered");
                                    //             }
                                    //           })
                                    //     ],
                                    //     leading: Image.asset(sportIcon),
                                    //     title: Text(
                                    //       data.eventName,
                                    //       style: TextStyle(
                                    //         color: theme
                                    //             .currentTheme.backgroundColor,
                                    //         fontSize: 18,
                                    //         fontWeight: FontWeight.w500,
                                    //       ),
                                    //     ),
                                    //     subtitle: Column(
                                    //       crossAxisAlignment:
                                    //           CrossAxisAlignment.start,
                                    //       children: [
                                    //         Text(
                                    //           data.description,
                                    //           style: TextStyle(
                                    //             color: theme.currentTheme
                                    //                 .backgroundColor,
                                    //           ),
                                    //         ),
                                    //         Text(
                                    //           DateFormat('MMM dd -')
                                    //               .add_jm()
                                    //               .format(data.dateTime)
                                    //               .toString(),
                                    //           style: TextStyle(
                                    //             fontSize: 13,
                                    //             fontWeight: FontWeight.w600,
                                    //           ),
                                    //         ),
                                    //         Row(
                                    //           children: [
                                    //             Icon(
                                    //               Feather.map_pin,
                                    //               size: 16.0,
                                    //             ),
                                    //             Text(
                                    //               data.location,
                                    //               style: TextStyle(
                                    //                 fontSize: 13,
                                    //                 fontWeight: FontWeight.w500,
                                    //                 color: theme.currentTheme
                                    //                     .backgroundColor,
                                    //               ),
                                    //             ),
                                    //           ],
                                    //         )
                                    //       ],
                                    //     ),
                                    //   ),
                                    // ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : Container(
                        child: Center(
                          child: Image.asset("assets/notification.png"),
                        ),
                      )
                : Loader());
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
        title: buildTitle(context, "Events"),
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
