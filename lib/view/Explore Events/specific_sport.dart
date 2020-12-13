import 'package:Runbhumi/models/models.dart';
import 'package:Runbhumi/services/services.dart';
import 'package:Runbhumi/utils/Constants.dart';
import 'package:Runbhumi/utils/theme_config.dart';
import 'package:Runbhumi/widget/loader.dart';
import 'package:Runbhumi/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class SpecificSport extends StatefulWidget {
  final String sportName;
  SpecificSport({Key key, this.sportName}) : super(key: key);
  @override
  _SpecificSportState createState() => _SpecificSportState();
}

class _SpecificSportState extends State<SpecificSport> {
  Stream currentFeed;
  void initState() {
    super.initState();
    getUserInfoEvents();
    print(
        "------------------------${widget.sportName}--------------------------------------");
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
    EventService().getSpecificFeed(widget.sportName).then((snapshots) {
      setState(() {
        currentFeed = snapshots;
        // print("we got the data + ${currentFeed.toString()} ");
      });
    });
  }

  Widget feed({ThemeNotifier theme}) {
    return StreamBuilder(
      stream: currentFeed,
      builder: (context, asyncSnapshot) {
        print("specific sport loading");
        return asyncSnapshot.hasData
            ? asyncSnapshot.data.documents.length > 0
                ? ListView.builder(
                    itemCount: asyncSnapshot.data.documents.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      Events data = new Events.fromJson(
                          asyncSnapshot.data.documents[index]);
                      String sportIcon;
                      // IconData sportIcon;
                      switch (widget.sportName) {
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
                      bool registrationCondition = data.playersId
                          .contains(Constants.prefs.getString('userId'));
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
                                          DateFormat('E-dd/MM-')
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
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    // trailing: Text(DateFormat('E\ndd/MM\nkk:mm')
                                    //     .format(data.dateTime)
                                    //     .toString()),
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
  Widget build(BuildContext context) {
    final ThemeNotifier theme = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: buildTitle(context, widget.sportName),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
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
    );
  }
}
