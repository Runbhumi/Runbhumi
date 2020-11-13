import 'package:Runbhumi/models/Friends.dart';
import 'package:Runbhumi/models/Teams.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeamService {
  CollectionReference _teamCollectionReference =
      FirebaseFirestore.instance.collection('teams');

  void createNewTeam(String sport, String teamName, String bio) {
    var newDoc = _teamCollectionReference.doc();
    String id = newDoc.id;
    newDoc.set(Teams.newTeam(id, sport, teamName, bio).toJson());
  }

  void addMeInTeam(String id, Friends myprofile) {
    _teamCollectionReference.doc(id).update({});
  }
}
