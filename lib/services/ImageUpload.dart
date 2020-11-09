import 'dart:io';
import 'package:Runbhumi/utils/Constants.dart';
import 'package:Runbhumi/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Uploader extends StatefulWidget {
  final File file;

  Uploader({Key key, this.file}) : super(key: key);

  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://runbhumi-574fe.appspot.com/');
  final String fbStorage = "";

  StorageUploadTask _uploadTask;

  /// Starts an upload task
  _startUpload() {
    /// Unique file name for the file
    String filePath = 'ProfileImage/${DateTime.now()}' +
        Constants.prefs.getString('userId') +
        '.png';
    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      /// Manage the task state and event subscription with a StreamBuilder
      return StreamBuilder<StorageTaskEvent>(
          stream: _uploadTask.events,
          builder: (_, snapshot) {
            var event = snapshot?.data?.snapshot;
            //String image = snapshot.getDownloadUrl().toString();
            double progressPercent = event != null
                ? event.bytesTransferred / event.totalByteCount
                : 0;

            return Column(
              children: [
                if (_uploadTask.isComplete)
                  Button(
                    myText: "Success",
                    myColor: Theme.of(context).accentColor,
                    onPressed: () => {
                      // TODO: PASS THE LINK TO THE EDIT PROFILE PAGE
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) =>
                      //             EditProfile(filePath: filePath))),
                    },
                  ),
                // Future.delayed(Duration(seconds: 3), ()=>{
                //  Navigator.push(context,MaterialPageRoute(builder: (context) => EditProfile()))
                // }

                if (_uploadTask.isPaused)
                  FlatButton(
                    child: Icon(Icons.play_arrow),
                    onPressed: _uploadTask.resume,
                  ),

                if (_uploadTask.isInProgress)
                  FlatButton(
                    child: Icon(Icons.pause),
                    onPressed: _uploadTask.pause,
                  ),

                // Progress bar
                LinearProgressIndicator(value: progressPercent),
                Text('${(progressPercent * 100).toStringAsFixed(2)} % '),
              ],
            );
          });
    } else {
      // Allows user to decide when to start the upload
      return FlatButton.icon(
        label: Text('Upload to Firebase'),
        icon: Icon(Icons.cloud_upload),
        onPressed: _startUpload,
      );
    }
  }
}
