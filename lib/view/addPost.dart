import 'package:flutter/material.dart';
import '../widget/widgets.dart';

// class AddPost extends StatefulWidget {
//   @override
//   _AddPostState createState() => _AddPostState();
// }

// class _AddPostState extends State<AddPost> {
//   // int _radioValue = 0;
//   String textResult = '';
//   String dropdownValue;
//   String dropdownValue2;
//   String dropdownValue3;
//   List<DropdownMenuItem<String>> sportlist = [];
//   List<DropdownMenuItem<String>> locations = [];
//   List<DropdownMenuItem<String>> purpose = [];
//   void loadLocations() {
//     locations = [];
//     sportlist = [];
//     purpose = [];
//     locations = <String>[
//       "Andhra Pradesh",
//       "Arunachal Pradesh",
//       "Assam",
//       "Bihar",
//       "Chhattisgarh",
//       "Goa",
//       "Gujarat",
//       "Haryana",
//       "Himachal Pradesh",
//       "Jammu and Kashmir",
//       "Jharkhand",
//       "Karnataka",
//       "Kerala",
//       "Madhya Pradesh",
//       "Maharashtra",
//       "Manipur",
//       "Meghalaya",
//       "Mizoram",
//       "Nagaland",
//       "Odisha",
//       "Punjab",
//       "Rajasthan",
//       "Sikkim",
//       "Tamil Nadu",
//       "Telangana",
//       "Tripura",
//       "Uttarakhand",
//       "Uttar Pradesh",
//       "West Bengal",
//       "Andaman and Nicobar Islands",
//       "Chandigarh",
//       "Dadra and Nagar Haveli",
//       "Daman and Diu",
//       "Delhi",
//       "Lakshadweep",
//       "Puducherry"
//     ].map<DropdownMenuItem<String>>((String value) {
//       return DropdownMenuItem<String>(
//         value: value,
//         child: Text(value),
//       );
//     }).toList();

//     sportlist = <String>[
//       "Basketball",
//       "Football",
//       "Volleyball",
//       "Cricket",
//       "other"
//     ].map<DropdownMenuItem<String>>((String value) {
//       return DropdownMenuItem<String>(
//         value: value,
//         child: Text(value),
//       );
//     }).toList();

//     purpose = <String>[
//       "Want to join a team",
//       "Looking for an opponent",
//       "Looking for players in our team"
//     ].map<DropdownMenuItem<String>>((String value) {
//       return DropdownMenuItem<String>(
//         value: value,
//         child: Text(value),
//       );
//     }).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     loadLocations();
//     return Scaffold(
//       backgroundColor: Color(0xFFF4F4F4),
//       body: SingleChildScrollView(
//         child: SafeArea(
//           child: Column(
//             children: <Widget>[
//               Column(
//                 children: <Widget>[
//                   Container(
//                       alignment: Alignment.centerLeft,
//                       margin: EdgeInsets.all(20),
//                       child: Text(
//                         "Choose a sport",
//                         style: TextStyle(
//                           fontSize: 20,
//                         ),
//                       )),
//                   SizedBox(
//                     width: 40,
//                   ),
//                   Container(
//                     alignment: Alignment.centerLeft,
//                     margin: EdgeInsets.fromLTRB(20, 0, 0, 10),
//                     child: DropdownButton<String>(
//                       value: dropdownValue,
//                       icon: Icon(Icons.arrow_downward),
//                       iconSize: 24,
//                       elevation: 16,
//                       items: sportlist,
//                       hint: Text("Choose a sport"),
//                       style: TextStyle(color: Colors.black),
//                       underline: Container(
//                         height: 2,
//                         color: Colors.black,
//                       ),
//                       onChanged: (String newValue) {
//                         setState(() {
//                           dropdownValue = newValue;
//                         });
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//               Column(
//                 children: <Widget>[
//                   Container(
//                       alignment: Alignment.centerLeft,
//                       margin: EdgeInsets.all(20),
//                       child: Text(
//                         "Purpose :",
//                         style: TextStyle(
//                           fontSize: 20,
//                         ),
//                       )),
//                   SizedBox(
//                     width: 20,
//                   ),
//                   Container(
//                     alignment: Alignment.centerLeft,
//                     margin: EdgeInsets.fromLTRB(20, 0, 0, 10),
//                     child: DropdownButton<String>(
//                       value: dropdownValue2,
//                       icon: Icon(Icons.arrow_downward),
//                       iconSize: 24,
//                       elevation: 16,
//                       items: purpose,
//                       hint: Text("Choose a purpose"),
//                       style: TextStyle(color: Colors.black),
//                       underline: Container(
//                         height: 2,
//                         color: Colors.black,
//                       ),
//                       onChanged: (String newValue) {
//                         setState(() {
//                           dropdownValue = newValue;
//                         });
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
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
              fontWeight: FontWeight.w700, fontSize: 25, color: Colors.black),
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
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: _buildTitle(context),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image(
              width: 300,
              image: AssetImage('assets/addpostillustration.png'),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  // Add TextFormFields and RaisedButton here.
                  InputBox(
                    myText: "Sports",
                    hidden: false,
                  ),
                  InputBox(
                    myText: "purpose",
                    hidden: false,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
