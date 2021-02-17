import 'package:Runbhumi/utils/Constants.dart';
import 'package:Runbhumi/view/views.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Constants.prefs.setString("firsttime", "done");
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => GauthPage()),
    );
  }

  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset('assets/$assetName.png', width: 350.0),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.only(top: 50),
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "Find friends",
          body: "Find real friends nearby you to play with you",
          image: _buildImage('sports-illustration1'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Have the sporty discussions",
          body: "Chat with friends and teammates and schedule events with them",
          image: _buildImage('chatting_illustration'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Get notifications",
          body:
              "Recieve notifications about event requests, friend requests and much more",
          image: _buildImage('notifications'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Add teams and Events",
          body: "Create and join teams and events nearby you",
          image: _buildImage('post_online'),
          // footer: Button(
          //   myColor: Theme.of(context).primaryColor,
          //   onPressed: () {
          //     introKey.currentState?.animateScroll(0);
          //   },
          //   myText: "abcdefg",
          // ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Connect | Schedule | Play",
          body: "Get out of the digital zone",
          image: _buildImage('real_life'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        activeColor: Color(0xff2DADC2),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
