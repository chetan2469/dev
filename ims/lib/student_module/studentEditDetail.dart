import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:math' as Math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ims/data/record.dart';
import 'package:ims/viewImage.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class StudentDetails extends StatefulWidget {
  Record record;

  StudentDetails(this.record);
  @override
  _StudentDetails createState() => _StudentDetails(this.record);
}

class _StudentDetails extends State<StudentDetails> {
  final Record record;

  _StudentDetails(this.record);

  TextEditingController namefieldController = TextEditingController();
  TextEditingController addressfieldController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController optionalNoController = TextEditingController();
  TextEditingController aadharfieldController = TextEditingController();
  TextEditingController courseController = TextEditingController();
  TextEditingController batchController = TextEditingController();

  bool validator1 = true,
      validator2 = true,
      validator3 = true,
      validator4 = true,
      validator5 = true,
      validator6 = true,
      validator7 = true,
      togg = false;
  bool processing = false, status;
  DateTime dob, addDate;
  DateTime _fromDay = new DateTime(
      DateTime.now().year - 18, DateTime.now().month, DateTime.now().day);
  String thumbnail;
  File _imageFile;
  String photourl;
  bool flag = true;

  Future<Null> _pickImageFromGallery() async {
    print("___________________________________________");
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    imageFile = await compressFile(imageFile, imageFile.path);
    setState(() {
      this._imageFile = imageFile;
      flag = false;
    });
  }

  Future<Null> _pickImageFromCamera() async {
    print("___________________________________________");
    File imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    imageFile = await compressFile(imageFile, imageFile.path);
    setState(() {
      this._imageFile = imageFile;
      flag = false;
    });
  }

  Future<File> compressFile(File file, String targetPath) async {
    print(file.lengthSync().toString() + "________________FILE______________");

    var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path, targetPath,
        quality: 60, minHeight: 400, minWidth: 400);

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
                  setState(() {
                    _pickImageFromCamera();
                  });
                  Navigator.pop(context);
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
                  setState(() {
                    _pickImageFromGallery();
                  });
                  Navigator.pop(context);
                },
                child: ListTile(
                  leading: Icon(Icons.image),
                  title: Text(
                    'Gallery',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewImage(photourl)));
                },
                child: ListTile(
                  leading: Icon(Icons.image),
                  title: Text(
                    'View',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              )
            ],
          );
        });
  }

  Future<String> _uploadFile() async {
    setState(() {
      processing = true;
    });
    int __rand = new Math.Random().nextInt(10000);

    final Directory systemTempDir = Directory.systemTemp;
    String __tempName = namefieldController.text,
        __date = DateTime.now().toString();

    final StorageReference ref = FirebaseStorage.instance
        .ref()
        .child("$__tempName _ $addDate _ $__rand.jpg");
    final StorageUploadTask uploadTask = ref.put(_imageFile);

    var downurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    thumbnail = downurl.toString();
    photourl = downurl.toString();
    update();
  }

  @override
  void initState() {
    super.initState();
    namefieldController.text = record.name;
    addressfieldController.text = record.address;
    mobileController.text = record.mobileno;
    optionalNoController.text = record.optionalno;
    aadharfieldController.text = record.aadharno;
    courseController.text = record.coursename;
    batchController.text = record.batchtime;
    photourl = record.imageurl;
    _fromDay = record.dateofbirth.toDate();
    addDate = record.addDate.toDate();
    status = record.status;
  }

  Future<void> alertDialogue(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: ListTile(
            title: Text(
              'Delete Student??',
              style: TextStyle(fontSize: 25),
            ),
            leading: Icon(
              Icons.delete_forever,
              color: Colors.red,
              size: 30,
            ),
          ),
          content: const Text('This item will not able to recover after delete',
              style: TextStyle(fontSize: 20)),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
                delete();
              },
            ),
            FlatButton(
              child: Text('Cancle'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        drawer: Drawer(),
        appBar: AppBar(
          actions: <Widget>[
            InkWell(
              onTap: () {
                alertDialogue(context);
              },
              child: Container(
                child: Icon(
                  Icons.delete_forever,
                  color: Colors.red,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                child: processing
                    ? CircularProgressIndicator()
                    : Icon(Icons.close),
                padding: EdgeInsets.all(15),
              ),
            ),
          ],
          backgroundColor: Colors.white,
          title: Text(
            "Student Details",
            style: TextStyle(fontSize: 25, color: Colors.black),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.check_circle),
          onPressed: () {
            setState(() {
              if (flag == true) {
                update();
              } else {
                _uploadFile();
              }
            });
            //_uploadFile();
          },
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
                      flex: 1,
                      child: Container(),
                    ),
                    Expanded(
                      flex: 2,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _showDialog(context);
                          });
                        },
                        child: Container(
                          height: 200,
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: new CachedNetworkImageProvider(photourl),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Transform.scale(
                          scale: 2.5,
                          child: Checkbox(
                            checkColor: Colors.white,
                            activeColor: Colors.greenAccent,
                            value: status,
                            onChanged: (bool b) {
                              setState(() {
                                status = b;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: namefieldController,
                  onChanged: (String str1) {
                    if (str1.length < 3) {
                      setState(() {
                        validator1 = false;
                      });
                    } else {
                      setState(() {
                        validator1 = true;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    errorText: !validator1
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
                TextField(
                  maxLines: 2,
                  controller: addressfieldController,
                  onChanged: (String str2) {
                    if (str2.length < 3) {
                      setState(() {
                        validator2 = false;
                      });
                    } else {
                      setState(() {
                        validator2 = true;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    errorText: !validator2
                        ? "Address Should be greater than 3 characters"
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    labelText: "Address",
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: mobileController,
                  onChanged: (String str3) {
                    if (str3.length != 10) {
                      setState(() {
                        validator3 = false;
                      });
                    } else {
                      setState(() {
                        validator3 = true;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    errorText: !validator3
                        ? "Mobile Number should be of 10 digit"
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    labelText: "Mobile No",
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: optionalNoController,
                  onChanged: (String str4) {
                    if (str4.length != 10) {
                      setState(() {
                        validator4 = false;
                      });
                    } else {
                      setState(() {
                        validator4 = true;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    errorText: !validator4
                        ? "Mobile Number should be of 10 digit"
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    labelText: "Optional Number",
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                DateTimePicker(
                  labelText: 'Date Of Birthday',
                  selectedDate: _fromDay,
                  selectDate: (DateTime date) {
                    setState(() {
                      _fromDay = date;
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: aadharfieldController,
                  onChanged: (String str5) {
                    if (str5.length != 12) {
                      setState(() {
                        validator5 = false;
                      });
                    } else {
                      setState(() {
                        validator5 = true;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    errorText: !validator5
                        ? "Aadhar Number should be of 12 digit"
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    labelText: "Aadhar Card No",
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: courseController,
                  onChanged: (String str6) {
                    if (str6.length < 3) {
                      setState(() {
                        validator6 = false;
                      });
                    } else {
                      setState(() {
                        validator6 = true;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    errorText: !validator6
                        ? "Course Name Should be greater than 3 characters"
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    labelText: "Course Name",
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  maxLines: 5,
                  controller: batchController,
                  onChanged: (String str7) {
                    if (str7.length < 3) {
                      setState(() {
                        validator7 = false;
                      });
                    } else {
                      setState(() {
                        validator7 = true;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    errorText: !validator7
                        ? "Batch Time Should be greater than 3 characters"
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    labelText: "Batch Time",
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //update========================================================================

  void update() async {
    Firestore.instance
        .collection('admission')
        .document(record.reference.documentID)
        .setData({
      'name': namefieldController.text,
      'address': addressfieldController.text,
      'mobileNo': mobileController.text,
      'optNumber': optionalNoController.text,
      'aadharNo': aadharfieldController.text,
      'courseName': courseController.text,
      'batchTime': batchController.text,
      'imageUrl': photourl,
      'dateOfBirth': _fromDay,
      'addDate': addDate,
      'status': status,
    });
    Navigator.pop(context);
  }

  void delete() async {
    Firestore.instance
        .collection('admission')
        .document(record.reference.documentID)
        .delete();
    Navigator.pop(context);
  }
}

// date picker ====================================================================

class DateTimePicker extends StatelessWidget {
  const DateTimePicker({
    Key key,
    this.labelText,
    this.selectedDate,
    this.selectDate,
  }) : super(key: key);
  final String labelText;
  final DateTime selectedDate;
  final ValueChanged<DateTime> selectDate;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1960, 1),
      lastDate: DateTime(2002),
    );
    if (picked != null && picked != selectedDate) selectDate(picked);
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.title;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          flex: 4,
          child: InputDropdown(
            labelText: labelText,
            valueText: DateFormat.yMMMd().format(selectedDate),
            valueStyle: valueStyle,
            onPressed: () {
              _selectDate(context);
            },
          ),
        ),
        //const SizedBox(width: 0.0),
      ],
    );
  }
}

class InputDropdown extends StatelessWidget {
  const InputDropdown({
    Key key,
    this.child,
    this.labelText,
    this.valueText,
    this.valueStyle,
    this.onPressed,
  }) : super(key: key);
  final String labelText;
  final String valueText;

  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: InputDecorator(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          labelText: labelText,
        ),
        baseStyle: valueStyle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(valueText, style: valueStyle),
            Icon(
              Icons.arrow_drop_down,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey.shade700
                  : Colors.white70,
            ),
          ],
        ),
      ),
    );
  }
}
