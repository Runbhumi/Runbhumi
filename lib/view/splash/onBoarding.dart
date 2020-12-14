import 'package:Runbhumi/view/views.dart';
import 'package:Runbhumi/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).push(
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
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "Heading 1",
          body: "something something something blah blah blah",
          image: _buildImage('sports-illustration1'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Heading 2",
          body: "some more something and blah blah blah",
          image: _buildImage('sports-illustration1'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Thor is the best avenger",
          body: "change my mind",
          image: _buildImage('sports-illustration1'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Another title page",
          body: "Another beautiful body text for this example onboarding",
          image: _buildImage('sports-illustration1'),
          footer: Button(
            myColor: Theme.of(context).primaryColor,
            onPressed: () {
              introKey.currentState?.animateScroll(0);
            },
            myText: "abcdefg",
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Give us money by buying event tickets",
          bodyWidget: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("Click on", style: bodyStyle),
              Icon(Icons.info_outline),
              Flexible(
                child: Text(
                  " to get to know that events are a premium thing",
                  style: bodyStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          image: _buildImage('sports-illustration1'),
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
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
