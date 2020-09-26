import 'package:Runbhumi/utils/Constants.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Widget _buildTitle(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Profile',
            style: TextStyle(
                fontWeight: FontWeight.w700, fontSize: 30, color: Colors.black),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
  }

  void toggle() => animationController.isDismissed
      ? animationController.forward()
      : animationController.reverse();

  final double maxSlide = 225.0;

  @override
  Widget build(BuildContext context) {
    var myDrawer = SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          elevation: 0,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.clear,
                  color: Colors.white,
                ),
                onPressed: toggle,
              );
            },
          ),
        ),
        body: Column(
          children: [
            RaisedButton.icon(
              onPressed: () {
                print("logout");
                Constants.prefs.setBool("loggedIn", false);
                Navigator.pushReplacementNamed(context, "/secondpage");
              },
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(0))),
              label: Text(
                'Log out',
                style: TextStyle(color: Colors.white),
              ),
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              textColor: Colors.white,
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
    var myChild = Scaffold(
      appBar: AppBar(
        title: _buildTitle(context),
        centerTitle: true,
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.black,
              ),
              onPressed: toggle,
            );
          },
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(children: []),
    );
    return AnimatedBuilder(
        animation: animationController,
        builder: (context, _) {
          double slide = maxSlide * animationController.value;
          double scale = 1 - (animationController.value * 0.3);
          return Stack(
            children: [
              myDrawer,
              Transform(
                child: myChild,
                transform: Matrix4.identity()
                  ..translate(slide)
                  ..scale(scale),
                alignment: Alignment.centerLeft,
              ),
            ],
          );
        });
  }
}
