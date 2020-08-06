import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Demo extends StatefulWidget {
  @override
  _DemoState createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  File _imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: ListView(
        children: <Widget>[
          ButtonBar(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.photo_camera),
                onPressed: () async => await _pickImageFromCamera(),
                tooltip: 'Shoot picture',
              ),
              IconButton(
                icon: Icon(Icons.photo),
                onPressed: () async => await _pickImageFromGallery(),
                tooltip: 'Pick from gallery',
              ),
            ],
          ),
          this._imageFile == null ? Placeholder() : Image.file(this._imageFile),
        ],
      ),
    );
  }

  Future<Null> _pickImageFromGallery() async {
    final File imageFile =
        await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() => this._imageFile = imageFile);
  }

  Future<Null> _pickImageFromCamera() async {
    final File imageFile =
        await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() => this._imageFile = imageFile);
  }
}
