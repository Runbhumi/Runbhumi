import 'package:Runbhumi/models/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<UserProfile> getUserProfile(String id) async {
    var snap = await _db.collection('users').doc(id).get();
    return UserProfile.fromMap(snap.data as Map);
  }

  Stream<UserProfile> streamUserProfile(String id) {
    return _db
        .collection('users')
        .doc(id)
        .snapshots()
        .map((snap) => UserProfile.fromMap(snap.data as Map));
  }
}
