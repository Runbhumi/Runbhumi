import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  String userId;
  String username;
  String name;
  String profileImage;
  String location;
  String age;
  String bio;
  int friendCount;
  int eventCount;
  int teamsCount;
  Map<String, dynamic> phoneNumber;
  List<String> userSearchIndex;
  String emailId;
  List friends;

  UserProfile(
      {this.userId,
      this.username,
      this.name,
      this.profileImage,
      this.location,
      this.phoneNumber,
      this.emailId,
      this.bio,
      this.age,
      this.friends});

  UserProfile.loadUser(this.userId, this.username, this.name, this.profileImage,
      this.location, this.phoneNumber, this.emailId, this.bio, this.age);

  UserProfile.newuser(userId, username, name, profileImage, emailId) {
    this.userId = userId;
    this.username = username;
    this.name = name;
    this.profileImage = profileImage;
    this.location = '';
    this.phoneNumber = {'show': false, 'ph': ""};
    this.emailId = emailId;
    this.bio =
        'I couldn’t find the sports car of my dreams, so I built it myself.';
    this.age = '';
    this.friendCount = 0;
    this.teamsCount = 0;
    this.eventCount = 0;
    this.friends = [];
  }

  UserProfile.miniView(String userId, String name, String profileImage) {
    this.userId = userId;
    this.name = name;
    this.profileImage = profileImage;
  }

  Map<String, dynamic> miniJson() =>
      {'userId': userId, 'name': name, 'profileImage': profileImage};

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'username': username,
        'name': name,
        'profileImage': profileImage,
        'location': location,
        'phoneNumber': phoneNumber,
        'emailId': emailId,
        'bio': bio,
        'age': age,
        'friendCount': friendCount,
        'teamsCount': teamsCount,
        'eventCount': eventCount,
        "userSearchParam": setSearchParam(username),
        "friends": friends,
        "notification": [],
      };

  factory UserProfile.fromMap(Map data) {
    return UserProfile(
        userId: data['userId'] ?? "",
        username: data['username'] ?? "",
        name: data['name'] ?? "",
        profileImage: data['profileImage'] ?? "",
        location: data['location'] ?? "",
        phoneNumber: data['phoneNumber'] ?? "",
        emailId: data['emailId'] ?? "");
  }

  factory UserProfile.fromJson(QueryDocumentSnapshot snapshot) {
    var data = snapshot.data();
    return UserProfile(
        userId: data['userId'],
        username: data['username'],
        name: data['name'],
        profileImage: data['profileImage'],
        location: data['location'],
        phoneNumber: data['phoneNumber'],
        emailId: data['emailId']);
  }
}

// Notifications can be taken as a seperate calss
// https://medium.com/fabcoding/get-current-user-location-in-flutter-57e202bad6db for geolocation capture

String generateusername(String email) {
  String result = email.replaceAll(new RegExp(r'@.+'), "");
  result = result.replaceAll(new RegExp(r'\\W+'), " ");
  return result;
}

setSearchParam(String username) {
  List<String> userSearchList = List();
  String temp = "";
  for (int i = 0; i < username.length; i++) {
    temp = temp + username[i];
    userSearchList.add(temp);
  }
  return userSearchList;
}
// getImageURL() async {
//   final String profileImage = await Constants.getProfileImage();
//   return profileImage;
// }

// getName() async {
//   final String name = await Constants.getName();
//   return name;
// }

// getUserName() async {
//   final String userName = await Constants.getUserName();
//   return userName;
// }

// getUserLocation() async {
//   final String location = await Constants.getUserLocation();
//   return location;
// }
