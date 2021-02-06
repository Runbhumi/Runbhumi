/*
-----------------------------------------------------------------------------------------
                         ********* Type of staus in backend ********* 
pubic(lowercase) - is similar to anyone can join.So User can directly join the team
private(lowercase) - is similar to invite only.where a request to the manager will be sent.
if the mager accepts then the user will be taken in the team else not.
closed(lowercase)- is when the team is not accepting invites or any new player 

-------------------------------------------------------------------------------------------
*/

import 'package:Runbhumi/models/models.dart';
import 'package:Runbhumi/widget/showOffline.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:Runbhumi/services/services.dart';
// import 'package:Runbhumi/utils/theme_config.dart';
import 'package:Runbhumi/utils/validations.dart';
import 'package:Runbhumi/widget/widgets.dart';
// import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
// import 'package:provider/provider.dart';
import '../Chats/inviteFriends.dart';

class CreateTeam extends StatefulWidget {
  @override
  _CreateTeamState createState() => _CreateTeamState();
}

class _CreateTeamState extends State<CreateTeam> {
  GlobalKey<FormState> _createNewTeamkey = GlobalKey<FormState>();
  String _chosenSport;
  // GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  Teams team;
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _descController = new TextEditingController();
  TextEditingController _teamLocationController = new TextEditingController();
  // TextEditingController _autoCompleteController = new TextEditingController();
  // List<String> stateNames = [
  //   "Maharashtra",
  //   "Tamil Nadu",
  //   "Manipal",
  //   "Telangana",
  // ];
  String _type = "public";
  SimpleDialog teamTypeInfo(BuildContext context) {
    return SimpleDialog(
      title: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Icon(
              Feather.info,
              size: 64,
            )),
          ),
          Center(child: Text("What is a status")),
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
              child: Text(
                  "Public: Anyone can join the Team until it gets full" +
                      '\n' +
                      "Private: You will be notified when someone tries to join your team. You can then accept or decline the request.",
                  style: Theme.of(context).textTheme.subtitle1)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    //sports
    // final ThemeNotifier theme = Provider.of<ThemeNotifier>(context);
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

    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(),
        title: buildTitle(context, "Make a new Team"),
        automaticallyImplyLeading: false,
      ),
      body: ConnectivityWidgetWrapper(
        offlineWidget: ShowOffline(),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Form(
                  key: _createNewTeamkey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      InputBox(
                        controller: _nameController,
                        hintText: "Team name",
                        validateFunction: Validations.validateName,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          decoration: BoxDecoration(
                            borderRadius: new BorderRadius.circular(50),
                            color: Theme.of(context)
                                .inputDecorationTheme
                                .fillColor,
                            border: Border.all(color: Color(0x00000000)),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: sportsList,
                          ),
                        ),
                      ),
                      InputBox(
                        controller: _descController,
                        hintText: "Description",
                        validateFunction: Validations.validateNonEmpty,
                      ),
                      InputBox(
                        controller: _teamLocationController,
                        hintText: "Team Location",
                        validateFunction: Validations.validateName,
                      ),
                      // AutoCompleteTextField(
                      //   key: key,
                      //   clearOnSubmit: false,
                      //   controller: _autoCompleteController,
                      //   suggestions: stateNames,
                      //   style: TextStyle(fontSize: 16),
                      //   itemFilter: (item, query) {
                      //     return item
                      //         .toString()
                      //         .toLowerCase()
                      //         .startsWith(query.toLowerCase());
                      //   },
                      //   itemSorter: (a, b) {
                      //     return a.compareTo(b);
                      //   },
                      //   itemSubmitted: (item) {
                      //     _autoCompleteController.text = item.toString();
                      //   },
                      //   itemBuilder: (context, item) {
                      //     return Container(
                      //         padding: EdgeInsets.all(15),
                      //         child: Text(item.toString()));
                      //   },
                      //   suggestionsAmount: 5,
                      // ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 4.0),
                        child: Row(
                          children: [
                            Text(
                              'What type is the team?',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .backgroundColor
                                    .withOpacity(0.35),
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            IconButton(
                                icon: Icon(Feather.info),
                                iconSize: 15.0,
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return teamTypeInfo(context);
                                    },
                                  );
                                })
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 36.0),
                        child: Card(
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            title: Text(
                              'Public',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            selected: _type == "public" ? true : false,
                            onTap: () {
                              setState(() {
                                _type = "public";
                              });
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 36.0),
                        child: Card(
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            title: Text(
                              'Private',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            selected: _type == "private" ? true : false,
                            onTap: () {
                              setState(() {
                                _type = "private";
                              });
                            },
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 36.0),
                      //   child: Card(
                      //     child: ListTile(
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.all(Radius.circular(20)),
                      //       ),
                      //       title: Text(
                      //         'Closed',
                      //         style: TextStyle(fontWeight: FontWeight.w700),
                      //       ),
                      //       selected: _type == "closed" ? true : false,
                      //       onTap: () {
                      //         setState(() {
                      //           _type = "closed";
                      //         });
                      //       },
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Button(
                    myText: "Create Team",
                    myColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      if (_createNewTeamkey.currentState.validate() &&
                          _chosenSport != null) {
                        //------- Code to create a team just remember to pass all the arguments ---------------
                        team = TeamService().createNewTeam(_chosenSport,
                            _nameController.text, _descController.text, _type);
                        showDialog(
                          context: context,
                          builder: (context) {
                            //wait for 3 sec
                            Future.delayed(Duration(seconds: 3), () {
                              //This will be replaced by actual team IDs
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          InviteFriends(team: team)));
                            });
                            return successDialog(context);
                          },
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return inValidInput(context);
                          },
                        );
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 72,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

SimpleDialog successDialog(BuildContext context) {
  return SimpleDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    children: [
      Center(
          child: Text("Team Created",
              style: Theme.of(context).textTheme.headline4)),
      Image.asset("assets/confirmation-illustration.png"),
    ],
  );
}

SimpleDialog inValidInput(BuildContext context) {
  return SimpleDialog(
    title: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: Icon(
            Feather.info,
            size: 64,
          )),
        ),
        Center(child: Text("Invalid Input")),
      ],
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    children: [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
            child: Text("The given input is invalid, please try again",
                style: Theme.of(context).textTheme.subtitle1)),
      ),
    ],
  );
}
