import 'package:Runbhumi/view/placeholder_widget.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';

class Network extends StatefulWidget {
  @override
  _NetworkState createState() => _NetworkState();
}

class _NetworkState extends State<Network> {
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
    final List scheduleList = ["hayat", "manas", "rohan", "mohit"];
    return Scaffold(
      appBar: AppBar(
        title: _buildTitle(context),
        automaticallyImplyLeading: false,
      ),
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          body: Column(
            children: <Widget>[
              Text(
                'Schedule',
                style: Theme.of(context).textTheme.headline6,
              ),
              //schedule
              Schedule(scheduleList: scheduleList),
              SizedBox(
                height: 10,
              ),
              Text(
                'Chats',
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(
                height: 10,
              ),
              ChatsTabs(),
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
    );
  }
}

class Schedule extends StatelessWidget {
  const Schedule({
    Key key,
    @required this.scheduleList,
  }) : super(key: key);

  final List scheduleList;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 5,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              elevation: 2,
              child: Container(
                width: 250,
                height: 100,
                child: Center(
                  child: Text(
                    scheduleList[index],
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: scheduleList.length,
      ),
    );
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
