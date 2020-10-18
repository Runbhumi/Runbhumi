import 'package:Runbhumi/services/EventService.dart';
import 'package:Runbhumi/utils/Constants.dart';
import 'package:Runbhumi/widget/widgets.dart';
import 'package:flutter/material.dart';

String userId = Constants.prefs.getString('userId');

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  GlobalKey<FormState> _addpostkey = GlobalKey<FormState>();
  String _chosenSport;
  String _chosenPurpose;
  TextEditingController _locationController = new TextEditingController();
  TextEditingController _datetime = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
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
                  Form(
                    key: _addpostkey,
                    child: Column(
                      children: [
                        InputBox(
                            controller: _nameController,
                            hintText: "Event name"),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.2,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            decoration: BoxDecoration(
                              borderRadius: new BorderRadius.circular(50),
                              border: Border.all(),
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            decoration: BoxDecoration(
                              borderRadius: new BorderRadius.circular(50),
                              border: Border.all(),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: purposeList,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DateTimePicker(
                            controller: _datetime,
                          ),
                        ),
                        InputBox(
                          controller: _locationController,
                          hintText: "Location",
                        ),
                        // Button(
                        //   myText: "Invite Friends",
                        //   myColor: Theme.of(context).accentColor,
                        //   onPressed: () {},
                        // ),removed for MVP
                      ],
                    ),
                  ),
                  Button(
                    myText: "Add Post",
                    myColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      // this funtion writes in the DB and adds an
                      // event when manually testing anything,
                      // just comment this function
                      createNewEvent(
                          _nameController.text,
                          userId,
                          _locationController.text,
                          _chosenSport,
                          _chosenPurpose,
                          [userId],
                          DateTime.parse(_datetime.text));
                      // to show success dialog
                      showDialog(
                        context: context,
                        builder: (context) {
                          //wait for 3 sec
                          Future.delayed(Duration(seconds: 3), () {
                            Navigator.pushNamed(context, "/mainapp");
                          });
                          return successDialog(context);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  SimpleDialog successDialog(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      children: [
        Center(
            child: Text("Post added",
                style: Theme.of(context).textTheme.headline4)),
        Image.asset("assets/confirmation-illustration.png"),
      ],
    );
  }

  List<Widget> addPostSliverAppBar(
      BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      SliverAppBar(
        expandedHeight: 250.0,
        leading: BackButton(),
        elevation: 0,
        floating: false,
        pinned: true,
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          title: Container(
              child: buildTitle(context, "Add Post"),
              color: Theme.of(context).canvasColor.withOpacity(0.5)),
          background: Image(
            height: 200,
            image: AssetImage('assets/addpostillustration.png'),
          ),
        ),
      ),
    ];
  }
}
