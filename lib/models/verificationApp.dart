import 'package:cloud_firestore/cloud_firestore.dart';

class VerificationApplication {
  String teamId;
  String sport;
  String teamName;
  String applicationId;
  //String manager;

  VerificationApplication(
      {this.teamId,
      this.sport,
      this.teamName,
      this.applicationId}); //this.manager

  VerificationApplication.newApplication(
      String teamId, String sport, String teamName, String applicationId) {
    this.teamId = teamId;
    this.sport = sport;
    this.teamName = teamName;
    this.applicationId = applicationId;
    // this.manager = teamManager; String teamManager
  }
  Map<String, dynamic> toJson() => {
        'teamId': this.teamId,
        'sport': this.sport,
        'teamName': this.teamName,
      };

  factory VerificationApplication.fromJson(QueryDocumentSnapshot data) {
    var parsedJson = data.data();
    return VerificationApplication(
        teamId: parsedJson['teamId'],
        sport: parsedJson['sport'],
        teamName: parsedJson['teamName'],
        applicationId: parsedJson['applicationId']);
  }
  // 'manager': this.manager
}
