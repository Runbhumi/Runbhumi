import 'package:Runbhumi/services/EventService.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

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
        hintStyle: const TextStyle(color: Colors.grey),
      ),
      style: const TextStyle(color: Colors.black, fontSize: 16.0),
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
          icon: const Icon(Icons.clear),
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
        icon: const Icon(Icons.search, size: 30),
        onPressed: _startSearch,
      ),
    ];
  }

  Widget feed() {
    return StreamBuilder(
        stream: currentFeed,
        builder: (context, asyncSnapshot) {
          print("Working");
          return asyncSnapshot.hasData
              ? ListView.builder(
                  itemCount: asyncSnapshot.data.documents.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                        title: Text(asyncSnapshot.data.documents[index]
                            .get('eventName')),
                        subtitle: Text(asyncSnapshot.data.documents[index]
                            .get('description')),
                        leading: Icon(Icons.play_arrow),
                        trailing: asyncSnapshot.data.documents[index]
                                    .get('description') ==
                                "Looking for players in our team"
                            ? GestureDetector(
                                onTap: () {
                                  //notification to be sent to the person who posted
                                },
                                child: Container(
                                  child: Text("Join"),
                                ),
                              )
                            : GestureDetector(
                                onTap: () {},
                                child: Container(
                                  child: Text("Accept"),
                                ),
                              ));
                  })
              : Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: new AppBar(
            automaticallyImplyLeading: false,
            leading: _isSearching ? BackButton() : null,
            title: _isSearching ? _buildSearchField() : _buildTitle(context),
            actions: _buildActions(),
            bottom: new TabBar(
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
            ),
          ),
          body: Container(child: Stack(children: <Widget>[feed()]))),
    );
  }
}
