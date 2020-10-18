import 'package:Runbhumi/view/otherUserProfile.dart';
import 'package:flutter/material.dart';

class SingleFriendCard extends StatelessWidget {
  const SingleFriendCard({
    @required this.imageLink,
    @required this.name,
    @required this.userId,
    Key key,
  }) : super(key: key);
  final String imageLink;
  final String name;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        shadowColor: Color(0x44393e46),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        elevation: 20,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtherUserProfile(
                  userID: userId,
                ),
              ),
            );
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: ListTile(
                  leading: Container(
                    height: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.network(imageLink, height: 100),
                    ),
                  ),
                  title:
                      Text(name, style: Theme.of(context).textTheme.headline5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
