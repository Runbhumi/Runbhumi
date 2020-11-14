import 'package:cloud_firestore/cloud_firestore.dart';

class Friends {
  String name;
  String profileImage;
  String friendId;

  Friends.newFriend(String id, String name, String profileImage) {
    this.friendId = id;
    this.name = name;
    this.profileImage = profileImage;
  }
  Map<String, dynamic> toJson() =>
      {'id': friendId, 'name': name, 'profileImage': profileImage};

  Friends({this.friendId, this.name, this.profileImage});

  factory Friends.fromJson(QueryDocumentSnapshot data) {
    var parsedJson = data.data();
    return Friends(
        friendId: parsedJson['id'],
        name: parsedJson['name'],
        profileImage: parsedJson['profileImage']);
  }
}
