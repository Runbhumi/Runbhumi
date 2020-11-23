import 'package:Runbhumi/models/models.dart';
import 'package:Runbhumi/utils/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// --------- remeber to pass me when setting a new manager ------------------------------

class TeamService {
  CollectionReference _teamCollectionReference =
      FirebaseFirestore.instance.collection('teams');

  final Friends me = new Friends.newFriend(
      Constants.prefs.getString('userId'),
      Constants.prefs.getString('name'),
      Constants.prefs.getString('profileImage'));
  Teams createNewTeam(
      String sport, String teamName, String bio, String status) {
    var newDoc = _teamCollectionReference.doc();
    String id = newDoc.id;
    final Teams team = new Teams.newTeam(id, sport, teamName, bio, status);
    // newDoc.set(Teams.newTeam(id, sport, teamName, bio).toJson());
    newDoc.set(team.toJson());
    return team;
  }

  getAllTeamsFeed() async {
    return FirebaseFirestore.instance.collection("teams").snapshots();
  }

  getTeamsChatRoom() async {
    return FirebaseFirestore.instance
        .collection("teams")
        .where('playerId', arrayContains: me.friendId)
        .snapshots();
  }

  setManager(String previousManager, String newManager, TeamView team) async {
    if (previousManager != 'me') {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(previousManager)
          .collection('teams')
          .doc(team.teamId)
          .delete();
      await FirebaseFirestore.instance
          .collection('teams')
          .doc(team.teamId)
          .update({'manager': newManager});
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(newManager)
        .collection('teams')
        .doc(team.teamId)
        .set(team.toJson());
  }

  addMeInTeam(String teamId) async {
    await FirebaseFirestore.instance.collection('teams').doc(teamId).update({
      'playerId': FieldValue.arrayUnion([me.friendId]),
      'player': FieldValue.arrayUnion([me.toJson()]),
    });
  }

  removeMeFromTeam(String teamId) async {
    await FirebaseFirestore.instance.collection('teams').doc(teamId).update({
      'playerId': FieldValue.arrayRemove([me.friendId]),
      'player': FieldValue.arrayRemove([me.toJson()]),
    });
  }
}
