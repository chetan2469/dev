import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'data/record.dart';

class Course extends StatefulWidget {
  @override
  _CourseState createState() => _CourseState();
}

class _CourseState extends State<Course> {
  List<String> nameList = new List();
  String selected;

  getData() async {
    final QuerySnapshot result =
        await Firestore.instance.collection('admission').getDocuments();

    final List<DocumentSnapshot> documents = result.documents;

    documents.forEach((data) {
      final record = Record.fromSnapshot(data);
      print(record.name);
      nameList.add(record.name);
    });
    setState(() {
      selected = nameList[0];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: EdgeInsets.all(40),
        child: DropdownButton(
          hint: Text('Please choose Student'),
          value: selected,
          onChanged: (newValue) {
            setState(() {
              selected = newValue;
            });
          },
          items: nameList.map((location) {
            return DropdownMenuItem(
              child: new Text(location),
              value: location,
            );
          }).toList(),
        ),
      ),
    );
  }
}
