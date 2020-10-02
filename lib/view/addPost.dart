import 'package:Runbhumi/widget/widgets.dart';
import 'package:flutter/material.dart';
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
  int _chosenSport;
  int _chosenPurpose;
  TextEditingController _descriptionController;
  @override
  Widget build(BuildContext context) {
    //sports
    var sportsList = DropdownButton(
      hint: Text("Sport"),
      value: _chosenSport,
      items: [
        DropdownMenuItem(
          child: Text("Basketball"),
          value: 1,
        ),
        DropdownMenuItem(
          child: Text("Football"),
          value: 2,
        ),
        DropdownMenuItem(child: Text("Volleyball"), value: 3),
        DropdownMenuItem(child: Text("Cricket"), value: 4)
      ],
      onChanged: (value) {
        setState(
          () {
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
          value: 1,
        ),
        DropdownMenuItem(
          child: Text("Looking for an opponent"),
          value: 2,
        ),
        DropdownMenuItem(
          child: Text("Looking for players in our team"),
          value: 3,
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
          headerSliverBuilder: addPastSliverAppBar,
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
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
                    padding: const EdgeInsets.all(8.0),
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
                  //TODO: make this a date time input
                  InputBox(
                    hintText: "date & time",
                    controller: _descriptionController,
                  ),
                  //TODO: make this is a location input
                  InputBox(
                    hintText: "Location",
                    controller: _descriptionController,
                  ),
                  Button(
                    myText: "Invite Friends",
                    myColor: Theme.of(context).accentColor,
                  ),
                  //TODO: complete Add post button
                  Button(
                    myText: "Add Post",
                    myColor: Theme.of(context).primaryColor,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> addPastSliverAppBar(
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
