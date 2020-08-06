import 'package:carousel_slider/carousel_slider.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flutter/material.dart';
import 'package:jeevansathi/caldidateList.dart';
import 'package:jeevansathi/navDrawer.dart';
import 'package:jeevansathi/ui_widgets/waving.dart';
import 'data.dart';
import 'datatype/Record.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Dashboard extends StatefulWidget {
  final FirebaseUser user;
  final Record profile;

  const Dashboard({Key key, @required this.user, this.profile})
      : super(key: key);
  @override
  _Dashboard createState() => new _Dashboard();
}

var cardAspectRatio = 11.0 / 16.0;
var widgetAspectRatio = cardAspectRatio * 1.2;

class _Dashboard extends State<Dashboard> {
  var currentPage = images.length - 1.0;
  bool validUser = false;
  ActorAnimation _animation, _clickAnimation;
  int _current = 0;

  String photoUrl =
      'http://www.iconhot.com/icon/png/user-web-20/256/icontexto-user-web-20-google.png';

  String documentPath;
  String email = "";
  bool processing = false;

  final List<String> imgList = [
    'assets/slider0.png',
    'assets/slider2.png',
    'assets/slider3.png',
    'assets/slider4.png',
  ];

  @override
  void initState() {
    super.initState();
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: processing
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                color: Colors.white,
                child: Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.white,
                      elevation: 1,
                      iconTheme: IconThemeData(color: Colors.black),
                      title: Text(
                        widget.profile.name,
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                      actions: <Widget>[
                        Container(
                            margin: EdgeInsets.all(10),
                            width: 40,
                            child: Image.asset('assets/sak.png'))
                      ],
                    ),
                    drawer: NavDrawer(),
                    backgroundColor: Colors.transparent,
                    body: Container(
                        child: Stack(
                      children: <Widget>[
                        Container(),
                        // Positioned(
                        //   bottom: 0,
                        //   right: 0,
                        //   child: Container(height: 200, child: Waveing()),
                        // ),
                        Positioned(
                          top: 50,
                          left: 50,
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2.7,
                            child: Column(
                              children: <Widget>[
                                InkWell(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CandidateList('Male'))),
                                  child: Card(
                                    color: Colors.cyan[100],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    elevation: 10,
                                    child: Container(
                                        height: 60,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text('Find Groom')
                                          ],
                                        )),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CandidateList('Female'))),
                                  child: Card(
                                    color: Colors.pink[100],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    elevation: 10,
                                    child: Container(
                                        height: 60,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text('Find Bride')
                                          ],
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 10,
                          bottom: -20,
                          child: Container(
                              height: MediaQuery.of(context).size.width / 1.5,
                              child: Image.asset('assets/flower.png')),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Image.asset('assets/backFlow.png')),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                              height: MediaQuery.of(context).size.height / 2,
                              child: Image.asset('assets/couple.png')),
                        ),
                      ],
                    ))),
              ));
  }
}
