import 'package:cloud_firestore/cloud_firestore.dart';

class Friends {
  String name;
  String profileImage;
  String friendId;

  Friends(this.friendId, this.name, this.profileImage);
  Map<String, dynamic> toJson() =>
      {'friendId': friendId, 'name': name, 'profileImage': profileImage};
  Friends.fromSnapshot(DocumentSnapshot snapshot)
      : profileImage = snapshot.data()['profileImage'],
        name = snapshot.data()['name'],
        friendId = snapshot.data()['friendId'];
}
