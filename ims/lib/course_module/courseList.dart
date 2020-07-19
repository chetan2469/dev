import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ims/constants/constants.dart';
import 'package:ims/course_module/addCourse.dart';
import 'package:ims/course_module/courseDetails.dart';
import 'package:ims/data/course_record.dart';
import 'package:ims/data/record.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ims/student_module/studentShowDetails.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CourseListView extends StatefulWidget {
  @override
  _CourseListViewState createState() => _CourseListViewState();
}

class _CourseListViewState extends State<CourseListView> {
  final Debouncer debouncer = Debouncer(50);
  List<CourseRecord> courseList = new List();
  List<CourseRecord> filteredcourseList = new List();
  bool processing = true;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  String searchStr = "";
  String searchBy = 'Name';
  Icon actionIcon = new Icon(Icons.search);
  Widget appBarTitle = new Text("");

  @override
  void initState() {
    super.initState();
    fetchCourseData();
    print(Constants.mode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.mode ? Colors.black87 : Colors.white,
      floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Constants.mode ? Colors.black : Colors.white,
          ),
          backgroundColor:
              Constants.mode ? Colors.white : Color.fromARGB(151, 255, 66, 66),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddCourse()));
          }),
      appBar: AppBar(
        backgroundColor:
            Constants.mode ? Colors.black : Color.fromARGB(151, 255, 66, 66),
        centerTitle: true,
        title: Text('Course List'),
      ),
      body: Center(
        child: processing
            ? CircularProgressIndicator()
            : SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                header: WaterDropHeader(),
                footer: CustomFooter(
                  builder: (BuildContext context, LoadStatus mode) {
                    Widget body;
                    if (mode == LoadStatus.idle) {
                      body = Text("no more data");
                    } else if (mode == LoadStatus.loading) {
                      body = CircularProgressIndicator();
                    } else if (mode == LoadStatus.failed) {
                      body = Text("Load Failed!Click retry!");
                    } else if (mode == LoadStatus.canLoading) {
                      body = Text("release to load more");
                    } else {
                      body = Text("No more Data");
                    }
                    return Container(
                      height: 55.0,
                      child: Center(child: body),
                    );
                  },
                ),
                controller: _refreshController,
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                child: ListView.builder(
                  itemCount: filteredcourseList.length,
                  itemBuilder: (BuildContext cotext, int i) {
                    return Padding(
                      key: ValueKey(filteredcourseList[i].name),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CourseDetails(filteredcourseList[i])));
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              top: 10, bottom: 3, left: 10, right: 10),
                          //color: Colors.grey[200],
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                width: 3,
                                color: Constants.mode
                                    ? Colors.white12
                                    : Colors.black12),
                            color: Constants.mode
                                ? Colors.transparent
                                : Colors.white.withOpacity(0.2),
                          ),
                          child: Container(
                            padding:
                                EdgeInsets.only(left: 2, top: 10, bottom: 10),
                            child: ListTile(
                              leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      filteredcourseList[i].imageUrl)),
                              title: Text(
                                filteredcourseList[i].name,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Constants.mode
                                        ? Colors.white70
                                        : Colors.black87),
                              ),
                              trailing: Chip(
                                avatar: Icon(
                                  Icons.timer,
                                  color: Constants.mode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                elevation: 12,
                                backgroundColor: Constants.mode
                                    ? Colors.black87
                                    : Colors.green.withOpacity(.7),
                                label: Text(
                                  filteredcourseList[i].duration + " hours",
                                  style: TextStyle(
                                    color: Constants.mode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }

  void _onRefresh() async {
    print("____________________onRefreshing______________________");
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 500));
    // if failed,use refreshFailed()

    await fetchCourseData();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    print("____________________onLoading______________________");
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 500));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    //await fetchStudentData();
    _refreshController.loadComplete();
  }

  fetchCourseData() async {
    setState(() {
      processing = true;
      filteredcourseList.clear();
    });
    final QuerySnapshot result =
        await Firestore.instance.collection('courses').getDocuments();

    final List<DocumentSnapshot> documents = result.documents;
    documents.forEach((data) {
      final record = CourseRecord.fromSnapshot(data);
      courseList.add(record);
      filteredcourseList.add(record);
    });

    setState(() {
      processing = false;
    });

    filteredcourseList.sort((a, b) {
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
  }
}

class Debouncer {
  final int milliSeconds;
  VoidCallback action;
  Timer _timer;

  Debouncer(this.milliSeconds);

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliSeconds), action);
  }
}
