import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:ims/data/course_record.dart';
import 'package:ims/data/studentCourseEntry.dart';

class EditStudentCourseEntry extends StatefulWidget {
  final String docId;

  EditStudentCourseEntry(this.docId);

  @override
  _EditStudentCourseEntryState createState() => _EditStudentCourseEntryState();
}

class _EditStudentCourseEntryState extends State<EditStudentCourseEntry> {
  bool processing = false, status = true, editing = false;

  DateTime course_start_date, course_validity_date;
  List courses = List();
  List<CourseRecord> courseList = List();
  CourseRecord selectedCourse = null;
  StudentCourseEntry courseEntry = new StudentCourseEntry();
  String courseFees, totalFees, courseName;
  TextEditingController totalCourseFeesController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCourseEntryData();
    fetchCourseData();
  }

  fetchCourseEntryData() async {
    await Firestore.instance
        .collection('student_course')
        .document(widget.docId)
        .get()
        .then((DocumentSnapshot ds) {
      setState(() {
        courseEntry = StudentCourseEntry.fromSnapshot(ds);
      });
    });

    setState(() {
      courseName = courseEntry.course_name;
      courseFees = courseEntry.course_fees;
      totalFees = courseEntry.course_total_fees;
      course_start_date = courseEntry.course_start_date.toDate();
      course_validity_date = courseEntry.course_validity_date.toDate();
    });
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
      courseList.add(record);
      if (record.name == courseName) {
        setState(() {
          selectedCourse = record;
        });
        print('object');
      }
    });

    setState(() {
      processing = false;
    });
  }

  void update() async {
    setState(() {
      processing = true;
    });
    DocumentReference referenceId =
        Firestore.instance.collection('student_course').document(widget.docId);
    await referenceId.updateData({
      'course_name': selectedCourse.name,
      'course_fees': selectedCourse.fees,
      'course_total_fees': totalCourseFeesController.text,
      'course_start_date': course_start_date,
      'course_validity_date': course_validity_date,
    });

    setState(() {
      processing = false;
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Add Course"),
        actions: <Widget>[
          InkWell(
            onTap: () {
              if (selectedCourse != null && course_start_date != null) {
                update();
              }
            },
            child: Container(
              margin: EdgeInsets.all(10),
              child: Icon(Icons.save),
            ),
          )
        ],
      ),
      body: Center(
        child: processing
            ? CircularProgressIndicator()
            : ListView(
                children: <Widget>[
                  selectedCourse == null
                      ? SizedBox(
                          height: 200,
                        )
                      : Container(
                          margin: EdgeInsets.all(20),
                          height: 200,
                          child: Image.network(selectedCourse.imageUrl),
                        ),
                  ListTile(
                    leading: Container(
                        margin: EdgeInsets.all(20),
                        child: Text("Choose Course ")),
                    title: Container(
                      child: DropdownButton<CourseRecord>(
                        hint: Text("Select item"),
                        value: selectedCourse,
                        onChanged: (CourseRecord Value) {
                          setState(() {
                            selectedCourse = Value;
                            print(selectedCourse.name);
                            print(selectedCourse.fees);
                            totalCourseFeesController.text =
                                selectedCourse.fees.toString();
                            if (course_start_date != null) {
                              course_validity_date = course_start_date.add(
                                  Duration(
                                      days: int.parse(selectedCourse.duration) *
                                          2));
                            }
                          });
                        },
                        items: courseList.map((CourseRecord user) {
                          return DropdownMenuItem<CourseRecord>(
                            value: user,
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.book),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  user.name,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  selectedCourse != null
                      ? ListTile(
                          leading: Container(
                              margin: EdgeInsets.all(20),
                              child: Text('Course Fees')),
                          title: Container(
                            margin: EdgeInsets.all(20),
                            child: TextField(
                              enabled: false,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: selectedCourse == null
                                      ? 'Course Fees'
                                      : selectedCourse.fees.toString()),
                            ),
                          ),
                        )
                      : SizedBox(),
                  selectedCourse != null
                      ? ListTile(
                          leading: Container(
                            margin: EdgeInsets.all(20),
                            child: Text("Total Fees   "),
                          ),
                          title: Container(
                            margin: EdgeInsets.all(20),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: totalCourseFeesController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: selectedCourse == null
                                      ? 'Total Course Fees'
                                      : selectedCourse.fees.toString()),
                            ),
                          ),
                        )
                      : SizedBox(),
                  selectedCourse != null
                      ? Container(
                          margin: EdgeInsets.all(20),
                          child: InkWell(
                            onTap: () {
                              DatePicker.showDatePicker(context,
                                  showTitleActions: true,
                                  minTime: DateTime(1960, 1, 1),
                                  maxTime:
                                      DateTime.now().add(Duration(days: 365)),
                                  onChanged: (date) {
                                print('change $date');
                              }, onConfirm: (date) {
                                print('confirm $date');
                                setState(() {
                                  course_start_date = date;
                                  course_validity_date = course_start_date.add(
                                      Duration(
                                          days: int.parse(
                                                  selectedCourse.duration) *
                                              2));
                                });
                              },
                                  currentTime: DateTime.now(),
                                  locale: LocaleType.en);
                            },
                            child: Container(
                              child: ListTile(
                                leading: Text("Course Start Date    "),
                                trailing: Icon(Icons.calendar_today),
                                title: course_start_date != null
                                    ? Container(
                                        color: Colors.redAccent,
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                            course_start_date.day.toString() +
                                                ' / ' +
                                                course_start_date.month
                                                    .toString() +
                                                ' / ' +
                                                course_start_date.year
                                                    .toString(),
                                            style:
                                                TextStyle(color: Colors.white)),
                                      )
                                    : Container(
                                        color: Colors.redAccent,
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          "Select Date",
                                          style: TextStyle(color: Colors.white),
                                        )),
                              ),
                            ),
                          ),
                        )
                      : SizedBox(),
                  selectedCourse != null
                      ? Container(
                          margin: EdgeInsets.all(20),
                          child: InkWell(
                            onTap: () {
                              DatePicker.showDatePicker(context,
                                  showTitleActions: true,
                                  minTime: DateTime(1960, 1, 1),
                                  maxTime:
                                      DateTime.now().add(Duration(days: 730)),
                                  onChanged: (date) {
                                print('change $date');
                              }, onConfirm: (date) {
                                print('confirm $date');
                                setState(() {
                                  course_validity_date = date;
                                });
                              },
                                  currentTime: DateTime.now(),
                                  locale: LocaleType.en);
                            },
                            child: Container(
                              child: ListTile(
                                leading: Text(' Course Validity Date'),
                                trailing: Icon(Icons.calendar_today),
                                title: course_validity_date != null
                                    ? Container(
                                        color: Colors.redAccent,
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                            course_validity_date.day
                                                    .toString() +
                                                ' / ' +
                                                course_validity_date.month
                                                    .toString() +
                                                ' / ' +
                                                course_validity_date.year
                                                    .toString(),
                                            style:
                                                TextStyle(color: Colors.white)),
                                      )
                                    : Container(
                                        color: Colors.redAccent,
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          "Select Date",
                                          style: TextStyle(color: Colors.white),
                                        )),
                              ),
                            ),
                          ),
                        )
                      : SizedBox(),
                ],
              ),
      ),
    );
  }
}
