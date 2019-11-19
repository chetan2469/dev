import 'dart:async';

import 'package:flutter/material.dart';
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
    // TODO: implement initState
    super.initState();
    fetchCourseData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(192, 106, 99, 245),
        centerTitle: true,
        title: Text('Course List'),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.all(10),
            child: FlatButton.icon(
              icon: Icon(Icons.add,color: Colors.white,),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>AddCourse()));
              },
              label: Text(
                'Course',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
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
                              top: 10, bottom: 5, left: 10, right: 10),
                          //color: Colors.grey[200],
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border:
                                  Border.all(width: 3, color: Colors.black12),
                              color: Colors.white.withOpacity(0.2)),
                          child: Container(
                            height: 100,
                            padding:
                                EdgeInsets.only(left: 2, top: 20, bottom: 20),
                            child: ListTile(
                              leading: Image(
                                fit: BoxFit.fill,
                                image: new CachedNetworkImageProvider(
                                    filteredcourseList[i].imageUrl),
                              ),
                              title: Text(
                                filteredcourseList[i].name,
                                style: TextStyle(fontSize: 20),
                              ),
                              trailing: Chip(
                                avatar: Icon(Icons.timer),
                                elevation: 12,
                                backgroundColor: Colors.green.withOpacity(0.7),
                                label: Text(
                                    filteredcourseList[i].duration + " hours"),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                    ;
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
