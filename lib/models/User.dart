// import 'package:Runbhumi/utils/Constants.dart';

class UserProfile {
  String userId;
  String username;
  String name;
  String profileImage;
  String location;
  String phoneNumber;
  String emailId;
  List<String> friendsId;
  List<String> teamId;
  List<String> eventsId;
  List<String> notificationId;

  UserProfile({
    this.userId,
    this.username,
    this.name,
    this.profileImage,
    this.location,
    this.phoneNumber,
    this.emailId,
    this.friendsId,
    this.teamId,
    this.eventsId,
    this.notificationId,
  });

  UserProfile.newuser(userId, username, name, profileImage, emailId) {
    this.userId = userId;
    this.username = username;
    this.name = name;
    this.profileImage = profileImage;
    this.location = '';
    this.phoneNumber = '';
    this.emailId = emailId;
    this.friendsId = [];
    this.teamId = [];
    this.eventsId = [];
    this.notificationId = [];
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'username': username,
        'name': name,
        'profileImage': profileImage,
        'location': location,
        'phoneNumber': phoneNumber,
        'emailId': emailId,
        'friendsId': friendsId,
        'teamId': teamId,
        'eventsId': eventsId,
        'notificationId': notificationId
      };

  factory UserProfile.fromMap(Map data) {
    return UserProfile(
        userId: data['userId'] ?? "",
        username: data['username'] ?? "",
        name: data['name'] ?? "",
        profileImage: data['profileImage'] ?? "",
        location: data['location'] ?? "",
        phoneNumber: data['phoneNumber'] ?? "",
        emailId: data['emailId'] ?? "",
        friendsId: data['friendsId'] ?? [],
        teamId: data['teamId'] ?? [],
        eventsId: data['eventsId'] ?? [],
        notificationId: data['notificationId'] ?? []);
  }
}

// Notifications can be taken as a seperate calss
// https://medium.com/fabcoding/get-current-user-location-in-flutter-57e202bad6db for geolocation capture

String generateusername(String email) {
  String result = email.replaceAll(new RegExp(r'@.+'), "");
  result = result.replaceAll(new RegExp(r'\\W+'), " ");
  return result;
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
