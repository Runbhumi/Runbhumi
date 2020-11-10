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

  StorageUploadTask _uploadTask;
  StorageReference ref;

  /// Starts an upload task
  _startUpload() {
    /// Unique file name for the file
    String filePath = 'ProfileImage/${DateTime.now()}' +
        Constants.prefs.getString('userId') +
        '.png';
    setState(() {
      ref = _storage.ref().child(filePath);
      _uploadTask = ref.putFile(widget.file);
    });
  }

  @override
  Widget build(BuildContext context) {
    //String imageUrl;
    if (_uploadTask != null) {
      /// Manage the task state and event subscription with a StreamBuilder
      return StreamBuilder<StorageTaskEvent>(
          stream: _uploadTask.events,
          builder: (context, snapshot) {
            var event = snapshot?.data?.snapshot;

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
                      // imageUrl = event.ref.getDownloadURL(),
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) =>
                      //             EditProfile(filePath: imageUrl))),
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
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Button(
          myText: 'Upload to Firebase',
          myColor: Theme.of(context).primaryColor,
          // icon: Icon(Icons.cloud_upload),
          onPressed: _startUpload,
        ),
      );
    }
  }
}
