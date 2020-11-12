import 'package:Runbhumi/models/Friends.dart';
import 'package:Runbhumi/utils/Constants.dart';

class Teams {
  String teamId;
  String sport;
  String teamName;
  String captain;
  String viceCaptain;
  String image;
  String bio;
  List player;

  Teams(
      {this.teamId,
      this.sport,
      this.teamName,
      this.captain,
      this.viceCaptain,
      this.image,
      this.bio,
      this.player});

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
    this.image = "";
    this.bio = bio;
    this.player = [mapOfProfile];
  }
  Map<String, dynamic> toJson() => {
        'teamId': this.teamId,
        'sport': this.sport,
        'teamname': this.teamName,
        'captian': this.captain,
        'image': this.image,
        'bio': this.bio,
        'players': this.player
      };
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
