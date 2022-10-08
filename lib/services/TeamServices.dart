import 'package:runbhumi/models/models.dart';
import 'package:runbhumi/models/verificationApp.dart';
import 'package:runbhumi/services/services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';

// --------- remeber to pass me when setting a new manager ------------------------------

class TeamService {
  CollectionReference _teamCollectionReference =
      FirebaseFirestore.instance.collection('teams');

  final Friends me = new Friends.newFriend(
    GetStorage().read('userId')!,
    GetStorage().read('name')!,
    GetStorage().read('profileImage')!,
  );
  Teams createNewTeam(
      String sport, String teamName, String bio, String status) {
    var newDoc = _teamCollectionReference.doc();
    String id = newDoc.id;
    final Teams team = new Teams.newTeam(id, sport, teamName, bio, status);
    final TeamView teamsView = new TeamView.newTeam(id, sport, teamName);
    // newDoc.set(Teams.newTeam(id, sport, teamName, bio).toJson());
    newDoc.set(team.toJson());
    setManager("me", me.friendId!, teamsView);
    return team;
  }

  getAllTeamsFeed() async {
    return FirebaseFirestore.instance.collection("teams").snapshots();
  }

  getSpecificCategoryFeed(String sportName) async {
    return FirebaseFirestore.instance
        .collection("teams")
        .where('sport', isEqualTo: sportName)
        .snapshots();
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

  setCaptain(String newCaptain, String teamId, String nameOfnewCap) async {
    await FirebaseFirestore.instance
        .collection('teams')
        .doc(teamId)
        .update({'captain': newCaptain});
    CustomMessageServices().captainChangeMessage(teamId, nameOfnewCap);
  }

  addMeInTeam(String teamId) async {
    await FirebaseFirestore.instance.collection('teams').doc(teamId).update({
      'playerId': FieldValue.arrayUnion([me.friendId]),
      'players': FieldValue.arrayUnion([me.toJson()]),
    });
    CustomMessageServices()
        .sendTeamNewMemberJoinMessage(teamId, GetStorage().read('name')!);
  }

  removeMeFromTeam(String teamId) async {
    await FirebaseFirestore.instance.collection('teams').doc(teamId).update({
      'playerId': FieldValue.arrayRemove([me.friendId]),
      'players': FieldValue.arrayRemove([me.toJson()]),
    });
    CustomMessageServices()
        .sendTeamLeaveMemberMessage(teamId, GetStorage().read('name')!);
  }

  removePlayerFromTeam(
    String teamId,
    String userId,
    String userName,
    String profilePic,
  ) async {
    Friends player = new Friends.newFriend(userId, userName, profilePic);
    await FirebaseFirestore.instance.collection('teams').doc(teamId).update({
      'playerId': FieldValue.arrayRemove([player.friendId]),
      'players': FieldValue.arrayRemove([player.toJson()]),
    });
    CustomMessageServices().sendTeamLeaveMemberMessage(teamId, userName);
  }

  deleteTeam(String manager, String teamId) async {
    if (manager == GetStorage().read('userId')) {
      await FirebaseFirestore.instance.collection('teams').doc(teamId).delete();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(manager)
          .collection('teams')
          .doc(teamId)
          .delete();
    }
  }

  makeTeamClosed(String teamId) async {
    await FirebaseFirestore.instance.collection('teams').doc(teamId).update({
      'status': 'closed',
    });
  }

  makeTeamPublic(String teamId) async {
    await FirebaseFirestore.instance.collection('teams').doc(teamId).update({
      'status': 'public',
    });
  }

  makeTeamPrivate(String teamId) async {
    await FirebaseFirestore.instance.collection('teams').doc(teamId).update({
      'status': 'private',
    });
  }

  sendVerificationApplication(
      String teamId, String sport, String teamName) async {
    var newDoc =
        FirebaseFirestore.instance.collection('verificationApplications').doc();
    String id = newDoc.id;
    final VerificationApplication newApp =
        VerificationApplication.newApplication(teamId, sport, teamName, id);
    newDoc.set(newApp.toJson());

    await FirebaseFirestore.instance
        .collection('teams')
        .doc(teamId)
        .update({'verified': 'P'});
  }
}
