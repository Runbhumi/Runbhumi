import 'package:Runbhumi/models/models.dart';
import 'package:Runbhumi/utils/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// there can be 3 status for the verified team

// n - if its not done
// p - its pending
// c - completed now can not be done

class Teams {
  String? teamId;
  String? sport;
  String? teamName;
  String? captain;
  String? manager;
  String? image;
  String? bio;
  List? player;
  List? playerId;
  List? notificationPlayers;
  String? status;
  String? verified;

  Teams({
    this.teamId,
    this.sport,
    this.teamName,
    this.captain,
    this.manager,
    this.image,
    this.bio,
    this.player,
    this.playerId,
    this.notificationPlayers,
    this.status,
    this.verified,
  });

  Teams.newTeam(
      String teamId, String sport, String teamName, String bio, String status) {
    final Friends myprofile = new Friends.newFriend(
      Constants.prefs.getString('userId')!,
      Constants.prefs.getString('name')!,
      Constants.prefs.getString('profileImage')!,
    );

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
    this.notificationPlayers = [];
    this.status = status;
    this.verified = 'N';
  }
  Map<String, dynamic> toJson() => {
        'teamId': this.teamId,
        'sport': this.sport,
        'teamname': this.teamName,
        'captain': this.captain,
        'manager': this.manager,
        'image': this.image,
        'bio': this.bio,
        'players': this.player,
        "teamSearchParam": setSearchParam(teamName!),
        'playerId': this.playerId,
        'notificationPlayers': this.notificationPlayers,
        'status': this.status,
        'verified': this.verified
      };
  factory Teams.fromJson(QueryDocumentSnapshot data) {
    var parsedJson = data.data() as Map;
    return Teams(
        teamId: parsedJson['teamId'],
        sport: parsedJson['sport'],
        teamName: parsedJson['teamname'],
        captain: parsedJson['captain'],
        bio: parsedJson['bio'],
        manager: parsedJson['manager'],
        image: parsedJson['image'],
        player: parsedJson['players'],
        playerId: parsedJson['playerId'],
        notificationPlayers: parsedJson['notificationPlayers'],
        status: parsedJson['status'],
        verified: parsedJson['verified']);
  }
}

class TeamView {
  String? teamId;
  String? sport;
  String? teamName;
  //String manager;

  TeamView({this.teamId, this.sport, this.teamName}); //this.manager

  TeamView.newTeam(
    String teamId,
    String sport,
    String teamName,
  ) {
    this.teamId = teamId;
    this.sport = sport;
    this.teamName = teamName;
    // this.manager = teamManager; String teamManager
  }
  Map<String, dynamic> toJson() => {
        'teamId': this.teamId,
        'sport': this.sport,
        'teamName': this.teamName,
      };

  factory TeamView.fromJson(QueryDocumentSnapshot data) {
    var parsedJson = data.data() as Map;
    return TeamView(
      teamId: parsedJson['teamId'],
      sport: parsedJson['sport'],
      teamName: parsedJson['teamName'],
    );
  }
  // 'manager': this.manager
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

class TeamChallengeNotification {
  String? teamId;
  String? manager;
  String? teamName;
  TeamChallengeNotification({this.teamId, this.manager, this.teamName});

  TeamChallengeNotification.newTeam(
    String teamId,
    String manager,
    String teamName,
  ) {
    this.teamId = teamId;
    this.manager = manager;
    this.teamName = teamName;
    // this.manager = teamManager; String teamManager
  }
}
