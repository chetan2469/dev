import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:ims/constants/constants.dart';
import 'package:ims/data/course_record.dart';
import 'package:ims/data/studentCourseEntry.dart';

class AddCourseEntry extends StatefulWidget {
  final DateTime date;
  final Function updateCourseList;

  const AddCourseEntry(this.updateCourseList, this.date);

  @override
  _AddCourseEntryState createState() => _AddCourseEntryState();
}

class _AddCourseEntryState extends State<AddCourseEntry> {
  bool processing = false, status = true, editing = false;
  DateTime course_start_date, course_validity_date;
  List courses = List();
  List<CourseRecord> courseList = List();
  CourseRecord selectedCourse = null;

  TextEditingController totalCourseFeesController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCourseData();

    setState(() {
      course_start_date = widget.date;
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
    });

    setState(() {
      processing = false;
    });

    print(courseList);
  }

  void insert() async {
    setState(() {
      processing = true;
    });
    DocumentReference referenceId =
        Firestore.instance.collection('student_course').document();
    await referenceId.setData({
      'course_name': selectedCourse.name,
      'course_fees': selectedCourse.fees,
      'course_total_fees': totalCourseFeesController.text,
      'course_start_date': course_start_date,
      'course_validity_date': course_validity_date,
    });

    StudentCourseEntry studentCourseEntry = StudentCourseEntry(
        course_name: selectedCourse.name,
        course_fees: selectedCourse.fees,
        course_total_fees: totalCourseFeesController.text,
        reference: referenceId);

    setState(() {
      processing = false;
    });
    widget.updateCourseList(studentCourseEntry);
    print(" Add Entry Page course doc  " + referenceId.documentID);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.mode ? Colors.black87 : Colors.white,
      appBar: AppBar(
        title: Text("Add Course"),
        actions: <Widget>[
          InkWell(
            onTap: () {
              if (selectedCourse != null && course_start_date != null) {
                insert();
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
