import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ims/firebaseArrayCRUD/studentCourse.dart';
import 'package:ims/student_module/addmission.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_sms/flutter_sms.dart';

class ListArrayItems extends StatefulWidget {
  @override
  _ListArrayItemsState createState() => _ListArrayItemsState();
}

class _ListArrayItemsState extends State<ListArrayItems> {
  List<StudentCourse> courseList = new List();
  bool processing = true;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String searchStr = "";
  String searchBy = 'Name';
  Icon actionIcon = new Icon(Icons.search);
  Widget appBarTitle = new Text("");

  static const searchByItems = <String>[
    'Name',
    'Course',
    'Status',
    'Batch Time',
    'Admission',
  ];

  final List<DropdownMenuItem<String>> _dropDownMenuItems = searchByItems
      .map(
        (String value) => DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      )
      .toList();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchStudentData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(courseList.length.toString())));
  }

  fetchStudentData() async {
    setState(() {
      processing = true;
      courseList.clear();
    });
    final QuerySnapshot result =
        await Firestore.instance.collection('student_course').getDocuments();

    final List<DocumentSnapshot> documents = result.documents;

    documents.forEach((data) {
      final studentCourse = StudentCourse.fromSnapshot(data);
      setState(() {
        courseList.add(studentCourse);
      });
    });
  }
}
