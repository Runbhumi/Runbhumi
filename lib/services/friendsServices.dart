import 'package:Runbhumi/utils/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendServices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  updateMyFriendCount(int n) {
    _db
        .collection('users')
        .doc(Constants.prefs.get('userId'))
        .set({'friendCount': FieldValue.increment(n)}, SetOptions(merge: true));
  }

  addUpdateMyFriendCount(int n, String id, String currUser) {
    print("Done");
    _db.collection('users').doc(currUser).update({
      'friendCount': FieldValue.increment(n),
      'friends': FieldValue.arrayUnion([id])
    });
  }

  removeFriend(String id, String currUser) {
    _db
        .collection('users')
        .doc(id)
        .collection('friends')
        .doc(currUser)
        .delete();
    _db
        .collection('users')
        .doc(currUser)
        .collection('friends')
        .doc(id)
        .delete();

    _db.collection('users').doc(currUser).update({
      'friendCount': FieldValue.increment(-1),
      'friends': FieldValue.arrayRemove([id])
    });

    _db.collection('users').doc(id).update({
      'friendCount': FieldValue.increment(-1),
      'friends': FieldValue.arrayRemove([currUser])
    });
  }

  updateFriendCount(String uid, int n) {
    _db
        .collection('users')
        .doc(uid)
        .set({'friendCount': FieldValue.increment(n)}, SetOptions(merge: true));
  }
}
