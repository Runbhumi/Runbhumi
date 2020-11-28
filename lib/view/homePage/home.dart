import 'package:Runbhumi/models/models.dart';
import 'package:Runbhumi/services/services.dart';
import 'package:Runbhumi/utils/theme_config.dart';
import 'package:Runbhumi/view/homePage/specific_sport.dart';
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
  TextEditingController _searchQuery;

  bool _isSearching = false;

  String searchQuery = "";

  Stream currentFeed;
  void initState() {
    super.initState();

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

  void _startSearch() {
    print("clicked search");
    ModalRoute.of(context)
        .addLocalHistoryEntry(new LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
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
        print("Feed loading");
        return asyncSnapshot.hasData
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
                      bool registrationCondition = data.playersId.contains(
                          Constants.prefs.getString('userId')); //asyncSnapshot
                      // .data.documents[index]
                      // .get('playersId')
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
                                          myColor: !registrationCondition
                                              ? Theme.of(context).primaryColor
                                              : Theme.of(context).accentColor,
                                          myText: !registrationCondition
                                              ? "Join"
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
                                    leading: Image.asset(sportIcon),
                                    title: Text(
                                      data.eventName,
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
                                          data.description,
                                          style: TextStyle(
                                            color: theme
                                                .currentTheme.backgroundColor,
                                          ),
                                        ),
                                        Text(
                                          DateFormat('MMM dd -')
                                              .add_jm()
                                              .format(data.dateTime)
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Feather.map_pin,
                                              size: 16.0,
                                            ),
                                            Text(
                                              data.location,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: theme.currentTheme
                                                    .backgroundColor,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : // if there is no event in the DB you will get this illustration
                Container(
                    child: Center(
                      child: Image.asset("assets/notification.png"),
                    ),
                  )
            : Loader();
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
        leading: _isSearching ? BackButton() : null,
        title:
            _isSearching ? _buildSearchField() : buildTitle(context, "My Feed"),
        actions: _buildActions(),
      ),
      body: NestedScrollView(
        headerSliverBuilder: homePageSliverAppBar,
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
                child: Text(
                  'Nearby you',
                  style: TextStyle(
                    color: theme.currentTheme.backgroundColor.withOpacity(0.35),
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
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

  List<Widget> homePageSliverAppBar(
      BuildContext context, bool innerBoxIsScrolled) {
    final ThemeNotifier theme = Provider.of<ThemeNotifier>(context);
    return <Widget>[
      SliverList(
        delegate: SliverChildListDelegate([
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Text(
              'Categories',
              style: TextStyle(
                color: theme.currentTheme.backgroundColor.withOpacity(0.35),
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SportsCategory(
                    theme: theme,
                    sport: "Basketball",
                    icon: "assets/icons8-basketball-96.png",
                  ),
                  SportsCategory(
                    theme: theme,
                    sport: "Cricket",
                    icon: "assets/icons8-cricket-96.png",
                  ),
                  SportsCategory(
                    theme: theme,
                    sport: "Football",
                    icon: "assets/icons8-soccer-ball-96.png",
                  ),
                  SportsCategory(
                    theme: theme,
                    sport: "Volleyball",
                    icon: "assets/icons8-volleyball-96.png",
                  ),
                ],
              ),
            ),
          ),
        ]),
      )
    ];
  }
}

class SportsCategory extends StatelessWidget {
  const SportsCategory({
    Key key,
    @required this.theme,
    @required this.sport,
    @required this.icon,
  }) : super(key: key);

  final ThemeNotifier theme;
  final String sport;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SpecificSport(sportName: this.sport))),
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(icon, scale: 1.8),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  sport,
                  style: TextStyle(
                    color: theme.currentTheme.backgroundColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
