import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ims/constants/constants.dart';
import 'package:ims/data/record.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ims/fancyFab.dart';
import 'package:ims/student_module/addmission.dart';
import 'package:ims/student_module/studentShowDetails.dart';
import 'studentShowDetails.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_sms/flutter_sms.dart';

class StudentListView extends StatefulWidget {
  @override
  _StudentListViewState createState() => _StudentListViewState();
}

class _StudentListViewState extends State<StudentListView> {
  final Debouncer debouncer = Debouncer(50);
  List<Record> studentList = new List();
  List<Record> filteredStudentList = new List();
  bool processing = true;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String searchStr = "";
  String searchBy = 'Name';
  Icon actionIcon = new Icon(Icons.search);
  Widget appBarTitle = new Text("Student List");
  String courseChar = 'C';
  static const searchByItems = <String>[
    'Name',
    'Course',
    'Status',
    'Batch Time',
    'Admission',
  ];

  // void demoListEntry() async {
  //   List selectedStudentReceiptReferences = List();

  //   for (var item in studentList) {
  //     DocumentReference referenceId =
  //         Firestore.instance.collection('receipts').document();
  //     await referenceId.setData({
  //       'course_name': item.pursuing_course,
  //       'paying_amount': 0,
  //       'course_id': item.courses.last,
  //       'receipt_date': DateTime(2019),
  //       'next_installment_date': null,
  //       'payment_method': 'Cash',
  //       'receipt_page_number': '000',
  //       'student_id': item.reference.documentID.toString(),
  //       'note': 'default',
  //     });

  //     selectedStudentReceiptReferences.clear();
  //     selectedStudentReceiptReferences.add(referenceId.documentID.toString());

  //     await Firestore.instance
  //         .collection('admission')
  //         .document(item.reference.documentID)
  //         .setData({
  //       'name': item.name,
  //       'address': item.address,
  //       'mobileNo': item.mobileno,
  //       'optNumber': item.optionalno,
  //       'aadharNo': item.aadharno,
  //       'batchTime': item.batchtime,
  //       'imageUrl': item.imageurl,
  //       'dateOfBirth': item.dateofbirth,
  //       'addDate': item.addDate,
  //       'status': item.status,
  //       'courses': item.courses,
  //       'pursuing_course': item.pursuing_course,
  //       'receipts': selectedStudentReceiptReferences,
  //       'outStandingAmount': 0,
  //       'addedBy': 'chetan2469@gmail.com'
  //     });
  //   }
  // }

  sortBy() {
    if (searchBy == 'Name') {
      filteredStudentList.sort((a, b) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
    } else if (searchBy == 'Admission') {
      filteredStudentList.sort((a, b) {
        return a.addDate
            .toString()
            .toLowerCase()
            .compareTo(b.addDate.toString().toLowerCase());
      });
    } else if (searchBy == 'Course') {
      filteredStudentList.sort((a, b) {
        return a.pursuing_course
            .toLowerCase()
            .compareTo(b.pursuing_course.toLowerCase());
      });
    } else if (searchBy == 'Status') {
      filteredStudentList.sort((a, b) {
        return a.status
            .toString()
            .toLowerCase()
            .compareTo(b.status.toString().toLowerCase());
      });
    } else if (searchBy == 'Batch Time') {
      filteredStudentList.sort((a, b) {
        return a.batchtime.toLowerCase().compareTo(b.batchtime.toLowerCase());
      });
    }
  }

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
    _onRefresh();
  }

  void _sendSMS(String message, List<String> recipents) async {
    String _result =
        await FlutterSms.sendSMS(message: message, recipients: recipents)
            .catchError((onError) {
      print(onError);
    });
    print(_result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constants.mode ? Colors.black87 : Colors.white,
        floatingActionButton: FloatingActionButton(
          backgroundColor:
              Constants.mode ? Colors.white : Color.fromARGB(192, 106, 99, 245),
          child: Icon(
            Icons.add,
            color: Constants.mode ? Colors.black87 : Colors.white,
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddStudInfo()));
          },
        ),
        appBar: AppBar(
          backgroundColor: Constants.mode
              ? Colors.black87
              : Color.fromARGB(192, 106, 99, 245),
          title: appBarTitle,
        ),
        resizeToAvoidBottomPadding: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: BottomAppBar(
          elevation: 20,
          child: Container(
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  alignment: Alignment.centerLeft,
                  icon: actionIcon,
                  onPressed: () {
                    print(searchStr);
                    setState(() {
                      if (this.actionIcon.icon == Icons.search) {
                        this.actionIcon = Icon(Icons.close);
                        this.appBarTitle = Container(
                          child: TextField(
                            textCapitalization: TextCapitalization.sentences,
                            onChanged: (String searchKey) {
                              debouncer.run(() {
                                setState(() {
                                  searchStr = searchKey;

                                  filteredStudentList = studentList
                                      .where((str) => (str.name
                                              .toLowerCase()
                                              .contains(
                                                  searchKey.toLowerCase()) ||
                                          str.pursuing_course
                                              .toLowerCase()
                                              .contains(
                                                  searchKey.toLowerCase())))
                                      .toList();
                                });
                              });
                            },
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                fillColor: Colors.white38,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(35),
                                ),
                                prefixIcon:
                                    Icon(Icons.search, color: Colors.black54),
                                hintText: "Search text...",
                                hintStyle: TextStyle(color: Colors.black54)),
                          ),
                        );
                      } else {
                        this.actionIcon = Icon(Icons.search);
                        this.appBarTitle = Text('');
                      }
                    });
                  },
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text('Sort By : '),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: DropdownButton(
                    hint: Text('sort by'),
                    icon: Icon(
                      Icons.sort_by_alpha,
                      color: Colors.black,
                    ),
                    value: searchBy,
                    style: TextStyle(color: Colors.black),
                    onChanged: ((String str) {
                      setState(() {
                        searchBy = str;
                      });
                      sortBy();
                    }),
                    items: _dropDownMenuItems,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: processing
            ? Center(child: CircularProgressIndicator())
            : Container(
                color: Colors.grey[100],
                child: SmartRefresher(
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
                    itemCount: filteredStudentList.length,
                    itemBuilder: (BuildContext cotext, int i) {
                      return Padding(
                        key: ValueKey(filteredStudentList[i].name),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 1),
                        child: Container(
                          height: 80,
                          padding: EdgeInsets.only(top: 5),
                          margin: EdgeInsets.only(
                              top: 5, bottom: 1, left: 5, right: 5),
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
                          //color: Colors.grey[200],,
                          child: Container(
                            height: 80,
                            child: ListTile(
                                leading: Container(
                                  child: CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                        filteredStudentList[i].imageurl),
                                  ),
                                ),
                                title: Text(
                                  filteredStudentList[i].name,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Constants.mode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                subtitle: Row(
                                  children: <Widget>[
                                    ActionChip(
                                        avatar: CircleAvatar(
                                          backgroundColor: getColor(
                                              filteredStudentList[i]
                                                  .pursuing_course[0]),
                                          child: Text(filteredStudentList[i]
                                              .pursuing_course[0]),
                                        ),
                                        label: Text(filteredStudentList[i]
                                            .pursuing_course),
                                        onPressed: () {}),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        String message = "";
                                        List<String> recipents = [
                                          filteredStudentList[i]
                                              .mobileno
                                              .toString()
                                        ];
                                        _sendSMS(message, recipents);
                                      },
                                      child: CircleAvatar(
                                        radius: 16,
                                        child: Icon(
                                          Icons.message,
                                          size: 15,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    InkWell(
                                      onTap: () {},
                                      child: CircleAvatar(
                                        radius: 16,
                                        child: Icon(
                                          Icons.phone,
                                          size: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                StudentShowDetails(
                                                    filteredStudentList[i])));
                                  });
                                },
                                trailing: Container(
                                  child: Icon(
                                    Icons.donut_small,
                                    size: 16,
                                    color: filteredStudentList[i].status
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                )),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ));
  }

  void _onRefresh() async {
    print("____________________onRefreshing______________________");
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()

    await fetchStudentData();
    _refreshController.refreshCompleted();

    // demoListEntry();
    // for change some datatypes of data....
  }

  void _onLoading() async {
    print("____________________onLoading______________________");
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    //await fetchStudentData();
    _refreshController.loadComplete();
  }

  fetchStudentData() async {
    setState(() {
      processing = true;
      filteredStudentList.clear();
      studentList.clear();
    });
    final QuerySnapshot result =
        await Firestore.instance.collection('admission').getDocuments();

    final List<DocumentSnapshot> documents = result.documents;

    documents.forEach((data) {
      final record = Record.fromSnapshot(data);
      studentList.add(record);
      filteredStudentList.add(record);
    });

    setState(() {
      processing = false;
    });

    filteredStudentList.sort((a, b) {
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
  }

  Color getColor(String char) {
    switch (char) {
      case 'C':
        return Colors.red;
        break;
      case 'P':
        return Colors.yellow;
        break;
      case 'J':
        return Colors.brown;
        break;
      case 'F':
        return Colors.blue;
        break;
      case 'D':
        return Colors.grey;
        break;
      case 'W':
        return Colors.white;
        break;
      default:
        return Colors.green;
    }
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
