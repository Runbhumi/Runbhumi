import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingServices {
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  getTokenz() async {
    String token = await _firebaseMessaging.getToken();
    print(token);
    return token;
  }
}
