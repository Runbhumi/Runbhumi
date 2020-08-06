import 'package:flutter/material.dart';
import 'package:runbhumi_ui/Authentication/loginPage.dart';

class signUp extends StatefulWidget {
  @override
  _signUpState createState() => _signUpState();
}

class _signUpState extends State<signUp> {
  int _radioValue = 0;
  String textResult = '';
  String dropdownValue = null;
  List<DropdownMenuItem<String>> locations = [];

  void loadLocations() {
    locations = [];
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
    ].map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList();
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          textResult = "Male";
          break;
        case 1:
          textResult = "Female";
          break;
        case 2:
          textResult = "Prefer not to tell";
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    loadLocations();
    return Scaffold(
      backgroundColor: Color(0xFFF4F4F4),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => loginPage()));
                    },
                    child: Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Icon(Icons.arrow_back)),
                  ),
                  Center(
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      padding: EdgeInsets.fromLTRB(20, 0, 10, 10),
                      child: Image(
                        image: AssetImage('assets/signUp.png'),
                        height: 100,
                        width: 300,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.all(20),
                alignment: Alignment.centerLeft,
                height: 60,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(225, 95, 27, .3),
                          blurRadius: 40,
                          offset: Offset(0, 10))
                    ]),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.black))),
                  child: TextFormField(
                    validator: (val) {
                      return val != null ? null : "Please Enter Correct Email";
                    },
                    decoration: InputDecoration(
                        hintText: "Name",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                alignment: Alignment.centerLeft,
                height: 60,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(225, 95, 27, .3),
                          blurRadius: 40,
                          offset: Offset(0, 10))
                    ]),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.black))),
                  child: TextFormField(
                    validator: (val) {
                      return RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(val)
                          ? null
                          : "Please Enter Correct Email";
                    },
                    decoration: InputDecoration(
                        hintText: "E-mail",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 10, 0, 10),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Gender:",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  new Radio(
                      activeColor: Color(0xFFFF7315),
                      value: 0,
                      groupValue: _radioValue,
                      onChanged: _handleRadioValueChange),
                  Text(
                    "Male",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  new Radio(
                      activeColor: Color(0xFFFF7315),
                      value: 1,
                      groupValue: _radioValue,
                      onChanged: _handleRadioValueChange),
                  Text(
                    "Female",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  new Radio(
                      activeColor: Color(0xFFFF7315),
                      value: 2,
                      groupValue: _radioValue,
                      onChanged: _handleRadioValueChange),
                  Text(
                    "Prefer not to tell",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                ],
              ),
              SizedBox(
                width: 30,
              ),
              Row(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.all(20),
                      child: Text(
                        "Location",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      )),
                  SizedBox(
                    width: 40,
                  ),
                  DropdownButton<String>(
                    value: dropdownValue,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    items: locations,
                    hint: Text("Choose a city"),
                    style: TextStyle(color: Colors.black),
                    underline: Container(
                      height: 2,
                      color: Colors.black,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownValue = newValue;
                      });
                    },
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.all(20),
                alignment: Alignment.centerLeft,
                height: 60,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(225, 95, 27, .3),
                          blurRadius: 40,
                          offset: Offset(0, 10))
                    ]),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.black))),
                  child: TextFormField(
                    validator: (val) {
                      return val != null ? null : "Please Enter Correct Email";
                    },
                    decoration: InputDecoration(
                        hintText: "Username",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(20),
                alignment: Alignment.centerLeft,
                height: 60,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(225, 95, 27, .3),
                          blurRadius: 40,
                          offset: Offset(0, 10))
                    ]),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.black))),
                  child: TextFormField(
                    validator: (val) {
                      return val != null ? null : "Please Enter Correct Email";
                    },
                    decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none),
                  ),
                ),
              ),
              GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 55,
                    width: 250,
                    margin: EdgeInsets.symmetric(horizontal: 50),
                    decoration:
                        BoxDecoration(color: Color(0xFFFF7315), boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(225, 95, 27, .3),
                          blurRadius: 40,
                          offset: Offset(0, 10))
                    ]),
                    child: Center(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
