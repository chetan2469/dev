import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:like_button/like_button.dart';

import 'datatype/Record.dart';

class CandidateShowDetails extends StatefulWidget {
  final Record record;

  CandidateShowDetails(this.record);

  @override
  _CandidateShowDetails createState() => _CandidateShowDetails(record);
}

class _CandidateShowDetails extends State<CandidateShowDetails> {
  Set favouritePersonReferences = Set();
  final Record record;
  _CandidateShowDetails(this.record);
  int heart = 20;

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

  @override
  void initState() {
    super.initState();
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    /// send your request here

    print(isLiked);

    return !isLiked;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
      },
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
              child: Text('close'),
              onPressed: () {
                Navigator.pop(context);
              }),
          backgroundColor: Colors.black12,
          body: DelayedDisplay(
            delay: Duration(milliseconds: 300),
            child: SafeArea(
              child: processing == false
                  ? SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Column(
                              children: <Widget>[
                                Stack(
                                  children: <Widget>[
                                    Container(
                                        child: PNetworkImage(record.photoUrl)),
                                    Positioned(
                                        top: 40,
                                        right: 40,
                                        child: LikeButton(
                                          onTap: onLikeButtonTapped,
                                          size: 40,
                                          circleColor: CircleColor(
                                              start: Colors.red,
                                              end: Colors.redAccent[100]),
                                          bubblesColor: BubblesColor(
                                            dotPrimaryColor:
                                                Colors.redAccent[100],
                                            dotSecondaryColor: Colors.redAccent,
                                          ),
                                          likeBuilder: (bool isLiked) {
                                            return Icon(
                                              Icons.favorite,
                                              color: isLiked
                                                  ? Colors.red
                                                  : Colors.grey,
                                              size: 40,
                                            );
                                          },
                                          countBuilder: (int count,
                                              bool isLiked, String text) {
                                            var color = isLiked
                                                ? Colors.deepPurpleAccent
                                                : Colors.grey;
                                            Widget result;
                                            if (count == 0) {
                                              result = Text(
                                                "love",
                                                style: TextStyle(color: color),
                                              );
                                            } else
                                              result = Text(
                                                text,
                                                style: TextStyle(color: color),
                                              );
                                            return result;
                                          },
                                        ))
                                  ],
                                ),
                                SizedBox(height: 15.0),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white10,
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      ListTile(
                                        title: Text("Name",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10)),
                                        subtitle: Text(record.name,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14)),
                                        leading: Icon(
                                          Icons.person,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Divider(
                                        color: Colors.white24,
                                      ),
                                      ListTile(
                                        title: Text("Marital Status",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10)),
                                        subtitle: Text(record.maritalStatus,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14)),
                                        leading: Icon(
                                          FontAwesomeIcons.questionCircle,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Divider(
                                        color: Colors.white24,
                                      ),
                                      ListTile(
                                        title: Text("Education",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10)),
                                        subtitle: Text(record.education,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14)),
                                        leading: Icon(
                                          Icons.school,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Divider(
                                        color: Colors.white24,
                                      ),
                                      ListTile(
                                        title: Text("Date Of Birth",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10)),
                                        subtitle: Text(
                                            record.dob
                                                .toDate()
                                                .toString()
                                                .substring(0, 11),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14)),
                                        leading: Icon(
                                          FontAwesomeIcons.birthdayCake,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Divider(
                                        color: Colors.white24,
                                      ),
                                      ListTile(
                                        title: Text("Height",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10)),
                                        subtitle: Text(record.height + ' ft',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14)),
                                        leading: Icon(
                                          FontAwesomeIcons.ruler,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Divider(
                                        color: Colors.white24,
                                      ),
                                      ListTile(
                                        title: Text("Phone",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10)),
                                        subtitle: Text(
                                            record.mob1 +
                                                "   /   " +
                                                record.mob2,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14)),
                                        leading: Icon(
                                          Icons.phone,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Divider(
                                        color: Colors.white24,
                                      ),
                                      ListTile(
                                        title: Text("Birth Address",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10)),
                                        subtitle: Text(
                                            record.birthPlace +
                                                " " +
                                                record.birthState,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14)),
                                        leading: Icon(
                                          Icons.map,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Divider(
                                        color: Colors.white24,
                                      ),
                                      ListTile(
                                        title: Text("Current Address",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10)),
                                        subtitle: Text(
                                            record.currentRecidential,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14)),
                                        leading: Icon(
                                          Icons.location_city,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Divider(
                                        color: Colors.white24,
                                      ),
                                      ListTile(
                                        title: Text("Expectations From Partner",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10)),
                                        subtitle: Text(
                                            record.expectations + "__",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14)),
                                        leading: Icon(
                                          Icons.account_box,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Divider(
                                        color: Colors.white24,
                                      ),
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
            ),
          )),
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
      placeholder: (context, url) => Container(
          height: 300, child: Center(child: CircularProgressIndicator())),
      errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
      fit: fit,
      width: width,
      height: height,
    );
  }
}
