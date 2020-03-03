import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:math' as Math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ims/data/course_record.dart';
import 'package:ims/data/record.dart';
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
  List courses = List();
  List<String> courseList = List();

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

  loadCourses() async {
    DocumentReference docRef = Firestore.instance
        .collection('admission')
        .document(record.reference.toString());
    DocumentSnapshot doc = await docRef.get();

    setState(() {
      courses = doc.data['courses'];
    });
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
    });
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text("Updated !!"),
              content: Text("Data Updated Successfully..."),
            ));
    print('Update Successfully !!');
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

    print(courseList);
  }

  @override
  void initState() {
    super.initState();
    fetchCourseData();
    setState(() {
      namefieldController.text = record.name;
      addressfieldController.text = record.address;
      mobileController.text = record.mobileno;
      optionalNoController.text = record.optionalno;
      aadharfieldController.text = record.aadharno;
      courseController.text = record.coursename;
      batchController.text = record.batchtime;
      photourl = record.imageurl;
      dob = record.dateofbirth.toDate();
      addDate = record.addDate.toDate();
      status = record.status;
      courses = record.courses;
    });

    print(courses);
  }

  _addCourseDialogue() async {
    String scourse = null;
    await showDialog<String>(
      context: context,
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: DropdownButton<String>(
          hint: scourse == null ? Text('choose course') : Text(scourse),
          value: scourse,
          icon: Icon(Icons.arrow_drop_down),
          iconSize: 24,
          elevation: 16,
          onChanged: (String str) {
            setState(() {
              scourse = str;
              addCourseController.text = str;
            });
          },
          items: courseList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        actions: <Widget>[
          FlatButton(
              child: const Text('cancle'),
              onPressed: () {
                Navigator.pop(context);
              }),
          FlatButton(
              child: const Text('save'),
              onPressed: () {
                print('________You Entered___________' + courseController.text);
                if (addCourseController.text.length > 0) {
                  addCourse();
                  Navigator.pop(context);
                }
              })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
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
                child: PNetworkImage(record.imageurl, fit: BoxFit.cover),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  editing
                                      ? Container(
                                          child: TextField(
                                            controller: namefieldController,
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
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                      child: courses != null
                                          ? ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: courses.length,
                                              itemBuilder: (context, index) {
                                                return Container(
                                                    margin: EdgeInsets.all(2),
                                                    child: Chip(
                                                      deleteIconColor:
                                                          Colors.white,
                                                      backgroundColor:
                                                          Colors.redAccent,
                                                      label: Text(
                                                          courses[index]
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16.0)),
                                                      onDeleted: () {
                                                        setState(() {
                                                          print(courses[index] +
                                                              " removed !!");

                                                          delCourse(
                                                              courses[index]);
                                                        });
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
                                        if (editing) {
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
                                        }
                                      },
                                      child: Container(
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              child: Text(dob.day.toString() +
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
                                            _addCourseDialogue();
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
                                        if (editing) {
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
                                        }
                                      },
                                      child: Container(
                                        child: Column(
                                          children: <Widget>[
                                            Text(addDate.day.toString() +
                                                ' / ' +
                                                addDate.month.toString() +
                                                ' / ' +
                                                addDate.year.toString()),
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
                                      contentPadding: EdgeInsets.all(10),
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
                                      contentPadding: EdgeInsets.all(10),
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
                                      contentPadding: EdgeInsets.all(10),
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
                                      contentPadding: EdgeInsets.all(10),
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
                                      contentPadding: EdgeInsets.all(10),
                                      hintText: record.batchtime),
                                )
                              : Text(record.batchtime),
                          leading: Icon(Icons.person),
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

  void addCourse() async {
    List clone;

    print('__________add course_________________');
    setState(() {
      if (courses != null) {
        clone = []..addAll(courses);
      } else {
        clone = List();
      }
      clone.add(addCourseController.text.toString());
    });
    print('__________clone success_________________');

    //if already array present in document_______________________

    Firestore.instance
        .collection('admission')
        .document(record.reference.documentID)
        .updateData({
      'courses': FieldValue.arrayUnion(clone),
    });

    // Firestore.instance
    //     .collection('admission')
    //     .document(record.reference.documentID)
    //     .setData({
    //   'courses': clone,
    // });
    //  Navigator.pop(context);
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
