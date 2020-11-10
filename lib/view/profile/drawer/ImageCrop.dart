import 'dart:io';
import 'package:Runbhumi/services/ImageUpload.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageCapture extends StatefulWidget {
  @override
  createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  /// Active image file
  File _imageFile;

  /// Cropper plugin
  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
      sourcePath: _imageFile.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.blueAccent,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
    );

    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  Future<Null> _pickImage(ImageSource source) async {
    final selected = await ImagePicker().getImage(source: source);
    if (selected != null) {
      setState(() {
        _imageFile = File(selected.path);
      });
    }
  }

  // Select an image via gallery or camera
  // Future<void> _pickImage(ImageSource source) async {
  //   File selected = await ImagePicker.pickImage(source: source);

  //   setState(() {
  //     _imageFile = selected;
  //   });
  // }

  /// Remove image
  void _clear() {
    setState(() => _imageFile = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        actions: [
          IconButton(
            icon: Icon(Feather.camera, semanticLabel: "Camera"),
            onPressed: () => _pickImage(ImageSource.camera),
          ),
          IconButton(
            icon: Icon(Feather.folder, semanticLabel: "Open from gallery"),
            onPressed: () => _pickImage(ImageSource.gallery),
          ),
        ],
      ),
      // Select an image from the camera or gallery
      // bottomNavigationBar: BottomAppBar(
      //   child: Row(
      //     children: <Widget>[
      //       IconButton(
      //         icon: Icon(Icons.photo_camera),
      //         onPressed: () => _pickImage(ImageSource.camera),
      //       ),
      //       IconButton(
      //         icon: Icon(Icons.photo_library),
      //         onPressed: () => _pickImage(ImageSource.gallery),
      //       ),
      //     ],
      //   ),
      // ),

      // Preview the image and crop it
      body: ListView(
        children: <Widget>[
          if (_imageFile != null) ...[
            Image.file(_imageFile),
            Container(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // color: Theme.of(context).accentColor.withOpacity(0.3),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.crop),
                      onPressed: _cropImage,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // color: Theme.of(context).accentColor.withOpacity(0.3),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.refresh),
                      onPressed: _clear,
                    ),
                  ),
                ],
              ),
            ),
            Uploader(file: _imageFile)
          ] else
            Center(
              child: Image(
                image: AssetImage('assets/addpostillustration.png'),
              ),
            ),
        ],
      ),
    );
  }
}
