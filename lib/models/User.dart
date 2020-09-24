class UserProfile extends Info {
  final String userId;
  List<String> friendsId;
  List<String> teamId;
  List<String> eventsID;
  UserProfile({this.userId});
}

class Info {
  String username;
  String name;
  DateTime dob;
  String profileImage;
  String location;
  String address;
  String phoneNumber;
}

class Nortifications {
  // This is a incomplete class mohit will decide on this !
}
