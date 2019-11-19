import 'package:flutter/material.dart';

import 'dart:io';
import 'dart:math' as Math;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ims/constants/constants.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddCourse extends StatefulWidget {
  @override
  _AddCourse createState() => _AddCourse();
}

class _AddCourse extends State<AddCourse> {
  FirebaseUser user;

  TextEditingController nameController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController feesController = TextEditingController();
  TextEditingController syllabusController = TextEditingController();
  TextEditingController teacherController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  bool nameValidator = true,
      feesValidator = true,
      durationValidator = true,
      teacherNameValidator = true,
      syllabusValidator = true,
      noteValidator = true;
  bool processing = false;
  String thumbnail;
  File _imageFile;
  String photourl =
      'http://www.stleos.uq.edu.au/wp-content/uploads/2016/08/image-placeholder.png';

  Future<Null> _pickImageFromGallery() async {
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    print("________________FILE______________");
    imageFile = await compressFile(imageFile, imageFile.path);
    print("________________FILE______________");
    imageFile.rename('');
    setState(() => this._imageFile = imageFile);
  }

  Future<Null> _pickImageFromCamera() async {
    File imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    print("________________FILE______________");
    imageFile = await compressFile(imageFile, imageFile.path);
    setState(() => this._imageFile = imageFile);
  }

  Future<File> compressFile(File file, String targetPath) async {
    print(file.lengthSync().toString() + "________________FILE______________");

    var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path, targetPath,
        quality: 40, minHeight: 400, minWidth: 400);

    print(result.lengthSync().toString() +
        "________________COMPRESS FILE______________");

    return result;
  }

  _showDialog(BuildContext context) async {
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _pickImageFromCamera();
                  });
                },
                child: ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text(
                    'Camera',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _pickImageFromGallery();
                  });
                },
                child: ListTile(
                  leading: Icon(Icons.image),
                  title: Text(
                    'Gallery',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              )
            ],
          );
        });
  }

  Future<void> _uploadFile() async {
    setState(() {
      processing = true;
    });
    int __rand = new Math.Random().nextInt(10000);

    final Directory systemTempDir = Directory.systemTemp;
    String __tempName = nameController.text, __date = DateTime.now().toString();

    final StorageReference ref = FirebaseStorage.instance
        .ref()
        .child("$__tempName _ $__date _ $__rand.jpg");

    final StorageUploadTask uploadTask = ref.put(_imageFile);

    var downurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    thumbnail = downurl.toString();
    print(thumbnail);
    insert();
    setState(() {
      processing = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      processing = false;
    });

    cFirebaseAuth.currentUser().then(
          (user) => setState(() {
            this.user = user;
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent.withGreen(100),
        title: Text(
          "Add Course",
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
        actions: <Widget>[
          Container(
              margin: EdgeInsets.all(10),
              child: processing
                  ? CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    )
                  : FlatButton(
                      color: Colors.white10,
                      child: Text(
                        'save',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      onPressed: () {
                        if (nameController.text.length != 0 &&
                            feesController.text.length != 0 &&
                            durationController.text.length != 0 &&
                            teacherController.text.length != 0 &&
                            syllabusController.text.length != 0) {
                          setState(() {
                            processing = true;
                          });
                          _uploadFile();
                        }
                      },
                    ))
        ],
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.grey[200],
      body: Container(
        margin: EdgeInsets.all(20),
        child: Center(
          child: ListView(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: 120,
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _showDialog(context);
                        });
                      },
                      child: Container(
                        height: 120,
                        child: CircleAvatar(
                          //radius: 20,
                          backgroundImage: _imageFile != null
                              ? FileImage(_imageFile)
                              : NetworkImage(photourl),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 120,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: nameController,
                onChanged: (String str1) {
                  if (str1.length < 3) {
                    setState(() {
                      nameValidator = false;
                    });
                  } else {
                    setState(() {
                      nameValidator = true;
                    });
                  }
                },
                decoration: InputDecoration(
                  errorText: !nameValidator
                      ? "Name Should be greater than 3 characters"
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelText: "Name",
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: 10),
                      child: TextField(
                        controller: feesController,
                        onChanged: (String str2) {
                          if (str2.length < 3) {
                            setState(() {
                              feesValidator = false;
                            });
                          } else {
                            setState(() {
                              feesValidator = true;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          errorText: !feesValidator
                              ? "Please Insert Fees of Course"
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          labelText: "Fees",
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: durationController,
                        onChanged: (String str3) {
                          if (str3.length < 2) {
                            setState(() {
                              durationValidator = false;
                            });
                          } else {
                            setState(() {
                              durationValidator = true;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          errorText: !durationValidator
                              ? "Please Insert Duration of Course"
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          labelText: "Duration in Hours",
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: teacherController,
                onChanged: (String str5) {
                  if (str5.length < 4) {
                    setState(() {
                      teacherNameValidator = false;
                    });
                  } else {
                    setState(() {
                      teacherNameValidator = true;
                    });
                  }
                },
                decoration: InputDecoration(
                  errorText: !teacherNameValidator
                      ? "Insert Teacher name for Course"
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelText: "Teacher Name",
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                maxLines: 10,
                keyboardType: TextInputType.number,
                controller: syllabusController,
                onChanged: (String str5) {
                  if (str5.length < 12) {
                    setState(() {
                      syllabusValidator = false;
                    });
                  } else {
                    setState(() {
                      syllabusValidator = true;
                    });
                  }
                },
                decoration: InputDecoration(
                  errorText: !syllabusValidator
                      ? "Insert Teacher name for Course"
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelText: "Syllabus",
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: noteController,
                onChanged: (String str5) {
                  if (str5.length < 2) {
                    setState(() {
                      noteValidator = true;
                      noteController.text = 'NO';
                    });
                  } else {
                    setState(() {
                      noteValidator = true;
                    });
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelText: "note",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void insert() async {
    Firestore.instance.collection('courses').document().setData({
      'name': nameController.text,
      'fees': feesController.text,
      'duration': durationController.text,
      'teacher': teacherController.text,
      'syllabus': syllabusController.text,
      'note': noteController.text,
      'addDate': DateTime.now(),
      'imageUrl': thumbnail,
      'addedBy': user.email,
    });
    Navigator.pop(context);
  }
}
