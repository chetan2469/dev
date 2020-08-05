import 'package:carousel_slider/carousel_slider.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flutter/material.dart';
import 'package:jeevansathi/caldidateList.dart';
import 'package:jeevansathi/navDrawer.dart';
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
                    backgroundColor: Colors.blue[50].withOpacity(0.1),
                    elevation: 0,
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
                  body: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      SizedBox(height: 10),
                      Expanded(
                          flex: 3,
                          child: DelayedDisplay(
                            delay: Duration(seconds: 1),
                            child: Container(
                                margin: EdgeInsets.all(10),
                                child: CarouselSlider(
                                    options: CarouselOptions(
                                        onPageChanged: (index, reason) {
                                          setState(() {
                                            _current = index;
                                          });
                                        },
                                        carouselController: CarouselController,
                                        viewportFraction: 0.8,
                                        initialPage: 0,
                                        enableInfiniteScroll: true,
                                        reverse: false,
                                        autoPlay: true,
                                        autoPlayInterval: Duration(seconds: 4),
                                        autoPlayAnimationDuration:
                                            Duration(milliseconds: 800),
                                        autoPlayCurve: Curves.fastOutSlowIn,
                                        enlargeCenterPage: true,
                                        scrollDirection: Axis.horizontal,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                2),
                                    items: imgList
                                        .map((item) => Container(
                                              margin: EdgeInsets.only(
                                                  left: 20, right: 20),
                                              child: Center(
                                                  child: Image.asset(item,
                                                      fit: BoxFit.cover,
                                                      width: 10000)),
                                            ))
                                        .toList())),
                          )),
                      Expanded(
                        flex: 1,
                        child: DelayedDisplay(
                          delay: Duration(milliseconds: 1500),
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                        map<Widget>(imgList, (index, url) {
                                      return Container(
                                        width: 7.0,
                                        height: 7.0,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 2.0),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: _current == index
                                              ? Colors.blue[200]
                                              : Colors.blueAccent,
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                                Text(
                                  'SAK Jeevansathi',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  'Somvanshi Arya Kshatriyas Matrimonial Portal',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: DelayedDisplay(
                              delay: Duration(milliseconds: 2000),
                              child: InkWell(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CandidateList('Male'))),
                                child: Card(
                                  elevation: 10,
                                  margin: EdgeInsets.all(20),
                                  child: Container(
                                      height: 220,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Image.asset('assets/boy.png'),
                                          Text('Find Groom')
                                        ],
                                      )),
                                ),
                              ),
                            )),
                            Expanded(
                                child: DelayedDisplay(
                              delay: Duration(milliseconds: 2500),
                              child: InkWell(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CandidateList('Female'))),
                                child: Card(
                                  elevation: 10,
                                  margin: EdgeInsets.all(20),
                                  child: Container(
                                      height: 220,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Image.asset('assets/girl.png'),
                                          Text('Find Bride')
                                        ],
                                      )),
                                ),
                              ),
                            )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ));
  }
}
