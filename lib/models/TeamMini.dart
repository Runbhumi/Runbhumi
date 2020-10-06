import 'package:cloud_firestore/cloud_firestore.dart';

class TeamView {
  String teamName;
  String image;
  String teamId;
  TeamView(this.teamId, this.teamName, this.image);
  Map<String, dynamic> toJson() =>
      {'teamId': teamId, 'name': teamName, 'image': image};
  TeamView.fromSnapshot(DocumentSnapshot snapshot)
      : image = snapshot.data()['image'],
        teamName = snapshot.data()['teamName'],
        teamId = snapshot.data()['teamId'];
}
