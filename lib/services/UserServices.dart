import 'package:Runbhumi/models/User.dart';
import 'package:Runbhumi/utils/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  updateEventCount(int n) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(Constants.prefs.get('userId'))
        .set({'eventCount': FieldValue.increment(n)}, SetOptions(merge: true));
  }

  // updateMyFriendCount(int n) {
  //   _db
  //       .collection('users')
  //       .doc(Constants.prefs.get('userId'))
  //       .set({'friendCount': FieldValue.increment(n)}, SetOptions(merge: true));
  // }

  // addUpdateMyFriendCount(int n, String id, String currUser) {
  //   print("Done");
  //   _db.collection('users').doc(currUser).update({
  //     'friendCount': FieldValue.increment(n),
  //     'friends': FieldValue.arrayUnion([id])
  //   });
  // }

  // removeFriend(int n,String id,String currUser){

  // }

  // updateFriendCount(String uid, int n) {
  //   _db
  //       .collection('users')
  //       .doc(uid)
  //       .set({'friendCount': FieldValue.increment(n)}, SetOptions(merge: true));
  // }

  updateTeamsCount(int n) {
    _db
        .collection('users')
        .doc(Constants.prefs.get('userId'))
        .set({'teamsCount': FieldValue.increment(n)}, SetOptions(merge: true));
  }

  Future<UserProfile> getUserProfile(String id) async {
    var snap = await _db.collection('users').doc(id).get();
    return UserProfile.fromMap(snap.data as Map);
  }

  getFriends() async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(Constants.prefs.getString('userId'))
        .collection("friends")
        .snapshots();
  }

  Stream<UserProfile> streamUserProfile(String id) {
    return _db
        .collection('users')
        .doc(id)
        .snapshots()
        .map((snap) => UserProfile.fromMap(snap.data as Map));
  }

  getTeams(String sport) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(Constants.prefs.getString('userId'))
        .collection("teams")
        .where('sport', isEqualTo: sport)
        .snapshots();
  }
}

//data['friends'].contains(data['userId'])
