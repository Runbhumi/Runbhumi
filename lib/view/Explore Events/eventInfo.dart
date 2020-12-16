import 'dart:async';

import 'package:Runbhumi/widget/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EventInfo extends StatefulWidget {
  final String eventId;
  const EventInfo({
    @required this.eventId,
    Key key,
  }) : super(key: key);
  @override
  _EventInfoState createState() => _EventInfoState();
}

class _EventInfoState extends State<EventInfo> {
  StreamSubscription sub;
  Map data;
  bool _loading = false;
  String sportIcon;
  @override
  void initState() {
    super.initState();
    sub = FirebaseFirestore.instance
        .collection('events')
        .doc(widget.eventId)
        .snapshots()
        .listen((snap) {
      setState(() {
        data = snap.data();
        _loading = true;
      });
    });
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading)
      return Scaffold(
        appBar: AppBar(
          title: buildTitle(
            context,
            data['eventName'],
          ),
          leading: BackButton(),
        ),
        body: Column(
          children: [
            Text(data['eventName']),
            Text(data['description']),
            //TODO: Display Dzte and time of the event, Location of t
          ],
        ),
      );
    return Loader();
  }
}
