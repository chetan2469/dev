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
  bool processing = false, status;
  DateTime dob, addDate;
  DateTime _fromDay = new DateTime(
      DateTime.now().year - 18, DateTime.now().month, DateTime.now().day);
  String thumbnail;
  File _imageFile;
  String photourl,course;
  bool flag = true;
  List<String> temp = List();

  List courses = List();

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
  }

  loadCourses() async {
    DocumentReference docRef = Firestore.instance
        .collection('admission')
        .document(record.reference.toString());
    DocumentSnapshot doc = await docRef.get();

    courses = doc.data['courses'];
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      temp.clear();

      if (record.courses != null) {
        for (var item in record.courses) {
          temp.add(item);
        }
      }
    });

    loadCourses();
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
    temp = record.courses;
  }

  _addCourse() async {
    await showDialog<String>(
      context: context,
      child: new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextField(
                onChanged: (String str)
                {
                  setState(() {
                    course = str;
                  });
                },
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Course Name', hintText: 'eg. Java, C++'),
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('cancle'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('save'),
              onPressed: () {
                if (course.length > 0) {
                  addCourse();
                  Navigator.pop(context);
                  print(course);
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
                                  ListTile(
                                    leading: Text(
                                      record.name,
                                      style: Theme.of(context).textTheme.title,
                                    ),
                                    trailing: Chip(
                                      label: Text(
                                        record.status ? 'Active' : 'Inactive',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  ),
                                  ListTile(
                                    contentPadding: EdgeInsets.all(0),
                                    subtitle: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                      child: temp != null
                                          ? ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: temp.length,
                                              itemBuilder: (context, index) {
                                                return Container(
                                                    margin: EdgeInsets.all(2),
                                                    child: Chip(
                                                      backgroundColor:
                                                          Colors.redAccent,
                                                      label: Text(
                                                          temp[index]
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16.0)),
                                                    ));
                                              })
                                          : Container(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Text(record.dateofbirth
                                              .toDate()
                                              .day
                                              .toString() +
                                          ' / ' +
                                          record.dateofbirth
                                              .toDate()
                                              .month
                                              .toString() +
                                          ' / ' +
                                          record.dateofbirth
                                              .toDate()
                                              .year
                                              .toString()),
                                      Text("DOB")
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () {
                                          print('hello');
                                          _addCourse();
                                        },
                                        child: Chip(
                                          label: Text(
                                            '+ Course',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          backgroundColor: Colors.green,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Text(record.addDate
                                              .toDate()
                                              .day
                                              .toString() +
                                          ' / ' +
                                          record.addDate
                                              .toDate()
                                              .month
                                              .toString() +
                                          ' / ' +
                                          record.addDate
                                              .toDate()
                                              .year
                                              .toString()),
                                      Text("Joined")
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                                image:
                                    CachedNetworkImageProvider(record.imageurl),
                                fit: BoxFit.cover)),
                        margin: EdgeInsets.only(left: 16.0),
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
                          title: Text("Email"),
                          subtitle: Text("student@gmail.com"),
                          leading: Icon(Icons.email),
                        ),
                        ListTile(
                          title: Text("Phone"),
                          subtitle: Text(record.mobileno),
                          leading: Icon(Icons.phone),
                        ),
                        ListTile(
                          title: Text("Optional Number"),
                          subtitle: Text(record.optionalno),
                          leading: Icon(Icons.call),
                        ),
                        ListTile(
                          title: Text("Address"),
                          subtitle: Text(record.address),
                          leading: Icon(Icons.confirmation_number),
                        ),
                        ListTile(
                          title: Text("Aadhar Number"),
                          subtitle: Text("15 February 2019"),
                          leading: Icon(Icons.confirmation_number),
                        ),
                        ListTile(
                          title: Text("Batch Time"),
                          subtitle: Text(record.batchtime),
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
    );
  }

  void addCourse() async {
    setState(() {
      temp.add(course);
    });
    print(temp.length);

    Firestore.instance
        .collection('admission')
        .document(record.reference.documentID)
        .updateData({
      'courses': temp,
    });

    setState(() {
      course = '';
    });
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
