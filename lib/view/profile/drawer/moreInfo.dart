import 'package:Runbhumi/widget/contributers/contributor_detail_model.dart';
import 'package:Runbhumi/widget/contributers/contributors_card_model.dart';
import 'package:Runbhumi/widget/contributers/contributors_data_model.dart';
import 'package:Runbhumi/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class MoreInfo extends StatefulWidget {
  @override
  _MoreInfoState createState() => _MoreInfoState();
}

class _MoreInfoState extends State<MoreInfo>
    with AutomaticKeepAliveClientMixin {
  List<ContributorCard> cardList = [];
  @override
  void initState() {
    super.initState();
    getContributors(username: 'Runbhumi', repository: 'Runbhumi').then((cards) {
      setState(() {
        cardList = cards;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(leading: BackButton(), title: Text("More Info"), actions: [
        IconButton(
          icon: Icon(Icons.info_outline),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AboutDialog(
                applicationName: "Runbhumi",
                applicationVersion: "v0.5.0",
                applicationLegalese: '''
MIT License

Copyright (c) 2020 Runbhumi

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.''',
              ),
            );
          },
        )
      ]),
      body: cardList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              // Get the List of contributors to the project from the GitHub Api
              // Append the details of the card to the cardList
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: cardList.length,
              itemBuilder: (ctx, index) {
                return Card(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundImage:
                                  NetworkImage(cardList[index].displayImgUrl),
                            ),
                            SmallButton(
                              myColor: Theme.of(context).primaryColor,
                              myText: "View Profile",
                              onPressed: () {
                                _launchURL(cardList[index].website);
                              },
                            )
                          ],
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            cardList[index].name.isNotEmpty
                                ? Text(
                                    cardList[index].name,
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  )
                                : SizedBox(),
                            Text(
                              cardList[index].userName,
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            SizedBox(
                              width: _deviceWidth / 1.7,
                              child: Text(
                                cardList[index].desc == ''
                                    ? 'Contributor'
                                    : cardList[index].desc,
                                style: Theme.of(context).textTheme.bodyText2,
                                maxLines: 2,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            cardList[index].location.isNotEmpty
                                ? Row(
                                    children: [
                                      Icon(
                                        Feather.map_pin,
                                        size: 14,
                                      ),
                                      Text(
                                        cardList[index].location,
                                        softWrap: true,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox(),
                            cardList[index].location.isNotEmpty
                                ? SizedBox(
                                    height: 5,
                                  )
                                : SizedBox(),
                            if (cardList[index].twitterUsername.isNotEmpty)
                              GestureDetector(
                                onTap: () {
                                  _launchURL('https://twitter.com/' +
                                      cardList[index].twitterUsername);
                                },
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 14,
                                      width: 14,
                                      child: Image.network(
                                        'https://img.icons8.com/fluent-systems-filled/344/twitter.png',
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      Icons.alternate_email,
                                      size: 14,
                                      color: Colors.blueAccent,
                                    ),
                                    Text(
                                      cardList[index].twitterUsername,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.blueAccent),
                                    ),
                                  ],
                                ),
                              )
                            else
                              SizedBox(),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

Future<List<ContributorCard>> getContributors(
    {@required String username, @required String repository}) async {
  const String head = 'https://api.github.com/repos/';
  const String tail = '/contributors';
  String url = head + username + '/' + repository + tail;
  http.Response response = await http.get(url);
  List<Contributor> contributors = contributorFromJson(response.body);
  List<ContributorCard> contriCards = [];
  for (final contributor in contributors) {
    http.Response contributorResponse =
        await http.get('https://api.github.com/users/' + contributor.login);
    ContributorDetail contributorDetail =
        contributorDetailFromJson(contributorResponse.body);
    contriCards.add(
      ContributorCard(
        userName: contributor.login,
        name: contributorDetail.name ?? '',
        desc: contributorDetail.bio ?? '',
        location: contributorDetail.location ?? '',
        twitterUsername: contributorDetail.twitterUsername ?? '',
        displayImgUrl: contributorDetail.avatarUrl,
        website: contributorDetail.blog.isEmpty
            ? contributorDetail.htmlUrl
            : contributorDetail.blog,
      ),
    );
  }

  return contriCards;
}

_launchURL(String gurl) async {
  String url = gurl;
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
