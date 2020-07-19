import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:math' as Math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ims/auth.dart';
import 'package:ims/constants/constants.dart';
import 'package:ims/courseModule/addCourseEntry.dart';
import 'package:ims/data/course_record.dart';
import 'package:ims/data/record.dart';
import 'package:ims/data/studentCourseEntry.dart';
import 'package:ims/showMenu.dart';
import 'package:ims/viewImage.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

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
  TextEditingController courseController = TextEditingController();
  TextEditingController batchController = TextEditingController();
  TextEditingController addCourseController = TextEditingController();
  TextEditingController outStandingAmountController = TextEditingController();

  int outStandingAmount = 0;

  bool validator1 = true,
      validator2 = true,
      validator3 = true,
      validator4 = true,
      validator5 = true,
      validator6 = true,
      validator7 = true,
      togg = false;
  bool processing = false, status = true, editing = false;
  DateTime dob, addDate = DateTime.now();
  String thumbnail;
  File _imageFile;
  String photourl =
          'https://ringwooddental.com.au/wp-content/uploads/2018/05/profile-placeholder-f-e1526434202694.jpg',
      downurl;
  bool flag = true;
  List selectedCoursesReferences =
      List(); // for sending student course_entry array
  List<StudentCourseEntry> selectedCourses = List();
  List<String> courseListForDropDown = List();

  TextStyle colorMode =
      TextStyle(color: Constants.mode ? Colors.white60 : Colors.grey);

  String getCourseNamebyId(String id) {
    Firestore.instance
        .collection('student_course')
        .document(id)
        .get()
        .then((DocumentSnapshot ds) {
      String course_name = ds['course_name'];
      return course_name;
    });
  }

  Future<Null> _pickImageFromGallery() async {
    print("___________________________________________");
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    imageFile = await compressFile(imageFile, imageFile.path);
    setState(() {
      this._imageFile = imageFile;
      flag = false;
    });
    _uploadFile();
  }

  Future<Null> _pickImageFromCamera() async {
    print("___________________________________________");
    File imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    imageFile = await compressFile(imageFile, imageFile.path);
    setState(() {
      this._imageFile = imageFile;
      flag = false;
    });
    _uploadFile();
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

  updateCourseList(StudentCourseEntry studentCourseEntry) {
    //selectedCoursesReferences.add(studentCourseEntry.reference.documentID);

    selectedCourses.add(studentCourseEntry);

    print("selectedCoursesReferences Courses    :   " +
        selectedCoursesReferences.toString());
    print("selectedCourses     :   " + selectedCourses.toString());

    updateOutStandingAmount();
  }

  updateOutStandingAmount() {
    setState(() {
      outStandingAmount = 0;
    });

    for (var course in selectedCourses) {
      outStandingAmount =
          outStandingAmount + int.parse(course.course_total_fees);
    }
  }

  Future<void> _fillInfoDialogue() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Fill All information First'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('You have to fill all information before upload an image'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('ok i will'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
    int __rand = Math.Random().nextInt(10000);

    final Directory systemTempDir = Directory.systemTemp;
    String __tempName = namefieldController.text,
        __date = DateTime.now().toString();

    final StorageReference ref = FirebaseStorage.instance
        .ref()
        .child("$__tempName _ $addDate _ $__rand.jpg");
    final StorageUploadTask uploadTask = ref.put(_imageFile);

    downurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    setState(() {
      thumbnail = downurl.toString();
      photourl = downurl.toString();
    });
    setState(() {
      processing = false;
    });
    print(photourl);
  }

  void insert() async {
    setState(() {
      processing = true;
    });
    await Firestore.instance.collection('admission').document().setData({
      'name': namefieldController.text,
      'address': addressfieldController.text,
      'mobileNo': mobileController.text,
      'optNumber': optionalNoController.text,
      'aadharNo': aadharfieldController.text,
      'batchTime': batchController.text,
      'imageUrl': photourl,
      'dateOfBirth': dob,
      'addDate': addDate,
      'status': status,
      'courses': selectedCoursesReferences,
      'outStandingAmount': outStandingAmount,
    });

    setState(() {
      processing = false;
    });

    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      outStandingAmount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Constants.mode ? Colors.transparent : Colors.grey.shade300,
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewImage(photourl)));
              },
              child: SizedBox(
                height: 280,
                width: double.infinity,
                child: PNetworkImage(photourl, fit: BoxFit.cover),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(16.0, 250.0, 16.0, 16.0),
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(16.0),
                        margin: EdgeInsets.only(top: 16.0),
                        decoration: BoxDecoration(
                            color:
                                Constants.mode ? Colors.black87 : Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                            border:
                                Border.all(color: Colors.white, width: 0.1)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left: 96.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: TextField(
                                      controller: namefieldController,
                                      textCapitalization:
                                          TextCapitalization.words,
                                      style: new TextStyle(
                                          color: Constants.mode
                                              ? Colors.white
                                              : Colors.black),
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white70,
                                              width: 1.0),
                                        ),
                                        labelText: 'Name',
                                        filled: true,
                                        labelStyle: TextStyle(
                                          color: Constants.mode
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    contentPadding: EdgeInsets.all(0),
                                    subtitle: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                      child: selectedCourses != null
                                          ? ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: selectedCourses.length,
                                              itemBuilder: (context, index) {
                                                return Container(
                                                    margin: EdgeInsets.all(2),
                                                    child: Chip(
                                                      deleteIconColor:
                                                          Colors.white,
                                                      backgroundColor:
                                                          Colors.redAccent,
                                                      label: Text(
                                                          selectedCourses[index]
                                                              .course_name
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16.0)),
                                                      onDeleted: () {
                                                        setState(() {
                                                          print(selectedCourses[
                                                                      index]
                                                                  .course_name +
                                                              " removed !!");
                                                          Firestore.instance
                                                              .collection(
                                                                  'student_course')
                                                              .document(
                                                                  selectedCourses[
                                                                          index]
                                                                      .reference
                                                                      .documentID)
                                                              .delete()
                                                              .catchError(
                                                                  (onError) {
                                                            print(onError);
                                                          }); //delete from firestore
                                                          selectedCourses
                                                              .removeAt(index);
                                                          selectedCoursesReferences
                                                              .removeAt(index);
                                                        });
                                                        updateOutStandingAmount();
                                                      },
                                                    ));
                                              })
                                          : Container(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        DatePicker.showDatePicker(context,
                                            showTitleActions: true,
                                            minTime: DateTime(1960, 1, 1),
                                            maxTime: DateTime.now(),
                                            onChanged: (date) {
                                          print('change $date');
                                        }, onConfirm: (date) {
                                          print('confirm $date');
                                          setState(() {
                                            dob = date;
                                          });
                                        },
                                            currentTime: DateTime.now(),
                                            locale: LocaleType.en);
                                      },
                                      child: Container(
                                        child: Column(
                                          children: <Widget>[
                                            dob != null
                                                ? Container(
                                                    child: Text(
                                                      dob.day.toString() +
                                                          ' / ' +
                                                          dob.month.toString() +
                                                          ' / ' +
                                                          dob.year.toString(),
                                                      style: colorMode,
                                                    ),
                                                  )
                                                : Text(
                                                    "DOB",
                                                    style: colorMode,
                                                  )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () {
                                            print('hello');
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddCourseEntry(
                                                            updateCourseList,
                                                            DateTime.now())));
                                          },
                                          child: Chip(
                                            label: Text(
                                              '+ Course',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            backgroundColor: Colors.green,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        DatePicker.showDatePicker(context,
                                            showTitleActions: true,
                                            minTime: DateTime(1960, 1, 1),
                                            maxTime: DateTime.now(),
                                            onChanged: (date) {
                                          print('change $date');
                                        }, onConfirm: (date) {
                                          print('confirm $date');
                                          setState(() {
                                            addDate = date;
                                          });
                                        },
                                            currentTime: DateTime.now(),
                                            locale: LocaleType.en);
                                      },
                                      child: Container(
                                        child: Column(
                                          children: <Widget>[
                                            addDate != null
                                                ? Text(
                                                    addDate.day.toString() +
                                                        ' / ' +
                                                        addDate.month
                                                            .toString() +
                                                        ' / ' +
                                                        addDate.year.toString(),
                                                    style: colorMode,
                                                  )
                                                : Text(
                                                    "Joined",
                                                    style: colorMode,
                                                  )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (validate()) {
                              _showDialog(context);
                            } else {
                              _fillInfoDialogue();
                              print("fill info first");
                            }
                          });
                        },
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              image: DecorationImage(
                                  image: CachedNetworkImageProvider(photourl),
                                  fit: BoxFit.cover)),
                          margin: EdgeInsets.only(left: 16.0),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    decoration: BoxDecoration(
                        color: Constants.mode ? Colors.black87 : Colors.white,
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: Colors.white, width: 0.1)),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            "Student Information",
                            style: colorMode,
                          ),
                        ),
                        Divider(),
                        ListTile(
                          subtitle: TextField(
                            keyboardType: TextInputType.number,
                            controller: mobileController,
                            style: new TextStyle(
                                color: Constants.mode
                                    ? Colors.white
                                    : Colors.black),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white70, width: 1.0),
                              ),
                              labelText: 'Mobile Number',
                              filled: true,
                              labelStyle: TextStyle(
                                color: Constants.mode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          leading: Icon(
                            Icons.phone,
                            color:
                                Constants.mode ? Colors.white : Colors.black54,
                          ),
                        ),
                        Divider(),
                        ListTile(
                          subtitle: TextField(
                            keyboardType: TextInputType.number,
                            controller: optionalNoController,
                            style: new TextStyle(
                                color: Constants.mode
                                    ? Colors.white
                                    : Colors.black),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white70, width: 1.0),
                              ),
                              labelText: 'Optional Mobile Number',
                              filled: true,
                              labelStyle: TextStyle(
                                color: Constants.mode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          leading: Icon(
                            Icons.phone,
                            color:
                                Constants.mode ? Colors.white : Colors.black54,
                          ),
                        ),
                        Divider(),
                        ListTile(
                          subtitle: TextField(
                            controller: addressfieldController,
                            textCapitalization: TextCapitalization.words,
                            style: new TextStyle(
                                color: Constants.mode
                                    ? Colors.white
                                    : Colors.black),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white70, width: 1.0),
                              ),
                              labelText: 'Address',
                              filled: true,
                              labelStyle: TextStyle(
                                color: Constants.mode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          leading: Icon(
                            Icons.confirmation_number,
                            color:
                                Constants.mode ? Colors.white : Colors.black54,
                          ),
                        ),
                        Divider(),
                        ListTile(
                          subtitle: TextField(
                            keyboardType: TextInputType.number,
                            controller: aadharfieldController,
                            style: new TextStyle(
                                color: Constants.mode
                                    ? Colors.white
                                    : Colors.black),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white70, width: 1.0),
                              ),
                              labelText: 'Aadhar Number',
                              filled: true,
                              labelStyle: TextStyle(
                                color: Constants.mode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          leading: Icon(
                            Icons.confirmation_number,
                            color:
                                Constants.mode ? Colors.white : Colors.black54,
                          ),
                        ),
                        Divider(),
                        ListTile(
                          subtitle: TextField(
                            controller: batchController,
                            textCapitalization: TextCapitalization.words,
                            style: new TextStyle(
                                color: Constants.mode
                                    ? Colors.white
                                    : Colors.black),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white70, width: 1.0),
                              ),
                              labelText: 'Batch Time',
                              filled: true,
                              labelStyle: TextStyle(
                                color: Constants.mode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          leading: Icon(
                            Icons.person,
                            color:
                                Constants.mode ? Colors.white : Colors.black54,
                          ),
                        ),
                        Divider(),
                        ListTile(
                          subtitle: TextField(
                            enabled: false,
                            controller: outStandingAmountController,
                            style: new TextStyle(
                                color: Constants.mode
                                    ? Colors.white
                                    : Colors.black),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white70, width: 1.0),
                              ),
                              labelText: outStandingAmount.toString(),
                              filled: true,
                              labelStyle: TextStyle(
                                color: Constants.mode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          leading: Icon(
                            Icons.monetization_on,
                            color:
                                Constants.mode ? Colors.white : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Constants.mode ? Colors.white : Colors.blue,
        child: processing
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            : Icon(
                Icons.done,
                color: Constants.mode ? Colors.black : Colors.white,
              ),
        onPressed: () {
          setState(() {
            print("name : " + namefieldController.text);
            print("mob1 : " + mobileController.text);
            print("mob2 : " + optionalNoController.text);
            print("addr : " + addressfieldController.text);
            print("aadhar : " + aadharfieldController.text);
            print("batch: " + batchController.text);
            if (validate()) {
              insert();
            } else {
              print(
                  '____________________Insert Valid Data !! _________________________________');
            }
          });
        },
      ),
    );
  }

  bool validate() {
    if (namefieldController.text.length > 6 &&
        mobileController.text.length == 10 &&
        optionalNoController.text.length == 10 &&
        addressfieldController.text.length > 5 &&
        aadharfieldController.text.length == 12 &&
        batchController.text.length > 6) {
      return true;
    } else {
      return false;
    }
  }

// String getCourseNamebyDocumentID(String id) {
//   Firestore.instance
//       .collection('student_course')
//       .document(id)
//       .get()
//       .then((DocumentSnapshot document) {
//     return document['course_name'];
//   });
// }
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

class PNetworkImage extends StatelessWidget {
  final String image;
  final BoxFit fit;
  final double width, height;

  const PNetworkImage(this.image, {Key key, this.fit, this.height, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: image,
      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
      fit: fit,
      width: width,
      height: height,
    );
  }
}

// Firestore.instance
//         .collection('student_course')
//         .document(courses[index])
//         .get()
//         .then((DocumentSnapshot ds) {
//       // use ds as a snapshot
//     });

// import 'dart:io';
// import 'dart:math' as Math;
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:ims/constants/constants.dart';
// import 'package:ims/data/course_record.dart';
// import 'package:intl/intl.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class AddStudInfo extends StatefulWidget {
//   @override
//   _AddStudInfo createState() => _AddStudInfo();
// }

// class _AddStudInfo extends State<AddStudInfo> {
//   TextEditingController namefieldController = TextEditingController();
//   TextEditingController addressfieldController = TextEditingController();
//   TextEditingController mobileController = TextEditingController();
//   TextEditingController optionalNoController = TextEditingController();
//   TextEditingController aadharfieldController = TextEditingController();
//   TextEditingController batchController = TextEditingController();

//   bool validator1 = true,
//       validator2 = true,
//       validator3 = true,
//       validator4 = true,
//       validator5 = true,
//       validator6 = true,
//       validator7 = true,
//       togg = false;
//   FirebaseUser user;
//   List<String> courseList = List();
//   bool processing = false, status = true;
//   DateTime dob, today = DateTime.now();
//   DateTime _fromDay = new DateTime(
//       DateTime.now().year - 18, DateTime.now().month, DateTime.now().day);
//   String thumbnail, course;
//   File _imageFile;
//   String photourl =
//       'http://www.stleos.uq.edu.au/wp-content/uploads/2016/08/image-placeholder.png';

//   Future<Null> _pickImageFromGallery() async {
//     File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
//     print("________________FILE______________");
//     imageFile = await compressFile(imageFile, imageFile.path);
//     print("________________FILE______________");
//     imageFile.rename('');
//     setState(() => this._imageFile = imageFile);
//   }

//   Future<Null> _pickImageFromCamera() async {
//     File imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
//     print("________________FILE______________");
//     imageFile = await compressFile(imageFile, imageFile.path);
//     setState(() => this._imageFile = imageFile);
//   }

//   Future<File> compressFile(File file, String targetPath) async {
//     print(file.lengthSync().toString() + "________________FILE______________");

//     var result = await FlutterImageCompress.compressAndGetFile(
//         file.absolute.path, targetPath,
//         quality: 40, minHeight: 400, minWidth: 400);

//     print(result.lengthSync().toString() +
//         "________________COMPRESS FILE______________");

//     return result;
//   }

//   _showDialog(BuildContext context) async {
//     await showDialog<String>(
//         context: context,
//         builder: (BuildContext context) {
//           return SimpleDialog(
//             children: <Widget>[
//               InkWell(
//                 onTap: () {
//                   Navigator.pop(context);
//                   setState(() {
//                     _pickImageFromCamera();
//                   });
//                 },
//                 child: ListTile(
//                   leading: Icon(Icons.camera_alt),
//                   title: Text(
//                     'Camera',
//                     style: TextStyle(fontSize: 20),
//                   ),
//                 ),
//               ),
//               InkWell(
//                 onTap: () {
//                   Navigator.pop(context);
//                   setState(() {
//                     _pickImageFromGallery();
//                   });
//                 },
//                 child: ListTile(
//                   leading: Icon(Icons.image),
//                   title: Text(
//                     'Gallery',
//                     style: TextStyle(fontSize: 20),
//                   ),
//                 ),
//               )
//             ],
//           );
//         });
//   }

//   Future<void> _uploadFile() async {
//     setState(() {
//       processing = true;
//     });
//     int __rand = new Math.Random().nextInt(10000);

//     final Directory systemTempDir = Directory.systemTemp;
//     String __tempName = namefieldController.text,
//         __date = DateTime.now().toString();

//     final StorageReference ref = FirebaseStorage.instance
//         .ref()
//         .child("$__tempName _ $__date _ $__rand.jpg");

//     final StorageUploadTask uploadTask = ref.put(_imageFile);

//     var downurl = await (await uploadTask.onComplete).ref.getDownloadURL();
//     thumbnail = downurl.toString();
//     print(thumbnail);
//     insert();
//     setState(() {
//       processing = false;
//     });
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     setState(() {
//       processing = false;
//     });

//     fetchCourseData();
//     cFirebaseAuth.currentUser().then(
//           (user) => setState(() {
//             this.user = user;
//           }),
//         );
//   }

//   fetchCourseData() async {
//     setState(() {
//       processing = true;
//       courseList.clear();
//     });
//     final QuerySnapshot result =
//         await Firestore.instance.collection('courses').getDocuments();

//     final List<DocumentSnapshot> documents = result.documents;
//     documents.forEach((data) {
//       final record = CourseRecord.fromSnapshot(data);
//       courseList.add(record.name);
//     });

//     setState(() {
//       processing = false;
//     });

//     courseList.sort((a, b) {
//       return a.toLowerCase().compareTo(b.toLowerCase());
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blueAccent.withOpacity(0.7),
//         title: Text(
//           "AddStudInfo",
//           style: TextStyle(fontSize: 25, color: Colors.white),
//         ),
//         actions: <Widget>[
//           Container(
//               margin: EdgeInsets.all(10),
//               child: processing
//                   ? CircularProgressIndicator(
//                       backgroundColor: Colors.white,
//                     )
//                   : FlatButton(
//                       color: Colors.white10,
//                       child: Text(
//                         'save',
//                         style: TextStyle(color: Colors.white, fontSize: 18),
//                       ),
//                       onPressed: () {
//                         if (course != null &&
//                             namefieldController.text.length != 0 &&
//                             addressfieldController.text.length != 0 &&
//                             mobileController.text.length != 0 &&
//                             aadharfieldController.text.length != 0 &&
//                             batchController.text.length != 0) {
//                           setState(() {
//                             processing = true;
//                           });
//                           _uploadFile();
//                         }
//                       },
//                     ))
//         ],
//         centerTitle: true,
//         iconTheme: IconThemeData(color: Colors.black),
//       ),
//       backgroundColor: Colors.grey[200],
//       body: Container(
//         margin: EdgeInsets.all(20),
//         child: Center(
//           child: ListView(
//             children: <Widget>[
//               Row(
//                 children: <Widget>[
//                   Expanded(
//                     child: Container(
//                       height: 120,
//                     ),
//                   ),
//                   Expanded(
//                     child: InkWell(
//                       onTap: () {
//                         setState(() {
//                           _showDialog(context);
//                         });
//                       },
//                       child: Container(
//                         height: MediaQuery.of(context).size.width / 4,
//                         margin: EdgeInsets.all(
//                             MediaQuery.of(context).size.width * 0.02),
//                         child: CircleAvatar(
//                           //radius: 20,
//                           backgroundImage: _imageFile != null
//                               ? FileImage(_imageFile)
//                               : AssetImage('assets/placeholder.png'),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Container(
//                       height: 120,
//                     ),
//                   )
//                 ],
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               TextField(
//                 controller: namefieldController,
//                 onChanged: (String str1) {
//                   if (str1.length < 3) {
//                     setState(() {
//                       validator1 = false;
//                     });
//                   } else {
//                     setState(() {
//                       validator1 = true;
//                     });
//                   }
//                 },
//                 decoration: InputDecoration(
//                   errorText: !validator1
//                       ? "Name Should be greater than 3 characters"
//                       : null,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(25),
//                   ),
//                   labelText: "Name",
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               TextField(
//                 controller: addressfieldController,
//                 onChanged: (String str2) {
//                   if (str2.length < 3) {
//                     setState(() {
//                       validator2 = false;
//                     });
//                   } else {
//                     setState(() {
//                       validator2 = true;
//                     });
//                   }
//                 },
//                 decoration: InputDecoration(
//                   errorText: !validator2
//                       ? "Address Should be greater than 3 characters"
//                       : null,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(25),
//                   ),
//                   labelText: "Address",
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               TextField(
//                 keyboardType: TextInputType.number,
//                 controller: mobileController,
//                 onChanged: (String str3) {
//                   if (str3.length != 10) {
//                     setState(() {
//                       validator3 = false;
//                     });
//                   } else {
//                     setState(() {
//                       validator3 = true;
//                     });
//                   }
//                 },
//                 decoration: InputDecoration(
//                   errorText: !validator3
//                       ? "Mobile Number should be of 10 digit"
//                       : null,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(25),
//                   ),
//                   labelText: "Mobile No",
//                 ),
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               TextField(
//                 keyboardType: TextInputType.number,
//                 controller: optionalNoController,
//                 onChanged: (String str4) {
//                   if (str4.length != 10) {
//                     setState(() {
//                       validator4 = false;
//                     });
//                   } else {
//                     setState(() {
//                       validator4 = true;
//                     });
//                   }
//                 },
//                 decoration: InputDecoration(
//                   errorText: !validator4
//                       ? "Mobile Number should be of 10 digit"
//                       : null,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(25),
//                   ),
//                   labelText: "Optional Number",
//                 ),
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               InkWell(
//                 onTap: () {
//                   DatePicker.showDatePicker(context,
//                       showTitleActions: true,
//                       minTime: DateTime(1960, 1, 1),
//                       maxTime: DateTime.now(), onChanged: (date) {
//                     print('change $date');
//                   }, onConfirm: (date) {
//                     print('confirm $date');
//                     setState(() {
//                       dob = date;
//                     });
//                   }, currentTime: DateTime.now(), locale: LocaleType.en);
//                 },
//                 child: Container(
//                   margin: EdgeInsets.only(top: 5, bottom: 5),
//                   padding: EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(25),
//                       border: Border.all(color: Colors.grey)),
//                   child: Text(
//                     dob == null
//                         ? "Set Date Of Birth"
//                         : dob.toString().substring(0, 10),
//                     style: TextStyle(fontSize: 16, color: Colors.black45),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               TextField(
//                 keyboardType: TextInputType.number,
//                 controller: aadharfieldController,
//                 onChanged: (String str5) {
//                   if (str5.length != 12) {
//                     setState(() {
//                       validator5 = false;
//                     });
//                   } else {
//                     setState(() {
//                       validator5 = true;
//                     });
//                   }
//                 },
//                 decoration: InputDecoration(
//                   errorText: !validator5
//                       ? "Aadhar Number should be of 12 digit"
//                       : null,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(25),
//                   ),
//                   labelText: "Aadhar Card No",
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               ListTile(
//                 title: Text('Choose Course'),
//                 trailing: DropdownButton<String>(
//                   hint: course == null ? Text('choose course') : null,
//                   value: course,
//                   icon: Icon(Icons.arrow_drop_down),
//                   iconSize: 24,
//                   elevation: 16,
//                   onChanged: (String str) {
//                     setState(() {
//                       course = str;
//                     });
//                   },
//                   items:
//                       courseList.map<DropdownMenuItem<String>>((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Text(value),
//                     );
//                   }).toList(),
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               TextField(
//                 maxLines: 5,
//                 controller: batchController,
//                 onChanged: (String str7) {
//                   if (str7.length < 3) {
//                     setState(() {
//                       validator7 = false;
//                     });
//                   } else {
//                     setState(() {
//                       validator7 = true;
//                     });
//                   }
//                 },
//                 decoration: InputDecoration(
//                   errorText: !validator7
//                       ? "Batch Time Should be greater than 3 characters"
//                       : null,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(25),
//                   ),
//                   labelText: "Batch Time",
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void insert() async {
//     Firestore.instance.collection('AddStudInfo').document().setData({
//       'name': namefieldController.text,
//       'address': addressfieldController.text,
//       'mobileNo': mobileController.text,
//       'optNumber': optionalNoController.text,
//       'dateOfBirth': _fromDay,
//       'aadharNo': aadharfieldController.text,
//       'courseName': course,
//       'batchTime': batchController.text,
//       'imageUrl': thumbnail,
//       'addedBy': user.email,
//       'addDate': today,
//       'status': status,
//     });
//     print(status);
//     Navigator.pop(context);
//   }
// }

// class DateTimePicker extends StatelessWidget {
//   const DateTimePicker({
//     Key key,
//     this.labelText,
//     this.selectedDate,
//     this.selectDate,
//   }) : super(key: key);
//   final String labelText;
//   final DateTime selectedDate;
//   final ValueChanged<DateTime> selectDate;
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       firstDate: DateTime(1960, 1),
//       lastDate: DateTime(2002),
//     );
//     if (picked != null && picked != selectedDate) selectDate(picked);
//   }

//   void addCourseDialogue(String mob, context) {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Column(
//               children: <Widget>[
//                 InkWell(
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   child: Container(
//                     margin: EdgeInsets.all(5),
//                     child: ListTile(
//                       title: Text(
//                         'Call',
//                         style: TextStyle(fontSize: 20),
//                       ),
//                       leading: Icon(Icons.call),
//                     ),
//                   ),
//                 ),
//                 InkWell(
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   child: Container(
//                     margin: EdgeInsets.all(5),
//                     child: ListTile(
//                       title: Text(
//                         'Call',
//                         style: TextStyle(fontSize: 20),
//                       ),
//                       leading: Icon(Icons.call),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             actions: <Widget>[
//               FlatButton.icon(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 label: Text('close'),
//                 icon: Icon(
//                   Icons.cancel,
//                 ),
//               )
//             ],
//           );
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final TextStyle valueStyle = Theme.of(context).textTheme.title;
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: <Widget>[
//         Expanded(
//           flex: 4,
//           child: InputDropdown(
//             labelText: labelText,
//             valueText: DateFormat.yMMMd().format(selectedDate),
//             valueStyle: valueStyle,
//             onPressed: () {
//               _selectDate(context);
//             },
//           ),
//         ),
//         //const SizedBox(width: 0.0),
//       ],
//     );
//   }
// }

// class InputDropdown extends StatelessWidget {
//   const InputDropdown({
//     Key key,
//     this.child,
//     this.labelText,
//     this.valueText,
//     this.valueStyle,
//     this.onPressed,
//   }) : super(key: key);
//   final String labelText;
//   final String valueText;

//   final TextStyle valueStyle;
//   final VoidCallback onPressed;
//   final Widget child;
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onPressed,
//       child: InputDecorator(
//         decoration: InputDecoration(
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(25),
//           ),
//           labelText: labelText,
//         ),
//         baseStyle: valueStyle,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             Text(valueText, style: valueStyle),
//             Icon(
//               Icons.arrow_drop_down,
//               color: Theme.of(context).brightness == Brightness.light
//                   ? Colors.grey.shade700
//                   : Colors.white70,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
