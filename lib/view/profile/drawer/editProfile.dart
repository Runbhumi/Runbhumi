import 'package:flutter/material.dart';
import 'package:Runbhumi/widget/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';

// TODO: add text controllers and a form
//TODO: connect to backend
class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool _hiddenSwitch = true;

  Widget _buildTitle(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Edit Profile',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 25,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildTitle(context),
        leading: BackButton(),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height -
            56 -
            MediaQuery.of(context).padding.top,
        padding: EdgeInsets.symmetric(horizontal: 40.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //The photo Stack
              GestureDetector(
                //TODO: upload image funtion
                onTap: () {
                  print("upload image");
                },
                child: Stack(
                  children: [
                    Container(
                      //  constraints: BoxConstraints(maxHeight: 150, maxWidth: 150.0),
                      width: 180,
                      height: 180,
                      // margin: EdgeInsets.only(top: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        image: DecorationImage(
                          // now only assets image
                          image: NetworkImage(
                              "https://pbs.twimg.com/profile_images/1286371379768516608/KKBFYV_t.jpg"),
                          fit: BoxFit.fill,
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
                    Container(
                        height: 180,
                        width: 180,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              const Color(0xff393e46),
                              const Color(0x00393e46)
                            ],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(
                                FlutterIcons.upload_fea,
                                color: Colors.white,
                              ),
                              onPressed: null,
                            ),
                            Text(
                              'Upload image',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                            SizedBox(
                              height: 10.0,
                            )
                          ],
                        ))
                  ],
                ),
              ),
              InputBox(
                textInputType: TextInputType.name,
                hintText: 'Name',
              ),
              InputBox(
                textInputType: TextInputType.multiline,
                helpertext: 'Use at max 200 characters',
                hintText: 'Bio',
              ),
              InputBox(
                textInputType: TextInputType.number,
                hintText: 'Age',
              ),

              //Phone Number switch row
              Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: InputBox(
                      obscureText: _hiddenSwitch,
                      textInputType: TextInputType.phone,
                      hintText: 'Phone Number',
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'hide',
                        style: TextStyle(fontSize: 12),
                      ),
                      Transform.scale(
                        scale: 0.8,
                        child: CupertinoSwitch(
                          activeColor: Theme.of(context).primaryColor,
                          value: _hiddenSwitch,

                          //use this event to toggle the text and the left phoneNumber field
                          onChanged: (value) {
                            setState(() {
                              _hiddenSwitch = value;
                            });
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
              InputBox(
                textInputType: TextInputType.streetAddress,
                hintText: 'Location',
              ),

              //Switch button
              Button(
                myText: 'Save Profile',
                myColor: Theme.of(context).primaryColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
