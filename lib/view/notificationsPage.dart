import 'package:Runbhumi/utils/Constants.dart';
import 'package:Runbhumi/view/otherUserProfile.dart';
import 'package:Runbhumi/widget/widgets.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  Widget _buildTitle(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Notifications',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildTitle(context),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Text(
              'Friend requests',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Container(
            height: 200,
            child: ListView.builder(
              //notification count
              itemCount: 2,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4.0, vertical: 4.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OtherUserProfile(
                                  userID: Constants.prefs.getString('userId'),
                                  // userID: asyncSnapshot.data.documents[index]
                                  //     .get('userId'),
                                )),
                      );
                    },
                    child: Card(
                      shadowColor: Color(0x44393e46),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      elevation: 20,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              child: Image(
                                height: 100,
                                //image link
                                image: NetworkImage(
                                  "https://pbs.twimg.com/profile_images/1286371379768516608/KKBFYV_t.jpg",
                                ),
                              ),
                            ),
                            //name
                            Text(
                              "Hayat Tamboli",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                            Row(
                              children: [
                                SmallButton(
                                  myText: "accept",
                                  myColor: Theme.of(context).primaryColor,
                                  //aceept friend funtionality
                                  onPressed: () {},
                                ),
                                SmallButton(
                                  myText: "decline",
                                  myColor: Theme.of(context).accentColor,
                                  //decline funtionality
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Text(
              'Team join requests',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Expanded(child: PlaceholderWidget()),
        ],
      ),
    );
  }
}
