class UserProfile {
  String userId;
  String username;
  String name;
  String profileImage;
  String location;
  String age;
  String bio;
  Map<String, bool> phoneNumber;
  String emailId;

  UserProfile(
      {this.userId,
      this.username,
      this.name,
      this.profileImage,
      this.location,
      this.phoneNumber,
      this.emailId,
      this.bio,
      this.age});

  UserProfile.loadUser(this.userId, this.username, this.name, this.profileImage,
      this.location, this.phoneNumber, this.emailId, this.bio, this.age);

  UserProfile.newuser(userId, username, name, profileImage, emailId) {
    this.userId = userId;
    this.username = username;
    this.name = name;
    this.profileImage = profileImage;
    this.location = '';
    this.phoneNumber = {};
    this.emailId = emailId;
    this.bio =
        'I couldn’t find the sports car of my dreams, so I built it myself.';
    this.age = '';
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'username': username,
        'name': name,
        'profileImage': profileImage,
        'location': location,
        'phoneNumber': phoneNumber,
        'emailId': emailId,
        'bio': bio,
        'age': age
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
