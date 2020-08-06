import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class PickAndCrop extends StatefulWidget {
  @override
  _PickAndCropState createState() => _PickAndCropState();
}

class _PickAndCropState extends State<PickAndCrop> {
  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    File croppedFile = await ImageCropper.cropImage(
      sourcePath: pickedFile.path,
      maxWidth: 512,
      maxHeight: 512,
    );

    //Compress the image

    var result = await FlutterImageCompress.compressAndGetFile(
      croppedFile.path,
      _image.path,
      quality: 50,
    );

    setState(() {
      _image = result;
      print(_image.lengthSync());
    });

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Example'),
      ),
      body: Center(
        child: _image == null ? Text('No image selected.') : Image.file(_image),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
