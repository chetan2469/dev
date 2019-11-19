import 'dart:io';
import 'dart:math' as Math;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ims/constants/constants.dart';
import 'package:ims/data/course_record.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddStudInfo extends StatefulWidget {
  @override
  _AddStudInfo createState() => _AddStudInfo();
}

class _AddStudInfo extends State<AddStudInfo> {
  TextEditingController namefieldController = TextEditingController();
  TextEditingController addressfieldController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController optionalNoController = TextEditingController();
  TextEditingController aadharfieldController = TextEditingController();
  TextEditingController batchController = TextEditingController();

  bool validator1 = true,
      validator2 = true,
      validator3 = true,
      validator4 = true,
      validator5 = true,
      validator6 = true,
      validator7 = true,
      togg = false;
  FirebaseUser user;
  List<String> courseList = List();
  bool processing = false, status = true;
  DateTime dob, today = DateTime.now();
  DateTime _fromDay = new DateTime(
      DateTime.now().year - 18, DateTime.now().month, DateTime.now().day);
  String thumbnail, course;
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
    String __tempName = namefieldController.text,
        __date = DateTime.now().toString();

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

    fetchCourseData();
    cFirebaseAuth.currentUser().then(
          (user) => setState(() {
            this.user = user;
          }),
        );
  }

  fetchCourseData() async {
    setState(() {
      processing = true;
      courseList.clear();
    });
    final QuerySnapshot result =
        await Firestore.instance.collection('courses').getDocuments();

    final List<DocumentSnapshot> documents = result.documents;
    documents.forEach((data) {
      final record = CourseRecord.fromSnapshot(data);
      courseList.add(record.name);
    });

    setState(() {
      processing = false;
    });

    courseList.sort((a, b) {
      return a.toLowerCase().compareTo(b.toLowerCase());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent.withOpacity(0.7),
        title: Text(
          "Admission",
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
                        if (course != null &&
                            namefieldController.text.length != 0 &&
                            addressfieldController.text.length != 0 &&
                            mobileController.text.length != 0 &&
                            aadharfieldController.text.length != 0 &&
                            batchController.text.length != 0) {
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
                        margin: EdgeInsets.all(50),
                        child: CircleAvatar(
                          //radius: 20,
                          backgroundImage: _imageFile != null
                              ? FileImage(_imageFile)
                              : AssetImage('assets/placeholder.png'),
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
              ListTile(
                title: Text('Choose Course'),
                trailing: DropdownButton<String>(
                  hint: course == null ? Text('choose course') : null,
                  value: course,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  onChanged: (String str) {
                    setState(() {
                      course = str;
                    });
                  },
                  items:
                      courseList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
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
    );
  }

  void insert() async {
    Firestore.instance.collection('admission').document().setData({
      'name': namefieldController.text,
      'address': addressfieldController.text,
      'mobileNo': mobileController.text,
      'optNumber': optionalNoController.text,
      'dateOfBirth': _fromDay,
      'aadharNo': aadharfieldController.text,
      'courseName': course,
      'batchTime': batchController.text,
      'imageUrl': thumbnail,
      'addedBy': user.email,
      'addDate': today,
      'status': status,
    });
    print(status);
    Navigator.pop(context);
  }
}

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

  void addCourseDialogue(String mob, context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.all(5),
                    child: ListTile(
                      title: Text(
                        'Call',
                        style: TextStyle(fontSize: 20),
                      ),
                      leading: Icon(Icons.call),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.all(5),
                    child: ListTile(
                      title: Text(
                        'Call',
                        style: TextStyle(fontSize: 20),
                      ),
                      leading: Icon(Icons.call),
                    ),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                label: Text('close'),
                icon: Icon(
                  Icons.cancel,
                ),
              )
            ],
          );
        });
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
