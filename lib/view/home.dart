import 'package:Runbhumi/services/EventService.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../utils/theme_config.dart';
import 'package:Runbhumi/utils/Constants.dart';
import '../widget/widgets.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _searchQuery;

  bool _isSearching = false;

  String searchQuery = "";

  Stream currentFeed;
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
    _searchQuery = new TextEditingController();
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
                style: Theme.of(context).textTheme.headline4)),
        Image.asset("assets/confirmation-illustration.png")
      ],
    );
  }

  getUserInfoEvents() async {
    EventService().getCurrentFeed().then((snapshots) {
      setState(() {
        currentFeed = snapshots;
        print("we got the data + ${currentFeed.toString()} ");
      });
    });
  }

  void _startSearch() {
    print("clicked search");
    ModalRoute.of(context)
        .addLocalHistoryEntry(new LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    print("close search");
    setState(() {
      _searchQuery.clear();
      updateSearchQuery("");
    });
  }

  Widget _buildTitle(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'My Feed',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return new TextField(
      controller: _searchQuery,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Search...',
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        hintStyle: const TextStyle(color: Colors.grey),
      ),
      style: const TextStyle(fontSize: 16.0),
      onChanged: updateSearchQuery,
    );
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
    print("searched " + newQuery);
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        new IconButton(
          icon: const Icon(Feather.x),
          onPressed: () {
            if (_searchQuery == null || _searchQuery.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      new IconButton(
        icon: const Icon(Feather.search),
        onPressed: _startSearch,
      ),
    ];
  }

  Widget feed({ThemeNotifier theme}) {
    return StreamBuilder(
      stream: currentFeed,
      builder: (context, asyncSnapshot) {
        print("Working");
        return asyncSnapshot.hasData
            ? ListView.builder(
                itemCount: asyncSnapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  String sportName = asyncSnapshot.data.documents[index]
                      .get('sportName')
                      .toString();
                  IconData sportIcon;
                  switch (sportName) {
                    case "Volleyball":
                      sportIcon = Icons.sports_volleyball;
                      break;
                    case "Basketball":
                      sportIcon = Icons.sports_basketball;
                      break;
                    case "Cricket":
                      sportIcon = Icons.sports_cricket;
                      break;
                    case "Football":
                      sportIcon = Icons.sports_soccer;
                      break;
                  }
                  bool registrationCondition = asyncSnapshot
                      .data.documents[index]
                      .get('playersId')
                      .contains(Constants.prefs.getString('userId'));
                  var eventData = asyncSnapshot.data.documents[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Card(
                      shadowColor: Color(0x44393e46),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      elevation: 20,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ExpansionTile(
                              maintainState: true,
                              onExpansionChanged: (expanded) {
                                if (expanded) {
                                } else {}
                              },
                              children: [
                                SmallButton(
                                    myColor: !registrationCondition
                                        ? Theme.of(context).primaryColor
                                        : Theme.of(context).accentColor,
                                    myText: !registrationCondition
                                        ? "Join"
                                        : "Already Registered",
                                    onPressed: () {
                                      if (!registrationCondition) {
                                        registerUserToEvent(
                                          eventData.get('eventId'),
                                          eventData.get('eventName'),
                                          eventData.get('sportName'),
                                          eventData.get('location'),
                                          eventData.get('dateTime').toDate(),
                                        );
                                        print("User Registered");
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return successDialog(context);
                                            });
                                      } else {
                                        print("Already Registered");
                                      }
                                    })
                              ],
                              leading: Icon(
                                sportIcon,
                                size: 48,
                                color: theme.currentTheme.backgroundColor,
                              ),
                              title: Text(
                                asyncSnapshot.data.documents[index]
                                    .get('eventName'),
                                style: TextStyle(
                                  color: theme.currentTheme.backgroundColor,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    asyncSnapshot.data.documents[index]
                                        .get('description'),
                                    style: TextStyle(
                                      color: theme.currentTheme.backgroundColor,
                                    ),
                                  ),
                                  Row(
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
                                  )
                                ],
                              ),
                              trailing: Text(DateFormat('E\ndd/MM\nkk:mm')
                                  .format(asyncSnapshot.data.documents[index]
                                      .get('dateTime')
                                      .toDate())
                                  .toString()),
                              // trailing: asyncSnapshot.data.documents[index]
                              //             .get('description') ==
                              //         "Looking for players in our team"
                              //     ? GestureDetector(
                              //         onTap: () {
                              //           //notification to be sent to the person who posted
                              //         },
                              //         child: Container(
                              //           child: Text("Join"),
                              //         ),
                              //       )
                              //     : GestureDetector(
                              //         onTap: () {},
                              //         child: Container(
                              //           child: Text("Accept"),
                              //         ),
                              //       ),
                              // trailing: Text(asyncSnapshot.data.documents[index]
                              //     .get('dateTime').toString()
                              // ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            : Loader();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeNotifier theme = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        leading: _isSearching ? BackButton() : null,
        title: _isSearching ? _buildSearchField() : _buildTitle(context),
        actions: _buildActions(),
        /*bottom: new TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(child: Text("Today")),
              Tab(child: Text("Tommorow")),
              Tab(child: Text("Later")),
            ],
            indicator: new BubbleTabIndicator(
              indicatorHeight: 30.0,
              indicatorColor: Theme.of(context).primaryColor,
              tabBarIndicatorSize: TabBarIndicatorSize.tab,
            ),
          ),*/
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Text(
                'Nearby you',
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: Stack(
                children: <Widget>[feed(theme: theme)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
