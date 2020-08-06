import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'MembersInfo.dart';
import 'admin.dart';
import 'dashboard.dart';
import 'constants/firebase_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile.dart';
import 'login.dart';
import 'search.dart';
import 'help.dart';

class NavDrawer extends StatefulWidget {
  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  FirebaseUser user;
  String documentPath;
  String name = '',
      email = '',
      photoUrl =
          'http://www.iconhot.com/icon/png/user-web-20/256/icontexto-user-web-20-google.png';

  @override
  void initState() {
    super.initState();

    cFirebaseAuth.currentUser().then(
          (user) => setState(() {
            this.user = user;
            name = user.displayName;
            email = user.email;
            photoUrl = user.photoUrl;
          }),
        );
    documentPath = '/SAK/${email.toString()}';
  }

  static const searchByItems = <String>[
    'SAK-ID',
    'Name',
    'City',
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
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 10,
      child: Container(
        decoration: BoxDecoration(color: Color.fromARGB(255, 250, 250, 250)),
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              margin: EdgeInsets.all(10),
              accountName: Text(name,
                  style: TextStyle(fontSize: 20, color: Colors.black87)),
              accountEmail: Text(
                " ( ${email} )",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              decoration: BoxDecoration(color: Colors.blue[50]),
              currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(photoUrl, scale: 1.0)),
              otherAccountsPictures: <Widget>[
                CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(
                        'https://cdn.iconscout.com/icon/free/png-256/google-470-675827.png',
                        scale: 1.0)),
              ],
            ),
            Divider(),
            ListTile(
                leading: Icon(FontAwesomeIcons.chartArea),
                title: Text(
                  "Profile",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              Profile(user.email)));
                }),
            ListTile(
                leading: Icon(FontAwesomeIcons.info),
                title: Text(
                  "About",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => MembersInfo()));
                }),
            email == 'chetan2469@gmail.com' ||
                    email == '201preeti3bhange@gmail.com'
                ? ListTile(
                    leading: Icon(FontAwesomeIcons.boxes),
                    title: Text(
                      "Admin",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Admin()));
                    })
                : Container(),
            ListTile(
                leading: Icon(FontAwesomeIcons.handPointUp),
                title: Text(
                  "Got Engaged ?",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                onTap: () {
                  launchWhatsApp(
                      phone: "918793100815",
                      message:
                          "*i+got+engaged*+please+deactive+my+profile+my+profile+email+is  " +
                              email);
                }),
            ListTile(
                leading: Icon(FontAwesomeIcons.questionCircle),
                title: Text(
                  "Help",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => Help()));
                }),
            ListTile(
                leading: Icon(Icons.all_out),
                title: Text(
                  "Sign Out",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                onTap: () async {
                  FirebaseAuth.instance.signOut();
                  await cGoogleSignIn.signOut();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FireGoogleLogin()));
                }),
          ],
        ),
      ),
    );
  }

  void showModal(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.music_note),
                    title: new Text(user.displayName),
                    onTap: () => {}),
                new ListTile(
                  leading: new Icon(Icons.videocam),
                  title: new Text(user.email),
                  onTap: () => {},
                ),
              ],
            ),
          );
        });
  }

  Future<void> _exit() async {
    // exit(0);
  }

  void launchWhatsApp({
    @required String phone,
    @required String message,
  }) async {
    String url() {
      if (Platform.isIOS) {
        return "whatsapp://wa.me/$phone/?text=${Uri.parse(message)}";
      } else {
        return "whatsapp://send?phone=$phone&text=${Uri.parse(message)}";
      }
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }
}
