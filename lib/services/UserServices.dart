import 'package:Runbhumi/models/User.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  // updateEventCount(int n) {
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(GetStorage().get('userId'))
  //       .set({'eventCount': FieldValue.increment(n)}, SetOptions(merge: true));
  // }

  updateEventTokens(int n) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(GetStorage().read('userId') as String)
        .set({'eventTokens': FieldValue.increment(n)}, SetOptions(merge: true));
  }

  // updateMyFriendCount(int n) {
  //   _db
  //       .collection('users')
  //       .doc(GetStorage().get('userId'))
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
        .doc(GetStorage().read('userId') as String)
        .set({'teamsCount': FieldValue.increment(n)}, SetOptions(merge: true));
  }

  updateEventCount(int n, String userId) {
    _db
        .collection('users')
        .doc(userId)
        .set({'eventCount': FieldValue.increment(n)}, SetOptions(merge: true));
  }

  Future<UserProfile> getUserProfile(String id) async {
    var snap = await _db.collection('users').doc(id).get();
    return UserProfile.fromMap(snap.data as Map);
  }

  getFriends() async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(GetStorage().read('userId'))
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
        .doc(GetStorage().read('userId'))
        .collection("teams")
        .where('sport', isEqualTo: sport)
        .snapshots();
  }
}

//data['friends'].contains(data['userId'])
