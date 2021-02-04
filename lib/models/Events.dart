import 'package:Runbhumi/utils/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Events {
  // name of the event
  String eventName;

  // unique id of the event
  String eventId;

  // unique user id of the creator
  String creatorId;

  // name of the creator
  String creatorName;

  // location of the event
  String location;

  // name of the sport for the event
  String sportName;

  // description of the event given by the user
  String description;

  // list of all the participants userid
  // EXCLUDING THE CREATOR
  List<dynamic> playersId;

  // list of all the participants userid
  // INCLUDING THE CREATOR
  List<dynamic> participants;

  // list which includes all the info of all the players
  List playerInfo;

  // List of al the team id for team events
  String teamId;

  // List of the team Info for the team related events
  List teamInfo;

  // List of all the ids who are invited or are send any kind of invitation from the creator
  List notification;

  // contains the date and time of the event
  DateTime dateTime;

  // members can deonote the max number of teams
  int maxMembers;

  // contains the info which distinguish a team event and a individual event
  String status;

  // contains the type of the event that is 1 -public , 2- private , 3- closed
  int type;

  //Contains teamName
  String teamName;

  //Checks if this event is paid or not
  String paid;

  // this is a default constructor for event class
  Events(
      {this.eventId,
      this.eventName,
      this.creatorId,
      this.creatorName,
      this.location,
      this.sportName,
      this.description,
      this.playersId,
      this.participants,
      this.playerInfo,
      this.teamInfo,
      this.dateTime,
      this.maxMembers,
      this.status,
      this.notification,
      this.type,
      this.teamId,
      this.teamName,
      this.paid});

  //  this is a constructor which can we used to initialise the values of a class
  // when a new class is initialised .

  Events.newEvent(
      String eventId,
      String eventName,
      String location,
      String sportName,
      String description,
      DateTime dateTime,
      int maxMembers,
      String status,
      int type,
      String paid) {
    this.eventId = eventId;
    this.eventName = eventName;
    this.creatorId = Constants.prefs.getString('userId');
    this.creatorName = Constants.prefs.getString('name');
    this.location = location;
    this.sportName = sportName;
    this.playersId = [];
    this.description = description;
    this.dateTime = dateTime;
    this.maxMembers = maxMembers;
    this.type = type;
    this.participants = [Constants.prefs.getString('userId')];
    this.status = status;
    this.notification = [];
    this.paid = paid;
  }
//teamName and teamId
  Events.miniEvent(
      {this.eventId,
      this.eventName,
      this.location,
      this.dateTime,
      this.sportName,
      this.creatorId,
      this.creatorName,
      this.type,
      this.status,
      this.playersId,
      this.paid});

  Events.miniView(
      String eventId,
      String eventName,
      String sportName,
      String location,
      DateTime dateTime,
      String status,
      String creatorId,
      String creatorName,
      int type,
      List<dynamic> playersId,
      String paid) {
    this.eventId = eventId;
    this.eventName = eventName;
    this.location = location;
    this.dateTime = dateTime;
    this.sportName = sportName;
    this.status = status;
    this.creatorId = creatorId;
    this.creatorName = creatorName;
    this.type = type;
    this.playersId = playersId;
    this.paid = paid;
  }

  Events.miniTeamView(
      String eventId,
      String eventName,
      String sportName,
      String location,
      DateTime dateTime,
      String status,
      String creatorId,
      String creatorName,
      int type,
      List<dynamic> playersId,
      String teamName,
      String teamId,
      String paid) {
    this.eventId = eventId;
    this.eventName = eventName;
    this.location = location;
    this.dateTime = dateTime;
    this.sportName = sportName;
    this.status = status;
    this.creatorId = creatorId;
    this.creatorName = creatorName;
    this.type = type;
    this.playersId = playersId;
    this.teamId = teamId;
    this.teamName = teamName;
    this.paid = paid;
  }

  Map<String, dynamic> miniTeamtoJson() => {
        'eventId': eventId,
        'eventName': eventName,
        'location': location,
        'sportName': sportName,
        'dateTime': dateTime,
        'creatorId': creatorId,
        'creatorName': creatorName,
        'type': type,
        'playersId': playersId,
        'status': status,
        'teamName': teamName,
        'teamId': teamId,
        'paid': paid,
      };

  Map<String, dynamic> minitoJson() => {
        'eventId': eventId,
        'eventName': eventName,
        'location': location,
        'sportName': sportName,
        'dateTime': dateTime,
        'creatorId': creatorId,
        'creatorName': creatorName,
        'type': type,
        'playersId': playersId,
        'status': status,
        'paid': paid
      };

  factory Events.fromMiniJson(QueryDocumentSnapshot snapshot) {
    var data = snapshot.data();
    return Events(
      eventId: data['eventId'],
      eventName: data['eventName'],
      creatorId: data['creatorId'],
      location: data['location'],
      sportName: data['sportName'],
      dateTime: data['dateTime'].toDate(),
      creatorName: data['creatorName'],
      type: data['type'],
      playersId: data['playersId'],
      status: data['status'],
      teamName: data['teamName'] ?? "",
      teamId: data['teamId'] ?? "",
      paid: data['paid'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        'eventId': this.eventId,
        'eventName': this.eventName,
        'creatorId': this.creatorId,
        'creatorName': this.creatorName,
        'location': this.location,
        'sportName': this.sportName,
        'description': this.description,
        'playersId': this.playersId,
        'dateTime': this.dateTime,
        'max': this.maxMembers,
        'type': this.type,
        'status': this.status,
        'notificationPlayers': this.notification,
        'participants': this.participants,
        'paid': this.paid,
      };

  // takes a query snapshot as a input and returns a the events class
  factory Events.fromJson(QueryDocumentSnapshot snapshot) {
    var data = snapshot.data();
    return Events(
        eventId: data['eventId'],
        eventName: data['eventName'],
        creatorId: data['creatorId'],
        creatorName: data['creatorName'],
        location: data['location'],
        sportName: data['sportName'],
        description: data['description'],
        playersId: data['playersId'],
        dateTime: data['dateTime'].toDate(),
        maxMembers: data['max'],
        teamInfo: data['teamInfo'],
        playerInfo: data['playerInfo'],
        type: data['type'],
        status: data['status'],
        notification: data['notificationPlayers'],
        participants: data['participants'],
        paid: data['paid']);
  }

  // takes a map as a input and returns a the events class

  factory Events.fromMap(Map<String, dynamic> data) {
    return Events(
        eventId: data['eventId'],
        eventName: data['eventName'],
        creatorId: data['creatorId'],
        creatorName: data['creatorName'],
        location: data['location'],
        sportName: data['sportName'],
        description: data['description'],
        playersId: data['playersId'],
        dateTime: data['dateTime'].toDate(),
        maxMembers: data['max'],
        type: data['type'],
        status: data['status'],
        notification: data['notificationPlayers'],
        participants: data['participants'],
        paid: data['paid']);
  }

  /* 
  This functions takes the data from the firestore for a specific event to check
  if the user can get in the event or not. 

  INPUT -  id (STRING) ----- eventId
  OUTPUT - true or false (FUTURE BOOL)

  NOTE : Use this function with async/await  
 
  LOGIC :
    if (playersId.length < maxMembers)
      true
    else 
      false  

  */
  Future<bool> checkingAvailability(String id) async {
    var snap =
        await FirebaseFirestore.instance.collection('events').doc(id).get();
    Map<String, dynamic> data = snap.data();
    return data['playersId'].length < data['max'] ? true : false;
  }

  /* 

  This functions takes the data from the firestore and return list of all the players. 

  INPUT -  id (STRING) ----- eventId
  OUTPUT - playersId (FUTURE LIST DYNAMIC) ----- list of all the players in the event

  NOTE : Use this function with async/await  

  */

  Future<List<dynamic>> players(String id) async {
    var snap =
        await FirebaseFirestore.instance.collection('events').doc(id).get();
    Map<String, dynamic> data = snap.data();
    return data['playersId'];
  }
}
