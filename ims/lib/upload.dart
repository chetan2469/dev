import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image/image.dart' as Im;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math' as Math;

class UploadImage extends StatefulWidget {
  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  File _imageFile;
  bool active = false;
  String thumbnail;
  bool processing = false;
  String photourl =
      'http://www.stleos.uq.edu.au/wp-content/uploads/2016/08/image-placeholder.png';

  Future uploadFile() async {
    setState(() {
      processing = true;
    });
    if (_imageFile != null) {
      final tempDir = await getTemporaryDirectory();
      final path = tempDir;
      int rand = new Math.Random().nextInt(10000);
      print('_____________length');
      print(_imageFile.lengthSync());

      Im.Image image = Im.decodeImage(_imageFile.readAsBytesSync());

      if (_imageFile.lengthSync() > 3000000) {
        _imageFile = new File('$path/img_$rand.jpg')
          ..writeAsBytesSync(Im.encodeJpg(image, quality: 10));
      } else if (_imageFile.lengthSync() > 2000000) {
        _imageFile = new File('$path/img_$rand.jpg')
          ..writeAsBytesSync(Im.encodeJpg(image, quality: 15));
      } else if (_imageFile.lengthSync() > 1500000) {
        _imageFile = new File('$path/img_$rand.jpg')
          ..writeAsBytesSync(Im.encodeJpg(image, quality: 17));
      } else if (_imageFile.lengthSync() > 1000000) {
        _imageFile = new File('$path/img_$rand.jpg')
          ..writeAsBytesSync(Im.encodeJpg(image, quality: 20));
      } else if (_imageFile.lengthSync() > 500000) {
        _imageFile = new File('$path/img_$rand.jpg')
          ..writeAsBytesSync(Im.encodeJpg(image, quality: 22));
      } else {
        _imageFile = new File('$path/img_$rand.jpg')
          ..writeAsBytesSync(Im.encodeJpg(image, quality: 23));
      }

      final StorageReference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('abc.jpg');
      StorageUploadTask task = firebaseStorageRef.putFile(_imageFile);
      var dowurl = await (await task.onComplete).ref.getDownloadURL();
      photourl = dowurl.toString();
      await compressImage();
    }
  }

  Future compressImage() async {
    File imageFile = _imageFile;
    final tempDir = await getTemporaryDirectory();
    final path = tempDir;
    int rand = new Math.Random().nextInt(10000);

    Im.Image image = Im.decodeImage(_imageFile.readAsBytesSync());
    Im.Image smallerImage = Im.gaussianBlur(Im.copyResize(image), 1);

    imageFile = new File('$path/img_$rand.jpg')
      ..writeAsBytesSync(Im.encodeJpg(smallerImage, quality: 80));
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('thumbnail.jpg');
    StorageUploadTask task = firebaseStorageRef.put(imageFile);

    var downurl = await (await task.onComplete).ref.getDownloadURL();
    thumbnail = downurl.toString();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          RaisedButton(
            child: Text("Upload"),
            onPressed: (){
              uploadFile();
            },
          )
        ],
      ),
      body: _imageFile!=null?Image.file(_imageFile):Image.network(photourl),
    );
  }
}