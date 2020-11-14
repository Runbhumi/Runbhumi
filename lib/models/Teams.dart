import 'package:Runbhumi/models/Friends.dart';
import 'package:Runbhumi/utils/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Teams {
  String teamId;
  String sport;
  String teamName;
  String captain;
  String manager;
  String image;
  String bio;
  List player;
  List playerId;

  Teams(
      {this.teamId,
      this.sport,
      this.teamName,
      this.captain,
      this.manager,
      this.image,
      this.bio,
      this.player,
      this.playerId});

  Teams.newTeam(String teamId, String sport, String teamName, String bio) {
    final Friends myprofile = new Friends.newFriend(
        Constants.prefs.getString('userId'),
        Constants.prefs.getString('name'),
        Constants.prefs.getString('profileImage'));

    final mapOfProfile = myprofile.toJson();
    this.teamId = teamId;
    this.sport = sport;
    this.teamName = teamName;
    this.captain = Constants.prefs.getString('userId');
    this.manager = myprofile.friendId;
    this.image = "";
    this.bio = bio;
    this.player = [mapOfProfile];
    this.playerId = [myprofile.friendId];
  }
  Map<String, dynamic> toJson() => {
        'teamId': this.teamId,
        'sport': this.sport,
        'teamname': this.teamName,
        'captian': this.captain,
        'manager': this.manager,
        'image': this.image,
        'bio': this.bio,
        'players': this.player,
        'playerId': this.playerId
      };
  factory Teams.fromJson(QueryDocumentSnapshot data) {
    var parsedJson = data.data();
    return Teams(
        teamId: parsedJson['teamId'],
        sport: parsedJson['sport'],
        teamName: parsedJson['teamname'],
        captain: parsedJson['captian'],
        bio: parsedJson['bio'],
        manager: parsedJson['manager'],
        image: parsedJson['image'],
        player: parsedJson['players'],
        playerId: parsedJson['playerId']);
  }
}

class TeamView {
  String teamId;
  String sport;
  String teamName;
  String manager;

  TeamView({this.teamId, this.sport, this.teamName, this.manager});

  TeamView.newTeam(
      String teamId, String sport, String teamName, String teamManager) {
    this.teamId = teamId;
    this.sport = sport;
    this.teamName = teamName;
    this.manager = teamManager;
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';

// class Teams {
//   final teamid;
//   List<String> playerId;
//   String teamName;
//   String image;
//   String sport;
//   String description;
//   Teams({this.teamid, this.captianId});
// }

// class TeamView {
//   String teamName;
//   String image;
//   String teamId;
//   TeamView(this.teamId, this.teamName, this.image);
//   Map<String, dynamic> toJson() =>
//       {'teamId': teamId, 'name': teamName, 'image': image};
//   TeamView.fromSnapshot(DocumentSnapshot snapshot)
//       : image = snapshot.data()['image'],
//         teamName = snapshot.data()['teamName'],
//         teamId = snapshot.data()['teamId'];
// }
