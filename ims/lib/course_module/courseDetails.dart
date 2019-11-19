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

class CourseDetails extends StatefulWidget {
  final CourseRecord record;

  CourseDetails(this.record);
  @override
  _CourseDetails createState() => _CourseDetails(record);
}

class _CourseDetails extends State<CourseDetails> {
  final CourseRecord record;
  _CourseDetails(this.record);

  bool processing = false, status;
  DateTime dob, addDate;
  DateTime _fromDay = new DateTime(
      DateTime.now().year - 18, DateTime.now().month, DateTime.now().day);
  String thumbnail;
  File _imageFile;
  String photourl;
  bool flag = true;

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
                child: PNetworkImage(record.imageUrl, fit: BoxFit.cover),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(16.0, 200.0, 16.0, 16.0),
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
                                  Text(
                                    record.name,
                                    style: Theme.of(context).textTheme.title,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 30.0),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            right: BorderSide(
                                                width: 1,
                                                color: Colors.grey
                                                    .withOpacity(0.5)))),
                                    child: Column(
                                      children: <Widget>[
                                        Text("Since"),
                                        Chip(
                                          elevation: 12,
                                          label: Text(
                                            record.addDate
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
                                                    .toString(),
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          backgroundColor: Colors.green,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Text("Duration"),
                                      Chip(
                                        elevation: 12,
                                        label: Text(
                                          record.duration + ' hours',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.orange,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            left: BorderSide(
                                                width: 1,
                                                color: Colors.grey
                                                    .withOpacity(0.5)))),
                                    child: Column(
                                      children: <Widget>[
                                        Text("Fees"),
                                        Chip(
                                          elevation: 12,
                                          label: Text(
                                            record.fees + ' /-',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          backgroundColor: Colors.green,
                                        ),
                                      ],
                                    ),
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
                                    CachedNetworkImageProvider(record.imageUrl),
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
                          title: Text("Course Information"),
                        ),
                        Divider(),
                        ListTile(
                          title: Text("Added by"),
                          subtitle: Text(record.addedBy),
                          leading: Icon(Icons.account_box),
                        ),
                        ListTile(
                          title: Text("Teacher"),
                          subtitle: Text(record.teacher),
                          leading: Icon(Icons.person),
                        ),
                        ListTile(
                          title: Text("Syllabus"),
                          subtitle: Text(record.syllabus),
                          leading: Icon(Icons.book),
                        ),
                        ListTile(
                          title: Text("note"),
                          subtitle: Text(record.note),
                          leading: Icon(Icons.note),
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
      colorBlendMode: BlendMode.colorDodge,
      imageUrl: image,
      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
      fit: fit,
      width: width,
      height: height,
    );
  }
}
