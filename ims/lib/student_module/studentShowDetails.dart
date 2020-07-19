import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:math' as Math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ims/courseModule/addCourseEntry.dart';
import 'package:ims/courseModule/editStudentCourseEntry.dart';
import 'package:ims/data/course_record.dart';
import 'package:ims/data/receiptEntry.dart';
import 'package:ims/data/record.dart';
import 'package:ims/data/studentCourseEntry.dart';
import 'package:ims/firebaseArrayCRUD/studentCourse.dart';
import 'package:ims/receiptModule/addReceipt.dart';
import 'package:ims/receiptModule/editReceipt.dart';
import 'package:ims/viewImage.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class StudentShowDetails extends StatefulWidget {
  final Record record;

  StudentShowDetails(this.record);

  @override
  _StudentShowDetails createState() => _StudentShowDetails(record);
}

class _StudentShowDetails extends State<StudentShowDetails> {
  final Record record;
  final List<int> numbers = [1, 2, 3, 5, 8, 13, 21, 34, 55];

  _StudentShowDetails(this.record);

  TextEditingController namefieldController = TextEditingController();
  TextEditingController addressfieldController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController optionalNoController = TextEditingController();
  TextEditingController aadharfieldController = TextEditingController();
  TextEditingController courseController = TextEditingController();
  TextEditingController batchController = TextEditingController();
  TextEditingController addCourseController = TextEditingController();
  TextEditingController outStandingAmountController = TextEditingController();

  bool validator1 = true,
      validator2 = true,
      validator3 = true,
      validator4 = true,
      validator5 = true,
      validator6 = true,
      validator7 = true,
      togg = false;
  bool processing = false, status, editing = false;
  DateTime dob, addDate;
  DateTime _fromDay = DateTime(
      DateTime.now().year - 18, DateTime.now().month, DateTime.now().day);
  String thumbnail;
  File _imageFile;
  String photourl, downurl;
  bool flag = true;
  int outStandingAmount;

  List selectedCoursesReferences = List();
  List<StudentCourseEntry> selectedCourses = List();

  List selectedStudentReceiptReferences = List();
  List<ReceiptEntry> studentReceiptList = List();

  @override
  void initState() {
    super.initState();
    setState(() {
      processing = true;
      namefieldController.text = record.name;
      addressfieldController.text = record.address;
      mobileController.text = record.mobileno;
      optionalNoController.text = record.optionalno;
      aadharfieldController.text = record.aadharno;
      courseController.text = record.pursuing_course;
      batchController.text = record.batchtime;
      photourl = record.imageurl;
      dob = record.dateofbirth.toDate();
      addDate = record.addDate.toDate();
      status = record.status;
      selectedCoursesReferences = []..addAll(record.courses);
      selectedStudentReceiptReferences = []..addAll(record.receipts);
      outStandingAmount = record.outStandingAmount;
    });

    print(selectedCoursesReferences);
    print(selectedStudentReceiptReferences);

    fetchLists();

    setState(() {
      processing = false;
    });
  }

  void fetchLists() async {
    //fetch receipts and courses list from array refrences
    for (var i = 0; i < selectedCoursesReferences.length; i++) {
      Firestore.instance
          .collection('student_course')
          .document(selectedCoursesReferences[i].toString())
          .get()
          .then((DocumentSnapshot ds) {
        setState(() {
          selectedCourses.add(StudentCourseEntry.fromSnapshot(ds));
        });
      });
    }

    for (var i = 0; i < selectedStudentReceiptReferences.length; i++) {
      Firestore.instance
          .collection('receipts')
          .document(selectedStudentReceiptReferences[i].toString())
          .get()
          .then((DocumentSnapshot ds) {
        setState(() {
          studentReceiptList.add(ReceiptEntry.fromSnapshot(ds));
        });
      });
    }
  }

  Future<Null> _pickImageFromGallery() async {
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    imageFile = await compressFile(imageFile, imageFile.path);
    setState(() {
      this._imageFile = imageFile;
      flag = false;
    });
    _uploadFile();
  }

  Future<Null> _pickImageFromCamera() async {
    File imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    imageFile = await compressFile(imageFile, imageFile.path);
    setState(() {
      this._imageFile = imageFile;
      flag = false;
    });
    _uploadFile();
  }

  Future<File> compressFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path, targetPath,
        quality: 60, minHeight: 400, minWidth: 400);

    print(result.lengthSync().toString() +
        "________________COMPRESS FILE______________");

    return result;
  }

  deleteCourseChip(int index) {
    setState(() {
      print(selectedCourses[index].course_name + " removed !!");
      Firestore.instance
          .collection('student_course')
          .document(selectedCourses[index].reference.documentID)
          .delete()
          .catchError((onError) {
        print(onError);
      });
      //delete from firestore

      delCourse(selectedCoursesReferences[index].toString());

      selectedCourses.removeAt(index);
      selectedCoursesReferences.removeAt(index);
    });
  }

  Future<void> chipOptions(int index) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditStudentCourseEntry(
                            selectedCoursesReferences[index].toString())));
              },
              child: ListTile(
                leading: Icon(
                  Icons.info,
                  color: Colors.green,
                ),
                title: Text(
                  'View Info',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                if (selectedCourses.length > 1 &&
                    selectedCoursesReferences.length > 1) {
                  deleteCourseChip(index);
                } else {
                  _showAlert(
                      "Student atleast have one course entry if you want to delete one then you should add anather entry first");
                }
              },
              child: ListTile(
                leading: Icon(
                  Icons.delete_forever,
                  color: Colors.red,
                ),
                title: Text(
                  'Delete Course',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  void _showAlert(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert !!'),
          content: Text(msg),
          actions: <Widget>[
            new FlatButton(
              child: new Text("ok"),
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
    thumbnail = downurl.toString();
    photourl = downurl.toString();
    update();
    print(photourl);
  }

  void update() async {
    await Firestore.instance
        .collection('admission')
        .document(record.reference.documentID)
        .updateData({
      'name': namefieldController.text,
      'address': addressfieldController.text,
      'mobileNo': mobileController.text,
      'optNumber': optionalNoController.text,
      'aadharNo': aadharfieldController.text,
      'courseName': courseController.text,
      'batchTime': batchController.text,
      'imageUrl': photourl,
      'dateOfBirth': dob,
      'addDate': addDate,
      'status': status,
      'outStandingAmountController': outStandingAmountController.text,
      'courses': selectedCoursesReferences,
    });
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text("Updated !!"),
              content: Text("Data Updated Successfully..."),
            ));
    print('Update Successfully !!');
  }

  updateReceiptList(ReceiptEntry receiptEntry) {
    setState(() {
      selectedStudentReceiptReferences.add(receiptEntry.reference.documentID);
      studentReceiptList.add(receiptEntry);

      outStandingAmount = outStandingAmount - receiptEntry.paying_amount;
    });

    print("studentReceiptList     :   " +
        selectedStudentReceiptReferences.toString());

    Firestore.instance
        .collection('admission')
        .document(record.reference.documentID)
        .updateData({'receipts': selectedStudentReceiptReferences});

    Firestore.instance
        .collection('admission')
        .document(record.reference.documentID)
        .updateData({'outStandingAmount': outStandingAmount});
  }

  updateCourseList(StudentCourseEntry studentCourseEntry) {
    setState(() {
      selectedCoursesReferences.add(studentCourseEntry.reference.documentID);
      selectedCourses.add(studentCourseEntry);

      outStandingAmount =
          outStandingAmount + int.parse(studentCourseEntry.course_fees);
    });

    print("selectedCourses     :   " + selectedCourses.toString());

    Firestore.instance
        .collection('admission')
        .document(record.reference.documentID)
        .updateData({'courses': selectedCoursesReferences});

    Firestore.instance
        .collection('admission')
        .document(record.reference.documentID)
        .updateData({'outStandingAmount': outStandingAmount});
  }

  updateOutStandingAmount(int amt) {
    setState(() {
      outStandingAmount = amt;
    });

    for (var course in selectedCourses) {
      setState(() {
        outStandingAmount =
            outStandingAmount + int.parse(course.course_total_fees);
      });
    }
    print(outStandingAmount);
    addCourseList();
  }

  void addCourseList() async {
    List clone;

    print('__________add course_________________');
    setState(() {
      if (selectedCoursesReferences != null) {
        clone = []..addAll(selectedCoursesReferences);
      } else {
        clone = List();
      }
      clone.add(addCourseController.text.toString());
    });

    setState(() {
      clone.remove('');
    });

    print('__________clone success_________________' + clone.toString());

    Firestore.instance
        .collection('admission')
        .document(record.reference.documentID)
        .updateData({
      'courses': FieldValue.arrayUnion(clone),
      'outStandingAmount': outStandingAmount,
    });
  }

  Future<void> _neverSatisfied() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Warning !!'),
          content: SingleChildScrollView(
            child: Text(
                'You should add atleast single course entry for student .'),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('ok'),
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
    return WillPopScope(
      onWillPop: () {
        if (selectedCoursesReferences.length > 0) {
          Navigator.pop(context);
        } else {
          _neverSatisfied();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
        body: processing == false
            ? SingleChildScrollView(
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
                        child:
                            PNetworkImage(record.imageurl, fit: BoxFit.cover),
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
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5.0)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(left: 96.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          editing
                                              ? Container(
                                                  child: TextField(
                                                    controller:
                                                        namefieldController,
                                                    decoration: InputDecoration(
                                                        hintText: record.name),
                                                  ),
                                                )
                                              : ListTile(
                                                  leading: Text(
                                                    record.name,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .title,
                                                  ),
                                                  trailing: Container(
                                                    width: 10,
                                                    color: record.status
                                                        ? Colors.green
                                                        : Colors.red,
                                                  ),
                                                ),
                                          ListTile(
                                            contentPadding: EdgeInsets.all(0),
                                            subtitle: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.07,
                                              child: selectedCourses != null
                                                  ? ListView.builder(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount: selectedCourses
                                                          .length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Container(
                                                            margin:
                                                                EdgeInsets.all(
                                                                    2),
                                                            child: ActionChip(
                                                                avatar:
                                                                    CircleAvatar(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                  child: Text(selectedCourses[
                                                                          index]
                                                                      .course_name
                                                                      .toString()[0]),
                                                                ),
                                                                label: Text(
                                                                    selectedCourses[
                                                                            index]
                                                                        .course_name
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16.0)),
                                                                onPressed: () {
                                                                  chipOptions(
                                                                      index);
                                                                }));
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
                                                if (editing) {
                                                  DatePicker.showDatePicker(
                                                      context,
                                                      showTitleActions: true,
                                                      minTime:
                                                          DateTime(1960, 1, 1),
                                                      maxTime: DateTime.now(),
                                                      onChanged: (date) {
                                                    print('change $date');
                                                  }, onConfirm: (date) {
                                                    print('confirm $date');
                                                    setState(() {
                                                      dob = date;
                                                    });
                                                  },
                                                      currentTime:
                                                          DateTime.now(),
                                                      locale: LocaleType.en);
                                                }
                                              },
                                              child: Container(
                                                child: Column(
                                                  children: <Widget>[
                                                    Container(
                                                      child: Text(dob.day
                                                              .toString() +
                                                          ' / ' +
                                                          dob.month.toString() +
                                                          ' / ' +
                                                          dob.year.toString()),
                                                    ),
                                                    Text("DOB")
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
                                                                  addDate,
                                                                )));
                                                  },
                                                  child: Chip(
                                                    label: Text(
                                                      '+ Course',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    backgroundColor:
                                                        Colors.green,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                if (editing) {
                                                  DatePicker.showDatePicker(
                                                      context,
                                                      showTitleActions: true,
                                                      minTime:
                                                          DateTime(1960, 1, 1),
                                                      maxTime: DateTime.now(),
                                                      onChanged: (date) {
                                                    print('change $date');
                                                  }, onConfirm: (date) {
                                                    print('confirm $date');
                                                    setState(() {
                                                      addDate = date;
                                                    });
                                                  },
                                                      currentTime:
                                                          DateTime.now(),
                                                      locale: LocaleType.en);
                                                }
                                              },
                                              child: Container(
                                                child: Column(
                                                  children: <Widget>[
                                                    Text(
                                                        addDate.day.toString() +
                                                            ' / ' +
                                                            addDate.month
                                                                .toString() +
                                                            ' / ' +
                                                            addDate.year
                                                                .toString()),
                                                    Text("Joined")
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
                                    _showDialog(context);
                                  });
                                },
                                child: Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                              record.imageurl),
                                          fit: BoxFit.cover)),
                                  margin: EdgeInsets.only(left: 16.0),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  title: Text("Student Information"),
                                ),
                                Divider(),
                                ListTile(
                                  title: Text("Phone"),
                                  subtitle: editing
                                      ? TextField(
                                          keyboardType: TextInputType.number,
                                          controller: mobileController,
                                          decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.all(10),
                                              hintText: record.mobileno),
                                        )
                                      : Text(record.mobileno),
                                  leading: Icon(Icons.phone),
                                ),
                                ListTile(
                                  title: Text("Optional Number"),
                                  subtitle: editing
                                      ? TextField(
                                          keyboardType: TextInputType.number,
                                          controller: optionalNoController,
                                          decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.all(10),
                                              hintText: record.optionalno),
                                        )
                                      : Text(record.optionalno),
                                  leading: Icon(Icons.call),
                                ),
                                ListTile(
                                  title: Text("Address"),
                                  subtitle: editing
                                      ? TextField(
                                          controller: addressfieldController,
                                          decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.all(10),
                                              hintText: record.address),
                                        )
                                      : Text(record.address),
                                  leading: Icon(Icons.confirmation_number),
                                ),
                                ListTile(
                                  title: Text("Aadhar Number"),
                                  subtitle: editing
                                      ? TextField(
                                          keyboardType: TextInputType.number,
                                          controller: aadharfieldController,
                                          decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.all(10),
                                              hintText: record.aadharno),
                                        )
                                      : Text(record.aadharno),
                                  leading: Icon(Icons.confirmation_number),
                                ),
                                ListTile(
                                  title: Text("Batch Time"),
                                  subtitle: editing
                                      ? TextField(
                                          controller: batchController,
                                          decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.all(10),
                                              hintText: record.batchtime),
                                        )
                                      : Text(record.batchtime),
                                  leading: Icon(Icons.person),
                                ),
                                Divider(),
                                ListTile(
                                  subtitle: TextField(
                                    enabled: false,
                                    controller: outStandingAmountController,
                                    decoration: InputDecoration(
                                        hintText: outStandingAmount.toString()),
                                  ),
                                  leading: Icon(Icons.monetization_on),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                    title: Text("Fees Receipts"),
                                    trailing: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddReceipt(
                                                          selectedCourses,
                                                          DateTime.now(),
                                                          record.reference,
                                                          outStandingAmount,
                                                          updateOutStandingAmount,
                                                          updateReceiptList)));
                                        },
                                        child: Chip(
                                            backgroundColor: Colors.green,
                                            label: Text(
                                              '+ add ',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )))),
                                Divider(),
                                studentReceiptList != null
                                    ? Container(
                                        height: studentReceiptList.length *
                                                60.toDouble() +
                                            40,
                                        child: receiptsListBuilder(),
                                      )
                                    : Container(),
                                SizedBox(
                                  height: 50,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
        floatingActionButton: FloatingActionButton(
          child: editing ? Icon(Icons.done) : Icon(Icons.edit),
          onPressed: () {
            setState(() {
              if (editing) {
                print("name : " + namefieldController.text);
                print("mob1 : " + mobileController.text);
                print("mob2 : " + optionalNoController.text);
                print("addr : " + addressfieldController.text);
                print("aadhar : " + aadharfieldController.text);
                print("batch: " + batchController.text);
                update();
              }
              editing = !editing;
            });
          },
        ),
      ),
    );
  }

  Widget receiptsListBuilder() {
    return ListView.builder(
      itemCount: studentReceiptList.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(.1))),
          margin: EdgeInsets.only(bottom: 5),
          child: ListTile(
            leading:
                studentReceiptList[index].payment_method.toString() == 'Cash'
                    ? Icon(Icons.monetization_on)
                    : Icon(Icons.wifi),
            title: Text(studentReceiptList[index].paying_amount.toString()),
            subtitle: studentReceiptList[index].receipt_date != null
                ? Text(
                    studentReceiptList[index].receipt_date.toDate().toString())
                : Text('today'),
            trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            EditReceipt(studentReceiptList[index])))),
          ),
        );
      },
    );
  }

  // course ====================================================================

  void delCourse(String course) async {
    List clone = List();

    setState(() {
      clone.add(course);
    });

    Firestore.instance
        .collection('admission')
        .document(record.reference.documentID)
        .updateData({
      'courses': FieldValue.arrayRemove(clone),
    });
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
