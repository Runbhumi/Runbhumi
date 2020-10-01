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
  return new Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12.0),
    child: new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Text(
          'Add Post',
          style: TextStyle(
              fontWeight: FontWeight.w700, fontSize: 25),
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: _buildTitle(context),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image(
                  width: 300,
                  image: AssetImage('assets/addpostillustration.png'),
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
            ],
          ),
        ),
      ),
    );
  }
}
