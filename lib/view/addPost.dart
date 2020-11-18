import 'package:Runbhumi/services/services.dart';
import 'package:Runbhumi/utils/Constants.dart';
import 'package:Runbhumi/utils/theme_config.dart';
import 'package:Runbhumi/utils/validations.dart';
import 'package:Runbhumi/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

String userId = Constants.prefs.getString('userId');

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  GlobalKey<FormState> _addpostkey = GlobalKey<FormState>();
  String _chosenSport;
  String _chosenPurpose;
  double _maxMembers = 0;
  TextEditingController _locationController = new TextEditingController();
  TextEditingController _datetime = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _typeController = new TextEditingController();
  TextEditingController _statusController = new TextEditingController();
  final PageController _addPostPageController = PageController(initialPage: 0);

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
    var purposeList = DropdownButton(
      // style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      hint: Text("Purpose"),
      value: _chosenPurpose,
      items: [
        DropdownMenuItem(
          child: Text(
            "Want to join a team",
          ),
          value: "Want to join a team",
        ),
        DropdownMenuItem(
          child: Text(
            "Looking for an opponent",
          ),
          value: "Looking for an opponent",
        ),
        DropdownMenuItem(
          child: Text(
            "Looking for players to join our team",
          ),
          value: "Looking for players to join our team",
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

    var slider = Slider(
      value: _maxMembers,
      onChanged: (newLimit) {
        setState(() => _maxMembers = newLimit);
      },
      min: 0,
      max: 50,
      label: _maxMembers.toString(),
      divisions: 25,
    );
    return Scaffold(
        // body: NestedScrollView(
        // headerSliverBuilder: addPostSliverAppBar,
        appBar: AppBar(
          leading: BackButton(),
          title: buildTitle(context, "Add Post"),
        ),
        body: PageView(
          controller: _addPostPageController,
          children: [
            Page1(
                addpostkey: _addpostkey,
                nameController: _nameController,
                theme: theme,
                sportsList: sportsList,
                purposeList: purposeList,
                datetime: _datetime,
                locationController: _locationController,
                slider: slider,
                chosenSport: _chosenSport,
                chosenPurpose: _chosenPurpose,
                maxMembers: _maxMembers,
                status: _statusController.toString(),
                type: _typeController.toString()),
            // MyPage2Widget(),
            // MyPage3Widget(),
          ],
        )
        // ),
        );
  }

  // SimpleDialog successDialog(BuildContext context) {
  //   return SimpleDialog(
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.all(Radius.circular(20)),
  //     ),
  //     children: [
  //       Center(
  //           child: Text("Post added",
  //               style: Theme.of(context).textTheme.headline4)),
  //       Image.asset("assets/confirmation-illustration.png"),
  //     ],
  //   );
  // }

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

class Page1 extends StatelessWidget {
  const Page1(
      {Key key,
      @required GlobalKey<FormState> addpostkey,
      @required TextEditingController nameController,
      @required this.theme,
      @required this.sportsList,
      @required this.purposeList,
      @required TextEditingController datetime,
      @required TextEditingController locationController,
      @required this.slider,
      @required String chosenSport,
      @required String chosenPurpose,
      @required double maxMembers,
      @required String type,
      @required String status})
      : _addpostkey = addpostkey,
        _nameController = nameController,
        _datetime = datetime,
        _locationController = locationController,
        _chosenSport = chosenSport,
        _chosenPurpose = chosenPurpose,
        _maxMembers = maxMembers,
        _status = status,
        _type = type,
        super(key: key);

  final GlobalKey<FormState> _addpostkey;
  final TextEditingController _nameController;
  final ThemeNotifier theme;
  final DropdownButton<String> sportsList;
  final DropdownButton<String> purposeList;
  final TextEditingController _datetime;
  final TextEditingController _locationController;
  final Slider slider;
  final String _chosenSport;
  final String _chosenPurpose;
  final double _maxMembers;
  final String _status;
  final String _type;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Form(
          key: _addpostkey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              InputBox(
                controller: _nameController,
                hintText: "Event name",
                validateFunction: Validations.validateNonEmpty,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: theme.currentTheme.primaryColorLight,
                    border: Border.all(color: Color(0x00000000)),
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
                    color: theme.currentTheme.primaryColorLight,
                    border: Border.all(color: Color(0x00000000)),
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
                validateFunction: Validations.validateNonEmpty,
              ),
              //max member slider
              Text("select max members"),
              slider,
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
                      DateTime.parse(_datetime.text),
                      _maxMembers.toInt(),
                      _type,
                      _status);
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
    );
  }
}
