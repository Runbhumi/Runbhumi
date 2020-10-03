import 'package:Runbhumi/models/Events.dart';
import 'package:Runbhumi/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:Runbhumi/view/profilePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String userId = getCurrentUserId();

/*    
locations = <String>[
      "Andhra Pradesh",
      "Arunachal Pradesh",
      "Assam",
      "Bihar",
      "Chhattisgarh",
      "Goa",
      "Gujarat",
      "Haryana",
      "Himachal Pradesh",
      "Jammu and Kashmir",
      "Jharkhand",
      "Karnataka",
      "Kerala",
      "Madhya Pradesh",
      "Maharashtra",
      "Manipur",
      "Meghalaya",
      "Mizoram",
      "Nagaland",
      "Odisha",
      "Punjab",
      "Rajasthan",
      "Sikkim",
      "Tamil Nadu",
      "Telangana",
      "Tripura",
      "Uttarakhand",
      "Uttar Pradesh",
      "West Bengal",
      "Andaman and Nicobar Islands",
      "Chandigarh",
      "Dadra and Nagar Haveli",
      "Daman and Diu",
      "Delhi",
      "Lakshadweep",
      "Puducherry"
      */

Widget _buildTitle(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    color: Colors.white54,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Add Post',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 25,
          ),
        ),
      ],
    ),
  );
}

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  String _chosenSport;
  String _chosenPurpose;
  TextEditingController _descriptionController = new TextEditingController();
  TextEditingController _locationController = new TextEditingController();
  TextEditingController _datetime = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    //sports
    var sportsList = DropdownButton(
      hint: Text("Sport"),
      value: _chosenSport,
      items: [
        DropdownMenuItem(
          child: Text("Basketball"),
          value: "Basketball",
        ),
        DropdownMenuItem(
          child: Text("Football"),
          value: "Football",
        ),
        DropdownMenuItem(child: Text("Volleyball"), value: "Volleyball"),
        DropdownMenuItem(child: Text("Cricket"), value: "Cricket")
      ],
      onChanged: (value) {
        setState(
          () {
            print(value);
            _chosenSport = value;
          },
        );
      },
    );
    //purposes
    var purposeList = DropdownButton(
      hint: Text("Purpose"),
      value: _chosenPurpose,
      items: [
        DropdownMenuItem(
          child: Text("Want to join a team"),
          value: "Want to join a team",
        ),
        DropdownMenuItem(
          child: Text("Looking for an opponent"),
          value: "Looking for an opponent",
        ),
        DropdownMenuItem(
          child: Text("Looking for players in our team"),
          value: "Looking for players in our team",
        ),
      ],
      onChanged: (value) {
        setState(
          () {
            _chosenPurpose = value;
          },
        );
      },
    );
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: addPostSliverAppBar,
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.circular(50),
                        border: Border.all(),
                        color: Color(0xffeeeeee),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: sportsList,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.circular(50),
                        border: Border.all(),
                        color: Color(0xffeeeeee),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: purposeList,
                      ),
                    ),
                  ),
                  InputBox(
                    hintText: "description",
                    controller: _descriptionController,
                  ),
                  DateTimePicker(
                    controller: _datetime,
                  ),
                  InputBox(
                    hintText: "Location",
                    controller: _locationController,
                  ),
                  Button(
                    myText: "Invite Friends",
                    myColor: Theme.of(context).accentColor,
                  ),
                  Button(
                    myText: "Add Post",
                    myColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      var newDoc =
                          FirebaseFirestore.instance.collection('events').doc();
                      String id = newDoc.id;
                      newDoc.set(Events.newEvent(id, userId, "", _chosenSport,
                              _chosenPurpose, [userId], DateTime.now())
                          .toJson());
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(userId)
                          .update({
                        "eventsId": FieldValue.arrayUnion([id])
                      });
                    }, //FirebaseFirestore.instance.collection('events').add(
                    //Events.newEvent((doc.id,userId,,"","","","",[userId],"").toJson());
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> addPostSliverAppBar(
      BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      SliverAppBar(
        expandedHeight: 250.0,
        elevation: 0,
        floating: false,
        pinned: true,
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          title: _buildTitle(context),
          background: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image(
              width: 200,
              image: AssetImage('assets/addpostillustration.png'),
            ),
          ),
        ),
      ),
    ];
  }
}

//TODO: make this is a location input
//TODO: complete Add post button
