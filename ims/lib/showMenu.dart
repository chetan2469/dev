import 'package:ims/course_module/courseList.dart';
import 'package:ims/enquiryForm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ims/student_module/addmission.dart';
import 'package:ims/student_module/studentListView.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'constants/constants.dart';
import 'package:flutter/cupertino.dart';

class ShowMenu extends StatefulWidget {
  final Function _handleSignOut;

  ShowMenu(this._handleSignOut);

  @override
  _ShowMenu createState() => _ShowMenu();
}

class _ShowMenu extends State<ShowMenu> {
  bool mode = false;
  FirebaseUser user;

  String photourl =
      'http://www.stleos.uq.edu.au/wp-content/uploads/2016/08/image-placeholder.png';
  String enqFormUrl =
      "https://docs.google.com/forms/d/e/1FAIpQLSez0X0Ja72aPveJVYzUiVWAb6YGwAhMJ8LrfXu_9Q3U-dhxhw/viewform";
  String enqUrl =
      "https://docs.google.com/spreadsheets/d/1Nhc9AAdfBI0cMqBOJ367w_L6_hsH0OCBvfXMSjrzJcE/edit#gid=79772504";

  @override
  void initState() {
    super.initState();

    getMode();

    cFirebaseAuth.currentUser().then(
          (user) => setState(() {
            this.user = user;
            photourl = user.photoUrl;
          }),
        );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: menuDrawer(context),
      backgroundColor: mode ? Colors.black87 : Colors.grey[300],
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Container(
                color: mode ? Colors.black87 : Colors.white,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                        left: 20,
                        top: 55,
                        child: Container(
                            width: 90,
                            height: 90,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(photourl),
                            ))),
                    Positioned(
                        right: 20,
                        top: 50,
                        child: InkWell(
                            onTap: () {
                              _scaffoldKey.currentState.openDrawer();
                            },
                            child: dropMenu()))
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => AddStudInfo()));
                      },
                      child: Container(
                        margin: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(200, 90, 150, 239),
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                        //color: Color.fromARGB(200, 90, 150, 239),
                        child: Center(
                          child: Text(
                            "ADMISSION",
                            style: TextStyle(fontSize: 25, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          // Navigator.push(
                          //     context,
                          //     CupertinoPageRoute(
                          //         builder: (context) =>
                          //             WebViewContainer(enqFormUrl)));
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(210, 25, 25, 112),
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                        //color: Color.fromARGB(210, 25, 25, 112),
                        child: Center(
                          child: Text(
                            "ENQUIRY",
                            style: TextStyle(fontSize: 25, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 6,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => StudentListView()));
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(162, 106, 99, 245),
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                        //color: Color.fromARGB(162, 106, 99, 245),
                        child: Center(
                          child: Text(
                            "STUDENT",
                            style: TextStyle(fontSize: 25, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => CourseListView()));
                      },
                      child: Container(
                        margin: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(151, 255, 66, 66),
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                        child: Center(
                          child: Text(
                            "COURSES",
                            style: TextStyle(fontSize: 25, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
                flex: 2,
                child: Container(
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        child: Container(
                          height: 10,
                          color: mode ? Colors.black87 : Colors.white,
                        ),
                      ),
                      Container(
                        color: mode ? Colors.black87 : Colors.white,
                        height: 150,
                      ),
                      Container(
                        color: mode ? Colors.black87 : Colors.grey[300],
                        height: 40,
                      ),
                      Container(
                        child: Center(
                          child: FloatingActionButton(
                            onPressed: () {
                              var media = MediaQuery.of(context);
                              print(media.size.width);
                              print(media.size.height);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  void selectedChoice(String s) {
    if (s == 'Profile') {
    } else if (s == 'Setting') {
    } else if (s == 'Contact') {
    } else if (s == 'Logout') {
      setState(() {
        widget._handleSignOut();
      });
    }
  }

  Widget dropMenu() {
    return Container(
      margin: EdgeInsets.only(top: 45, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 5),
            width: 40,
            height: 5,
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(20)),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 5),
            width: 30,
            height: 5,
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(20)),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 4),
            width: 40,
            height: 5,
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(20)),
          ),
        ],
      ),
    );
  }

  Widget menuDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: mode ? Colors.black87 : Colors.white10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(top: 20, left: 20),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.black12,
                  child: CircleAvatar(
                    radius: 45,
                    backgroundImage: NetworkImage(photourl),
                  ),
                )),
            Container(
              margin: EdgeInsets.only(top: 10, left: 20, right: 20),
              child: ListTile(
                title: Text(
                  "Night Mode",
                  style: TextStyle(
                      fontSize: 20,
                      color: mode ? Colors.white38 : Colors.black38),
                ),
                trailing: Switch(
                  value: mode,
                  onChanged: (bool b) {
                    setState(() {
                      mode = !mode;
                    });
                    setMode(mode);
                  },
                ),
              ),
            ),
            Container(
              height: 2,
              margin: EdgeInsets.only(top: 10, left: 20, right: 20),
              color: Colors.grey,
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              decoration: BoxDecoration(
                  color: Color.fromARGB(220, 25, 25, 112),
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => StudentListView()));
                },
                leading: Icon(
                  Icons.face,
                  color: Colors.white,
                  size: 30,
                ),
                title: Text(
                  "Student",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              decoration: BoxDecoration(
                  color: Color.fromARGB(212, 106, 99, 245),
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: Icon(
                  Icons.people,
                  color: Colors.white,
                  size: 30,
                ),
                title: Text(
                  "Teacher",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              decoration: BoxDecoration(
                  color: Color.fromARGB(221, 255, 66, 66),
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => CourseListView()));
                },
                leading: Icon(
                  Icons.book,
                  color: Colors.white,
                  size: 30,
                ),
                title: Text(
                  "Course",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              decoration: BoxDecoration(
                  color: Color.fromARGB(210, 90, 150, 239),
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                onTap: () {
                  // Navigator.push(context,
                  //     CupertinoPageRoute(builder: (context) => Receipt()));
                },
                leading: Icon(
                  Icons.book,
                  color: Colors.white,
                  size: 30,
                ),
                title: Text(
                  "Receipt",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(12)),
              child: InkWell(
                onTap: () {},
                child: ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 30,
                  ),
                  title: Text(
                    "Setting",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
            Container(
              height: 2,
              margin: EdgeInsets.only(top: 5, left: 20, right: 20),
              color: Colors.grey,
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(12)),
              child: InkWell(
                onTap: () async {
                  final user = await FirebaseAuth.instance.currentUser();
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text("Logging Off")));
                  FirebaseAuth.instance.signOut();
                  widget._handleSignOut();
                },
                child: ListTile(
                  leading: Icon(
                    Icons.developer_board,
                    color: Colors.white,
                    size: 30,
                  ),
                  title: Text(
                    "Logout",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
            Container(
              height: 2,
              margin: EdgeInsets.only(top: 10, left: 20, right: 20),
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  _launchURL() async {
    const url =
        'https://docs.google.com/spreadsheets/d/1Nhc9AAdfBI0cMqBOJ367w_L6_hsH0OCBvfXMSjrzJcE/edit#gid=79772504';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  setMode(bool b) async {
    setState(() {
      this.mode = b;
      Constants.mode = b;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("chedo_ims_darkmode_on", b);
  }

  getMode() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    mode = pref.getBool("chedo_ims_darkmode_on");

    setState(() {
      this.mode = mode;
      Constants.mode = mode;
    });
  }
}
