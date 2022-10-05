import 'package:cloud_firestore/cloud_firestore.dart';

class VerificationApplication {
  //All the details needed for the verification application to be sent
  //Id of the team
  String? teamId;
  //Sport which the team represents
  String? sport;
  //Name of the team
  String? teamName;
  //application Id
  String? applicationId;

  /*
  Constructor for making a new verification application.
  Parameters: teamId (String), teamName (String), applicationId (String)
  */

  VerificationApplication(
      {this.teamId, this.sport, this.teamName, this.applicationId});

  //Assigning the VerificationApplication class variables
  VerificationApplication.newApplication(
      String teamId, String sport, String teamName, String applicationId) {
    this.teamId = teamId;
    this.sport = sport;
    this.teamName = teamName;
    this.applicationId = applicationId;
  }
//Converting to Json file to sent it to the backend
  Map<String, dynamic> toJson() => {
        'teamId': this.teamId,
        'sport': this.sport,
        'teamName': this.teamName,
      };

  // takes a query snapshot as a input and returns a the VerificationApplication class
  factory VerificationApplication.fromJson(QueryDocumentSnapshot data) {
    var parsedJson = data.data() as Map;
    return VerificationApplication(
        teamId: parsedJson['teamId'],
        sport: parsedJson['sport'],
        teamName: parsedJson['teamName'],
        applicationId: parsedJson['applicationId']);
  }
}
