import 'dart:io';
import 'package:Runbhumi/utils/Constants.dart';
import 'package:Runbhumi/view/views.dart';
import 'package:Runbhumi/widget/button.dart';
import 'package:Runbhumi/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Uploader extends StatefulWidget {
  final File? file;

  Uploader({Key? key, this.file}) : super(key: key);

  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://runbhumi-574fe.appspot.com/');
  // String imageURL =
  //     "https://firebasestorage.googleapis.com/v0/b/runbhumi-574fe.appspot.com/o/ProfieImage%2F";
  StorageUploadTask _uploadTask;
  StorageReference ref;
  late String filePath;
  String url = "";

  /// Starts an upload task
  _startUpload() async {
    /// Unique file name for the file
    String fileDirectory = 'ProfileImage/';
    filePath =
        '${DateTime.now()}' + Constants.prefs.getString('userId')! + '.png';
    setState(() {
      ref = _storage.ref().child(fileDirectory + filePath);
      _uploadTask = ref.putFile(widget.file);
    });
    var dowurl = await (await _uploadTask.onComplete).ref.getDownloadURL();
    url = dowurl.toString();
  }

  @override
  Widget build(BuildContext context) {
    //String imageUrl;
    if (_uploadTask != null) {
      /// Manage the task state and event subscr  aiption with a StreamBuilder
      return StreamBuilder<StorageTaskEvent>(
          stream: _uploadTask.events,
          builder: (context, snapshot) {
            var event = snapshot.data?.snapshot;

            double progressPercent = event != null
                ? event.bytesTransferred / event.totalByteCount
                : 0;

            return Column(
              children: [
                if (_uploadTask.isComplete)
                  Button(
                    buttonTitle: "Success",
                    bgColor: Theme.of(context).accentColor,
                    onPressed: () => {
                      url != null
                          ? Constants.prefs.setString('profileImage', url)
                          : Loader(),
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfile())),
                    },
                  ),
                // Future.delayed(Duration(seconds: 3), ()=>{
                //  Navigator.push(context,MaterialPageRoute(builder: (context) => EditProfile()))
                // }

                // Progress bar
                LinearProgressIndicator(value: progressPercent),
                Text('${(progressPercent * 100).toStringAsFixed(2)} % '),
              ],
            );
          });
    } else {
      // Allows user to decide when to start the upload
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Button(
          buttonTitle: 'Upload to Firebase',
          bgColor: Theme.of(context).primaryColor,
          // icon: Icon(Icons.cloud_upload),
          onPressed: _startUpload,
        ),
      );
    }
  }
}
