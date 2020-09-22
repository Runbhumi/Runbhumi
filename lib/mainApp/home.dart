import 'dart:io';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage();
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  static final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>();

  TextEditingController _searchQuery;
  bool _isSearching = false;
  String searchQuery = "";

  @override
  
  void initState() {
    super.initState();
    _searchQuery = new TextEditingController();
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

  Widget _buildTitle(BuildContext context) {
    var horizontalTitleAlignment =
        Platform.isIOS ? CrossAxisAlignment.center : CrossAxisAlignment.start;

    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: horizontalTitleAlignment,
        children: <Widget>[
          const Text(
            'My Feed',
            style: TextStyle(
                fontWeight: FontWeight.w700, fontSize: 30, color: Colors.black),
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
        hintStyle: const TextStyle(color: Colors.black54),
      ),
      style: const TextStyle(color: Colors.black, fontSize: 16.0),
      onChanged: updateSearchQuery,
    );
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
    print("searched" + newQuery);
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        new IconButton(
          icon: const Icon(Icons.clear, color: Colors.black),
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
        icon: const Icon(Icons.search, color: Colors.black, size: 30),
        onPressed: _startSearch,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: new Scaffold(
          key: scaffoldKey,
          appBar: new AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              leading:
                  _isSearching ? const BackButton(color: Colors.black) : null,
              title: _isSearching ? _buildSearchField() : _buildTitle(context),
              actions: _buildActions(),
              bottom: new TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
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
              )),
          body: TabBarView(
            children: [
              Icon(Icons.directions_car, size: 50),
              Icon(Icons.directions_transit, size: 50),
              Icon(Icons.directions_bike, size: 50),
            ],
          ),
          bottomNavigationBar: CurvedNavigationBar(
            // key: _bottomNavigationKey,
            index: 0,
            height: 60.0,
            items: <Widget>[
              Icon(Icons.home, size: 30, color: Colors.white),
              Icon(Icons.group, size: 30, color: Colors.white),
              Icon(Icons.add, size: 30, color: Colors.white),
              Icon(Icons.notifications, size: 30, color: Colors.white),
              Icon(Icons.person, size: 30, color: Colors.white),
            ],
            color: Theme.of(context).primaryColor,
            buttonBackgroundColor: Theme.of(context).primaryColor,
            backgroundColor: Colors.white,
            animationCurve: Curves.fastLinearToSlowEaseIn,
            animationDuration: Duration(milliseconds: 800),
            onTap: (index) {},
          ),
        ));
  }
}
