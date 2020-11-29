// import 'dart:async';

import 'dart:async';
import 'package:Runbhumi/utils/Constants.dart';
import 'package:Runbhumi/view/profile/drawer/ImageCrop.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:Runbhumi/widget/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';
// import 'package:image_cropper/image_cropper.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool _hiddenSwitch = true;
  bool _loading = false;
  TextEditingController nameTextEditingController = new TextEditingController();
  TextEditingController bioTextEditingController = new TextEditingController();
  TextEditingController ageTextEditingController = new TextEditingController();
  TextEditingController phoneNumberTextEditingController =
      new TextEditingController();
  TextEditingController locationTextEditingController =
      new TextEditingController();
  int age = 0;
  final db = FirebaseFirestore.instance;
  StreamSubscription sub;
  Map data;
  @override
  void initState() {
    super.initState();
    // Firebase.initializeApp().whenComplete(() {
    //   print("profile body loaded");
    //   setState(() {});
    // });
    sub = db
        .collection('users')
        .doc(Constants.prefs.getString('userId'))
        .snapshots()
        .listen((snap) {
      setState(() {
        data = snap.data();
        nameTextEditingController.text = data['name'];
        bioTextEditingController.text = data['bio'];
        ageTextEditingController.text = data['age'];
        locationTextEditingController.text = data['location'];
        phoneNumberTextEditingController.text = data['phoneNumber']['ph'];
        _hiddenSwitch = data['phoneNumber']['show'];
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
    if (_loading) {
      return Scaffold(
        appBar: AppBar(
          title: buildTitle(context, "Edit Profile"),
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
                  onTap: () {
                    print("upload image");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ImageCapture()));
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
                                Constants.prefs.getString('profileImage')),

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
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
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
                  controller: nameTextEditingController,
                  textInputType: TextInputType.name,
                  hintText: 'Name',
                ),
                InputBox(
                  controller: bioTextEditingController,
                  textInputType: TextInputType.multiline,
                  helpertext: 'Use at max 200 characters',
                  hintText: 'Bio',
                ),
                InputBox(
                  controller: ageTextEditingController,
                  textInputType: TextInputType.number,
                  hintText: 'Age',
                ),

                //Phone Number switch row
                Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: InputBox(
                        controller: phoneNumberTextEditingController,
                        // obscureText: _hiddenSwitch,
                        textInputType: TextInputType.phone,
                        hintText: 'Phone Number',
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'show',
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
                  controller: locationTextEditingController,
                  textInputType: TextInputType.streetAddress,
                  hintText: 'Location',
                ),

                //Switch button
                Button(
                  myText: 'Save Profile',
                  myColor: Theme.of(context).primaryColor,
                  onPressed: () async {
                    Map<String, dynamic> phoneNumber = {
                      "ph": phoneNumberTextEditingController.text,
                      "show": _hiddenSwitch,
                    };
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(Constants.prefs.get('userId'))
                        .update({
                      'profileImage': Constants.prefs.getString('profileImage'),
                      'name': nameTextEditingController.text,
                      'bio': bioTextEditingController.text,
                      'age': ageTextEditingController.text,
                      'phoneNumber': phoneNumber,
                      'location': locationTextEditingController.text,
                    });

                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  height: 16,
                )
              ],
            ),
          ),
        ),
      );
    } else {
      return Loader();
    }
  }
}

// class ImageCapture extends StatefulWidget {
//   @override
//   _ImageCaptureState createState() => _ImageCaptureState();
// }

// class _ImageCaptureState extends State<ImageCapture> {
//   File _imageFile;

//   Future<void> _pickImage(ImageSource source) async {
//     File selected =  await ImagePicker.platform.pickImage(source: source);
//     setState(() {
//       _imageFile = selected;
//     });
//   }

//   Future<void> _cropImage() async {
//     File cropped = await ImageCropper.cropImage(sourcePath: _imageFile.path);
//     setState(() {
//       _imageFile = cropped ?? _imageFile;
//     });
//   }

//   void _clear() {
//     setState(() {
//       _imageFile = null;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: BottomAppBar(
//         child: Row(
//           children: [
//             IconButton(
//               icon: Icon(Icons.camera),
//               onPressed: () {
//                 _pickImage(ImageSource.camera);
//               },
//             ),
//             IconButton(
//               icon: Icon(Icons.picture_in_picture),
//               onPressed: () {
//                 _pickImage(ImageSource.gallery);
//               },
//             ),
//           ],
//         ),
//       ),
//       body: _imageFile != null
//           ? ListView(
//               children: [
//                 Image.file(_imageFile),
//                 Row(
//                   children: [
//                     FlatButton(
//                       child: Icon(Icons.crop),
//                       onPressed: _cropImage,
//                     ),
//                     FlatButton(
//                       child: Icon(Icons.clear),
//                       onPressed: _clear,
//                     ),
//                   ],
//                 ),
//                 Uploader(file: _imageFile)
//               ],
//             )
//           : Container(),
//     );
//   }
// }

// class Uploader extends StatefulWidget {
//   final File file;
//   Uploader({Key key, this.file}) : super(key: key);
//   @override
//   _UploaderState createState() => _UploaderState();
// }

// class _UploaderState extends State<Uploader> {
//   final FirebaseStorage _storage =
//       FirebaseStorage(storageBucket: 'gs://runbhumi-574fe.appspot.com');

//   StorageUploadTask _uploadTask;
//   void _startUpload() {
//     String filePath = 'images/${Constants.prefs.get('userId')}.png';
//     setState(() {
//       _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_uploadTask != null) {
//       return StreamBuilder<StorageTaskEvent>(
//         stream: _uploadTask.events,
//         builder: (context, snapshot) {
//           var event = snapshot?.data?.snapshot;
//           double uploadpercent =
//               event != null ? event.bytesTransferred / event.totalByteCount : 0;
//           return Column(
//             children: [
//               if (_uploadTask.isComplete) Text("done"),
//               if (_uploadTask.isInProgress)
//                 FlatButton(
//                   child: Icon(Icons.clear),
//                   onPressed: _uploadTask.pause,
//                 ),
//               if (_uploadTask.isPaused)
//                 FlatButton(
//                   child: Icon(Icons.play_arrow),
//                   onPressed: _uploadTask.resume,
//                 ),
//               LinearProgressIndicator(
//                 value: uploadpercent,
//               ),
//               Text('${(uploadpercent * 100).toStringAsFixed(2)}%'),
//             ],
//           );
//         },
//       );
//     } else {
//       return FlatButton(
//           onPressed: _startUpload, child: Icon(Icons.upload_file));
//     }
//   }
// }
