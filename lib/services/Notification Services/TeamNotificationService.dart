import 'package:Runbhumi/models/models.dart';

import 'package:Runbhumi/utils/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeamsNotification {
  final String _id = Constants.prefs.getString('userId');
  final String _name = Constants.prefs.getString('name');
  final String _profileImage = Constants.prefs.getString('profileImage');

  createTeamNotification(String from, String to, Teams teamView) async {
    var db = FirebaseFirestore.instance
        .collection('users')
        .doc(to)
        .collection('notification');
    var doc = db.doc();
    String id = doc.id;
    doc.set(TeamNotification.newNotification(
            id, teamView.teamId, teamView.teamName, teamView.sport)
        .toJson());
    await FirebaseFirestore.instance
        .collection('teams')
        .doc(teamView.teamId)
        .update({
      'notificationPlayers': FieldValue.arrayUnion([from])
    });
  }

  acceptTeamInviteNotification(TeamNotification team) async {
    final Friends user = Friends.newFriend(_id, _name, _profileImage);
    await FirebaseFirestore.instance.collection('users').doc(_id).update({
      'teams': FieldValue.arrayUnion([team.teamId])
    });
    await FirebaseFirestore.instance.collection('team').doc('team').update({
      'players': FieldValue.arrayUnion([user.toJson()]),
      'playerId': FieldValue.arrayUnion([user.friendId])
    });
    declineTeamInviteNotification(team);
  }

  declineTeamInviteNotification(TeamNotification teams) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_id)
        .collection('notification')
        .doc(teams.notificationId)
        .delete();
    await FirebaseFirestore.instance
        .collection('teams')
        .doc(teams.teamId)
        .update({
      'notificationPlayers': FieldValue.arrayUnion([_id])
    });
  }
}
