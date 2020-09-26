class UserProfile {
  String userId;
  String username;
  String name;
  String profileImage;
  String location;
  String phoneNumber;
  List<String> friendsId;
  List<String> teamId;
  List<String> eventsId;
  List<String> notificationId;

  UserProfile.newuser(userId, username, name, profileImage, phoneNumber) {
    this.userId = userId;
    this.username = username;
    this.name = name;
    this.profileImage = profileImage;
    this.location = '';
    this.phoneNumber = '';
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
        'friendsId': friendsId,
        'teamId': teamId,
        'eventsId': eventsId,
        'notificationId': notificationId
      };
}

// Notifications can be taken as a seperate calss
// https://medium.com/fabcoding/get-current-user-location-in-flutter-57e202bad6db for geolocation capture
