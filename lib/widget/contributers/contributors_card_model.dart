//The model of the card of the contributors.

import 'package:flutter/material.dart';

class ContributorCard {
  final String userName;
  final String desc;
  final String name;
  final String location;
  final String displayImgUrl;
  final String website;
  final String twitterUsername;
  ContributorCard(
      {@required this.userName,
      @required this.displayImgUrl,
      @required this.location,
      @required this.name,
      @required this.twitterUsername,
      @required this.desc,
      @required this.website});
}
