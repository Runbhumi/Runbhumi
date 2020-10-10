import 'package:Runbhumi/utils/Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Runbhumi/models/User.dart';
// import 'package:Runbhumi/utils/Constants.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

Future signInWithGoogle() async {
  await Firebase.initializeApp();

  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final UserCredential authResult =
      await _auth.signInWithCredential(credential);
  final User user = authResult.user;

  if (user != null) {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('UserId', isEqualTo: user.uid)
        .get();
    Constants.prefs.setString("userId", user.uid);
    final List<QueryDocumentSnapshot> documents = result.docs;
    if (documents.length == 0) {
      print('User Signed Up');
      String _username = generateusername(user.email);
      FirebaseFirestore.instance.collection('users').doc(user.uid).set(
          UserProfile.newuser(user.uid, _username, user.displayName,
                  user.photoURL, user.email)
              .toJson());
    }
  }
}

Future<void> signOutGoogle() async {
  await FirebaseAuth.instance.signOut();
  await googleSignIn.disconnect();
  print("User Signed Out");
}

// Future saveToSharedPreference(String uid, String username, String displayName,
//     String photoURL, String emailId) async {
//   await Constants.saveName(displayName);
//   await Constants.saveProfileImage(photoURL);
//   await Constants.saveUserEmail(emailId);
//   await Constants.saveUserId(uid);
//   await Constants.saveUserName(username);
// }
