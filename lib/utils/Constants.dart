import 'package:shared_preferences/shared_preferences.dart';

class Constants {
  static SharedPreferences prefs;
  static String sharedPreferenceUserLoggedInKey = "ISLOGGEDIN";
  static String userId;
  static String username;
  static String name;
  static String profileImage;
  static String location;
  static String emailId;

  // this is to save login status of a user to Shared Preference
  static Future<bool> saveUserLoggedInSharedPreference(
      bool isUserLoggedIn) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(
        sharedPreferenceUserLoggedInKey, isUserLoggedIn);
  }

  // this is to get login status of a user from Shared Preference
  static Future<bool> getUserLoggedInSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(sharedPreferenceUserLoggedInKey);
  }

  // this is to get name of a user from Shared Preference
  static Future<String> getName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(name);
  }

  // this is to save the name of a user in Shared Preferences
  static Future<bool> saveName(String usersname) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(name, usersname);
  }

  // this is to get userId of a user from Shared Preferences
  static Future<String> getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(name);
  }

  // this is to save the userId of a user in Shared Preferences
  static Future<bool> saveUserId(String uid) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(userId, uid);
  }

  // this is to save the name of a user in Shared Preferences
  static Future<bool> saveUserName(String usersName) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(username, usersName);
  }

  // this is to get userId of a user from Shared Preferences
  static Future<String> getUserName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(username);
  }

  // this is to save the profile image of a user  in Shared Preferences
  static Future<bool> saveProfileImage(String profileimage) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(profileImage, profileimage);
  }

  // this is to get userId of a user from Shared Preferences
  static Future<String> getProfileImage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(profileImage);
  }

  // this is to save the Location of a user in Shared Preferences
  static Future<bool> saveUserLocation(String userLocation) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(location, userLocation);
  }

  // this is to get Location of a user from Shared Preferences
  static Future<String> getUserLocation() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(location);
  }

  // this is to save the email of a user in Shared Preferences
  static Future<bool> saveUserEmail(String email) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(emailId, email);
  }

  // this is to get email of a user from Shared Preferences
  static Future<String> getUserEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(emailId);
  }
}
