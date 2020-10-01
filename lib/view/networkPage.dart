import 'package:Runbhumi/view/placeholder_widget.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';

class Network extends StatelessWidget {
  Widget _buildTitle(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Network',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25),
          ),
        ],
      ),
    );
  }

  final List scheduleList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildTitle(context),
        automaticallyImplyLeading: false,
      ),
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  height: MediaQuery.of(context).size.height / 5,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List.generate(scheduleList.length, (index) {
                      return Center(
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          elevation: 4,
                          child: Container(
                            width: 250,
                            height: 100,
                            child: Center(
                              child: Text(
                                'Item $index',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                PreferredSize(
                  preferredSize: Size.fromHeight(50.0),
                  child: TabBar(
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(child: Text("Individual")),
                      Tab(child: Text("Team")),
                      Tab(child: Text("B/W Teams")),
                    ],
                    indicator: new BubbleTabIndicator(
                      indicatorHeight: 30.0,
                      indicatorColor: Theme.of(context).primaryColor,
                      tabBarIndicatorSize: TabBarIndicatorSize.tab,
                    ), // list of tabs
                  ),
                ),
                //TabBarView(children: [ImageList(),])
                Expanded(
                  child: TabBarView(
                    children: [
                      PlaceholderWidget(),
                      PlaceholderWidget(),
                      PlaceholderWidget(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
