import 'package:Runbhumi/services/auth.dart';
import 'package:Runbhumi/utils/Constants.dart';
// import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
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
                fontWeight: FontWeight.w700, fontSize: 25, color: Colors.black),
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

  void toggle() {
    animationController.isDismissed
        ? animationController.forward()
        : animationController.reverse();
    print("menu toggle");
  }

  final double maxSlide = 225.0;
  final String profileImage =
      'https://media-exp1.licdn.com/dms/image/C4E03AQFzIb-FJrXyaQ/profile-displayphoto-shrink_200_200/0?e=1601510400&v=beta&t=yR_9RHWvRbGQ-AjfQvmTiVPLq5gDKmgxlZfB85IMC1w';

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
        body: DrawerBody(),
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
      body: ProfileBody(
        profileImage: profileImage,
        profileBio: "👨‍🎓 Student | 👨‍💻programmer | 👨‍🎨designer",
        profileName: "Hayat Tamboli",
      ),
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

class DrawerBody extends StatelessWidget {
  const DrawerBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FlatButton.icon(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          onPressed: () {
            // print("logout");
            // Constants.prefs.setBool("loggedIn", false);
            // signOutGoogle();
            // Navigator.pushReplacementNamed(context, "/secondpage");
          },
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(0))),
          label: Text(
            'Edit Profile',
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(
            Icons.edit_outlined,
            color: Colors.white,
          ),
          textColor: Colors.white,
          color: Theme.of(context).primaryColor,
        ),
        FlatButton.icon(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          onPressed: () {
            print("logout");
            Constants.prefs.setBool("loggedIn", false);
            signOutGoogle();
            Navigator.pushReplacementNamed(context, "/secondpage");
          },
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
        FlatButton.icon(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          onPressed: () {
            print("go to more info");
            Navigator.pushNamed(context, "/moreinfo");
          },
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(0))),
          label: Text(
            'More Info',
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(
            Icons.info_outline,
            color: Colors.white,
          ),
          textColor: Colors.white,
          color: Theme.of(context).primaryColor,
        ),
      ],
    );
  }
}

class ProfileBody extends StatelessWidget {
  const ProfileBody({
    Key key,
    this.profileImage,
    this.profileBio,
    this.profileName,
  }) : super(key: key);

  final String profileImage;
  final String profileBio;
  final String profileName;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (profileImage != null)
                Container(
                  width: 150,
                  height: 150,
                  margin: EdgeInsets.only(top: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    image: DecorationImage(
                      image: NetworkImage(profileImage),
                      fit: BoxFit.contain,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x3A353580),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  profileName,
                  style: TextStyle(fontSize: 24),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 8.0,
                  left: 16.0,
                  right: 16.0,
                ),
                child: Text(
                  profileBio,
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
