import 'package:Runbhumi/models/User.dart';
import 'package:Runbhumi/utils/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  updateEventCount() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(Constants.prefs.get('userId'))
        .set({'eventCount': FieldValue.increment(1)}, SetOptions(merge: true));
  }

  updateMyFriendCount() {
    _db
        .collection('users')
        .doc(Constants.prefs.get('userId'))
        .set({'friendCount': FieldValue.increment(1)}, SetOptions(merge: true));
  }

  updateFriendCount(String uid) {
    _db
        .collection('users')
        .doc(uid)
        .set({'friendCount': FieldValue.increment(1)}, SetOptions(merge: true));
  }

  updateTeamsCount() {
    _db
        .collection('users')
        .doc(Constants.prefs.get('userId'))
        .set({'teamsCount': FieldValue.increment(1)}, SetOptions(merge: true));
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
}
