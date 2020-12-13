import 'package:Runbhumi/services/services.dart';
import 'package:Runbhumi/utils/Constants.dart';
import 'package:Runbhumi/utils/theme_config.dart';
import 'package:Runbhumi/utils/validations.dart';
import 'package:Runbhumi/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// status map

// 1 - public
// 2 - private
// 3 - closed

String userId = Constants.prefs.getString('userId');

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  GlobalKey<FormState> _addpostkey = GlobalKey<FormState>();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _datetime = new TextEditingController();
  TextEditingController _locationController = new TextEditingController();
  TextEditingController _descController = new TextEditingController();
  String _chosenSport;
  double _maxMembers = 2;
  int _type = 1;
  String _status = 'team';
  final PageController _addPostPageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    //sports
    final ThemeNotifier theme = Provider.of<ThemeNotifier>(context);
    var sportsList = DropdownButton(
      hint: Text("Sport"),
      elevation: 1,
      value: _chosenSport,
      items: [
        DropdownMenuItem(
          child: Text(
            "Basketball",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
          value: "Basketball",
        ),
        DropdownMenuItem(
          child: Text(
            "Football",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
          value: "Football",
        ),
        DropdownMenuItem(
            child: Text(
              "Volleyball",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            value: "Volleyball"),
        DropdownMenuItem(
            child: Text(
              "Cricket",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            value: "Cricket")
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

    var slider = Slider(
      value: _maxMembers,
      onChanged: (newLimit) {
        setState(() => _maxMembers = newLimit);
      },
      min: 2,
      max: 50,
      label: _maxMembers.toInt().toString(),
      divisions: 50,
    );
    var publicRadio = RadioListTile(
      groupValue: _type,
      title: Text('Public'),
      value: 1,
      onChanged: (val) {
        setState(() => _type = val);
      },
    );
    var privateRadio = RadioListTile(
      groupValue: _type,
      title: Text('Private'),
      value: 2,
      onChanged: (val) {
        setState(() => _type = val);
      },
    );
    var teamRadio = RadioListTile(
      groupValue: _status,
      title: Text('Teams'),
      value: 'team',
      onChanged: (val) {
        setState(() => _status = val);
      },
    );
    var individualRadio = RadioListTile(
      groupValue: _status,
      title: Text('Individuals'),
      value: 'individual',
      onChanged: (val) {
        setState(() => _status = val);
      },
    );
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        leading: BackButton(),
        title: buildTitle(context, "Add Post"),
      ),
      body: PageView(
        controller: _addPostPageController,
        children: [
          Page1(
            theme: theme,
            addpostkey: _addpostkey,
            nameController: _nameController,
            sportsList: sportsList,
            datetime: _datetime,
            locationController: _locationController,
            descController: _descController,
            slider: slider,
            chosenSport: _chosenSport,
            maxMembers: _maxMembers,
            status: _status,
            type: _type,
            publicRadio: publicRadio,
            privateRadio: privateRadio,
            teamRadio: teamRadio,
            individualRadio: individualRadio,
          ),
          // MyPage2Widget(),
          // MyPage3Widget(),
        ],
      ),
    );
  }
}

class Page1 extends StatefulWidget {
  const Page1({
    Key key,
    @required GlobalKey<FormState> addpostkey,
    @required TextEditingController nameController,
    @required this.theme,
    @required this.sportsList,
    @required TextEditingController datetime,
    @required TextEditingController locationController,
    @required TextEditingController descController,
    @required this.slider,
    @required this.publicRadio,
    @required this.privateRadio,
    @required this.teamRadio,
    @required this.individualRadio,
    @required String chosenSport,
    @required double maxMembers,
    @required int type,
    @required String status,
  })  : _addpostkey = addpostkey,
        _nameController = nameController,
        _datetime = datetime,
        _locationController = locationController,
        _descController = descController,
        _chosenSport = chosenSport,
        _maxMembers = maxMembers,
        _status = status,
        _type = type,
        super(key: key);

  final GlobalKey<FormState> _addpostkey;
  final TextEditingController _nameController;
  final ThemeNotifier theme;
  final DropdownButton<String> sportsList;
  final TextEditingController _datetime;
  final TextEditingController _locationController;
  final TextEditingController _descController;
  final Slider slider;
  final RadioListTile publicRadio;
  final RadioListTile privateRadio;
  final RadioListTile teamRadio;
  final RadioListTile individualRadio;
  final String _chosenSport;
  final double _maxMembers;
  final int _type;
  final String _status;

  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: widget._addpostkey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            SizedBox(
              height: 8,
            ),
            InputBox(
              controller: widget._nameController,
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
                  color: Theme.of(context).inputDecorationTheme.fillColor,
                  border: Border.all(color: Color(0x00000000)),
                ),
                child: DropdownButtonHideUnderline(
                  child: widget.sportsList,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DateTimePicker(
                controller: widget._datetime,
              ),
            ),
            InputBox(
              controller: widget._locationController,
              hintText: "Borvalli, Mumbai, MH",
              labelText: "Location",
              validateFunction: Validations.validateNonEmpty,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                width: MediaQuery.of(context).size.width / 1.2,
                child: TextField(
                  controller: widget._descController,
                  // maxLengthEnforced: false,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: "Description",
                    hintText: "I want a 5v5 for...",
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //max member slider
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 4.0),
                  child: Text(
                    'Select max members (${widget._maxMembers.toInt().toString()})',
                    style: TextStyle(
                      color:
                          Theme.of(context).backgroundColor.withOpacity(0.35),
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                widget.slider,
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 4.0),
                  child: Text(
                    'Status',
                    style: TextStyle(
                      color:
                          Theme.of(context).backgroundColor.withOpacity(0.35),
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                widget.publicRadio,
                widget.privateRadio,
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 4.0),
                  child: Text(
                    'Who should join your Event',
                    style: TextStyle(
                      color:
                          Theme.of(context).backgroundColor.withOpacity(0.35),
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                widget.teamRadio,
                widget.individualRadio,
              ],
            ),
            //Todo add a description feild in event from backend
            Button(
              myText: "Add Post",
              myColor: Theme.of(context).primaryColor,
              onPressed: () {
                // this funtion writes in the DB and adds an
                // event when manually testing anything,
                // just comment this function
                createNewEvent(
                  widget._nameController.text,
                  userId,
                  widget._locationController.text,
                  widget._chosenSport,
                  widget._descController.text,
                  [userId],
                  DateTime.parse(widget._datetime.text),
                  widget._maxMembers.toInt(),
                  widget._status,
                  widget._type,
                );
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
            SizedBox(
              height: 72,
            ),
          ],
        ),
      ),
    );
  }
}

// List<Widget> addPostSliverAppBar(
//     BuildContext context, bool innerBoxIsScrolled) {
//   return <Widget>[
//     SliverAppBar(
//       expandedHeight: 250.0,
//       leading: BackButton(),
//       elevation: 0,
//       floating: false,
//       pinned: true,
//       flexibleSpace: FlexibleSpaceBar(
//         centerTitle: true,
//         title: Container(
//             child: buildTitle(context, "Add Post"),
//             color: Theme.of(context).canvasColor.withOpacity(0.5)),
//         background: Image(
//           height: 200,
//           image: AssetImage('assets/addpostillustration.png'),
//         ),
//       ),
//     ),
//   ];
// }
