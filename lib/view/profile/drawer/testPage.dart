import 'package:Runbhumi/widget/widgets.dart';
// import 'package:Runbhumi/view/views.dart';
import 'package:flutter/material.dart';

class Testing extends StatefulWidget {
  @override
  _TestingState createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: buildTitle(context, "Testing"),
      ),
      body: Container(),
    );
  }
}
