import 'package:Runbhumi/services/services.dart';
import 'package:flutter/material.dart';
import '../../widget/widgets.dart';

class ChatSchedule extends StatefulWidget {
  final String chatRoomId;
  final List<dynamic> usersNames;
  final List<dynamic> users;
  ChatSchedule({
    @required this.chatRoomId,
    @required this.usersNames,
    @required this.users,
  });
  @override
  _ChatScheduleState createState() => _ChatScheduleState();
}

class _ChatScheduleState extends State<ChatSchedule> {
  // Use widget.chatRoomId for corresponding chatroomId
  // Use widget.userNames for displaying the names og the people in the chat Id
  // Use widget.users fot the users ID's to be put into the backend.
  //Use the widget.usersPics for the Url for the pictures of the Partiipants.
  GlobalKey<FormState> _addpostkey = GlobalKey<FormState>();
  String _chosenSport;
  TextEditingController _locationController = new TextEditingController();
  TextEditingController _datetime = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();

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
    // var purposeList = DropdownButton(
    //   hint: Text("Purpose"),
    //   value: _chosenPurpose,
    //   items: [
    //     DropdownMenuItem(
    //       child: Text("Want to join a team"),
    //       value: "Want to join a team",
    //     ),
    //     DropdownMenuItem(
    //       child: Text("Looking for an opponent"),
    //       value: "Looking for an opponent",
    //     ),
    //     DropdownMenuItem(
    //       child: Text("Looking for players in our team"),
    //       value: "Looking for players in our team",
    //     ),
    //   ],
    //   onChanged: (value) {
    //     setState(
    //       () {
    //         _chosenPurpose = value;
    //       },
    //     );
    //   },
    // );
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
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: Container(
                        //     width: MediaQuery.of(context).size.width / 1.2,
                        //     padding:
                        //         const EdgeInsets.symmetric(horizontal: 16.0),
                        //     decoration: BoxDecoration(
                        //       borderRadius: new BorderRadius.circular(50),
                        //       border: Border.all(),
                        //     ),
                        //     child: DropdownButtonHideUnderline(
                        //       child: purposeList,
                        //     ),
                        //   ),
                        // ),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.2,
                            child: TextField(
                              controller: _descriptionController,
                              // maxLengthEnforced: false,
                              maxLines: 2,
                              decoration: InputDecoration(
                                labelText: "Description",
                                hintText: "I want a 5v5 for...",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Button(
                    myText: "Schedule",
                    myColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      //TODO: Schdule the MiniEvent in each user.
                      for (int i = 0; i < widget.users.length; i++) {
                        addScheduleToUser(
                            widget.users[i],
                            _nameController.text,
                            _chosenSport,
                            _locationController.text,
                            DateTime.parse(_datetime.text));
                      }
                      setState(() {
                        _locationController = new TextEditingController();
                        _datetime = new TextEditingController();
                        _nameController = new TextEditingController();
                        _descriptionController = new TextEditingController();
                      });
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
              child: buildTitle(context, "Schedule"),
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
