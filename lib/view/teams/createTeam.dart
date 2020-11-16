//import 'package:Runbhumi/services/TeamServices.dart';
import 'package:Runbhumi/models/Teams.dart';
import 'package:Runbhumi/services/TeamServices.dart';
import 'package:Runbhumi/utils/theme_config.dart';
import 'package:Runbhumi/utils/validations.dart';
import 'package:Runbhumi/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Chats/inviteFriends.dart';

class CreateTeam extends StatefulWidget {
  @override
  _CreateTeamState createState() => _CreateTeamState();
}

class _CreateTeamState extends State<CreateTeam> {
  GlobalKey<FormState> _createNewTeamkey = GlobalKey<FormState>();
  String _chosenSport;
  Teams team;
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _descController = new TextEditingController();
  TextEditingController _teamLocationController = new TextEditingController();
  int _radioValue = 0;
  @override
  Widget build(BuildContext context) {
    //sports
    final ThemeNotifier theme = Provider.of<ThemeNotifier>(context);
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
        leading: BackButton(),
        title: buildTitle(context, "Make a new Team"),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
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
                      validateFunction: Validations.validateNonEmpty,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          borderRadius: new BorderRadius.circular(50),
                          color: theme.currentTheme.primaryColorLight,
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
                      validateFunction: Validations.validateNonEmpty,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 36.0),
                      child: Card(
                        child: ListTile(
                          selectedTileColor: Colors.grey[200],
                          title: Text(
                            'Open',
                          ),
                          selected: _radioValue == 0 ? true : false,
                          onTap: () {
                            setState(() {
                              _radioValue = 0;
                            });
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 36.0),
                      child: Card(
                        child: ListTile(
                          selectedTileColor: Colors.grey[200],
                          title: Text(
                            'Invite only',
                          ),
                          selected: _radioValue == 1 ? true : false,
                          onTap: () {
                            setState(() {
                              _radioValue = 1;
                            });
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 36.0),
                      child: Card(
                        child: ListTile(
                          selectedTileColor: Colors.grey[200],
                          title: Text(
                            'Closed',
                          ),
                          selected: _radioValue == 2 ? true : false,
                          onTap: () {
                            setState(() {
                              _radioValue = 2;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Button(
                  myText: "Create Team",
                  myColor: Theme.of(context).primaryColor,
                  onPressed: () {
                    //------- Code to create a team just remember to pass all the arguments ---------------
                    team = TeamService().createNewTeam(_chosenSport,
                        _nameController.text, _descController.text);
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
                  },
                ),
              ),
            ],
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
          child:
              Text("Post added", style: Theme.of(context).textTheme.headline4)),
      Image.asset("assets/confirmation-illustration.png"),
    ],
  );
}
