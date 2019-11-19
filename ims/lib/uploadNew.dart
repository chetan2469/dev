import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Storage Example',
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

 String photourl =
      'http://www.stleos.uq.edu.au/wp-content/uploads/2016/08/image-placeholder.png';

class _MyHomePageState extends State<MyHomePage> {
  File _imageFile;

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

  Future<Null> _uploadFile() async {
    
    final Directory systemTempDir = Directory.systemTemp;
    final StorageReference ref =
        FirebaseStorage.instance.ref().child("foo.jpg");

    final StorageUploadTask uploadTask = ref.put(_imageFile);
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          RaisedButton(
            child: Text("Gallery"),
            onPressed: () {
              _pickImageFromGallery();
            },
          ),
          RaisedButton(
            child: Text("Camera"),
            onPressed: (){
              _pickImageFromCamera();
            },
          ),
        ],
      ),
      body:_imageFile!=null?Image.file(_imageFile):Image.network(photourl),
      floatingActionButton: new FloatingActionButton(
        onPressed: _uploadFile,
        tooltip: 'Upload',
        child: new Icon(Icons.file_upload),
      ),
    );
  }
}