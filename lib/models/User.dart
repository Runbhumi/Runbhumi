class UserProfile {
  String userId;
  String username;
  String name;
  String profileImage;
  String location;
  String address;
  String phoneNumber;
  List<String> friendsId;
  List<String> teamId;
  List<String> eventsId;

  UserProfile.newuser(userId, username, name, profileImage, phoneNumber) {
    this.userId = userId;
    this.username = username;
    this.name = name;
    this.profileImage = profileImage;
    this.location = '';
    this.address = '';
    this.phoneNumber = '';
    this.friendsId = [];
    this.teamId = [];
    this.eventsId = [];
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'username': username,
        'name': name,
        'profileImage': profileImage,
        'location': location,
        'address': address,
        'phoneNumber': phoneNumber,
        'friendsId': friendsId,
        'teamId': teamId,
        'eventsId': eventsId
      };
}

// Notifications can be taken as a seperate calss
