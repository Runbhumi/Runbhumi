import 'package:Runbhumi/utils/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendServices {
  //FirebaseFirestore instance in order to connect with the database
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /*
  This method increments the friend count by the number specified in the parameter for the current user 
  Parameter: n: int
  Friend count of the user increases by n 
  */
  updateMyFriendCount(int n) {
    _db
        .collection('users')
        .doc(Constants.prefs.get('userId'))
        .set({'friendCount': FieldValue.increment(n)}, SetOptions(merge: true));
  }

  /*
  This method increments the friend count by the number specified in the parameter for the other user who has been added as a friend
  Parameter: n: int, id: unique user id, currUser: Id of the user who is being updated.
  */
  addUpdateMyFriendCount(int n, String id, String currUser) {
    print("Done");
    _db.collection('users').doc(currUser).update({
      'friendCount': FieldValue.increment(n),
      'friends': FieldValue.arrayUnion([id])
    });
  }

  /*
  This method removes a user as the current user's friend.
  Parameter: id: other user id, currUser: current user Id
  */
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

  /*
  This method increments the friend count by the number specified in the parameter for the current user 
  Parameter: uid: user id of the user we want to update n: int
  Friend count of the user increases by n 
  */
  updateFriendCount(String uid, int n) {
    _db
        .collection('users')
        .doc(uid)
        .set({'friendCount': FieldValue.increment(n)}, SetOptions(merge: true));
  }
  //End of the FriendServices
}
