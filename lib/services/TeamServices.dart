import 'package:Runbhumi/models/Friends.dart';
import 'package:Runbhumi/models/Teams.dart';
import 'package:Runbhumi/utils/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeamService {
  CollectionReference _teamCollectionReference =
      FirebaseFirestore.instance.collection('teams');

  final String userId = Constants.prefs.getString('userId');

  TeamView createNewTeam(String sport, String teamName, String bio) {
    var newDoc = _teamCollectionReference.doc();
    String id = newDoc.id;
    newDoc.set(Teams.newTeam(id, sport, teamName, bio).toJson());
    final TeamView team = TeamView.newTeam(id, sport, teamName, userId);
    return team;
  }

  getTeamsChatRoom() async {
    return FirebaseFirestore.instance
        .collection("teams")
        .where('playerId', arrayContains: userId)
        .snapshots();
  }

  void addMeInTeam(String teamId, Friends myprofile) {
    _teamCollectionReference.doc(teamId).update({
      'playerId': FieldValue.arrayUnion([myprofile.friendId]),
      'player': FieldValue.arrayUnion([myprofile.toJson()]),
    });
  }
}
