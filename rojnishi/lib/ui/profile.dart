import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:rojnishi/data/gender.dart';
import 'package:rojnishi/data/staticDatas.dart';

// ignore: must_be_immutable
class Profile extends StatefulWidget {
  GoogleSignInAccount user;
  Profile(this.user);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  String userGender = '';
  Gender m = Gender("Male", Icons.male, false);
  Gender f = Gender("Female", Icons.female, false);

  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  String pin = '', oldpin = '';

  final snackBar = SnackBar(content: Text('Profile Updated Successfully !!'));
  final pinErrorsnackBar = SnackBar(
      content: Text('Please insert valid pin to update information !!'));
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    setState(() {
      nameController.text = StaticDatas.username;
      mobileController.text = StaticDatas.mobileNumber;
      userGender = StaticDatas.gender;
      if (userGender == "Male") {
        m.isSelected = true;
      } else {
        f.isSelected = true;
      }
      oldpin = StaticDatas.password;
    });
  }

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.deepPurpleAccent),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.deepPurple.withOpacity(0.1),
      child: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(left: 20.0, top: 20.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[],
                        )),
                    Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Container(
                            width: 100.0,
                            height: 100.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(
                                    widget.user.photoUrl.toString()),
                                fit: BoxFit.cover,
                              ),
                            ))),
                    Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Text(widget.user.email))
                  ],
                ),
              ),
              Container(
                color: Color(0xffFFFFFF),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Parsonal Information',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  _status ? _getEditIcon() : Container(),
                                ],
                              )
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Name',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 2.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Flexible(
                                child: TextField(
                                  controller: nameController,
                                  decoration: const InputDecoration(
                                    hintText: "Enter Your Name",
                                  ),
                                  enabled: !_status,
                                  autofocus: !_status,
                                ),
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: Row(
                            children: [
                              Padding(
                                  padding:
                                      EdgeInsets.only(right: 25.0, top: 25.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            'Gender',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              Card(
                                  color: m.isSelected
                                      ? Color(0xFF3B4257)
                                      : Colors.white,
                                  child: InkWell(
                                    onTap: () {
                                      if (!_status) {
                                        setState(() {
                                          f.isSelected = false;
                                          m.isSelected = true;
                                          userGender = 'Male';
                                          StaticDatas.gender = 'Male';
                                        });
                                      }
                                    },
                                    child: Container(
                                      height: 60,
                                      width: 60,
                                      alignment: Alignment.center,
                                      margin: new EdgeInsets.all(5.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            m.icon,
                                            color: m.isSelected
                                                ? Colors.white
                                                : Colors.grey,
                                            size: 30,
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            m.name,
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: m.isSelected
                                                    ? Colors.white
                                                    : Colors.grey),
                                          )
                                        ],
                                      ),
                                    ),
                                  )),
                              Card(
                                  color: f.isSelected
                                      ? Color(0xFF3B4257)
                                      : Colors.white,
                                  child: InkWell(
                                    onTap: () {
                                      if (!_status) {
                                        setState(() {
                                          f.isSelected = true;
                                          m.isSelected = false;
                                          userGender = 'Female';
                                          StaticDatas.gender = 'Female';
                                        });
                                      }
                                    },
                                    child: Container(
                                      height: 60,
                                      width: 60,
                                      alignment: Alignment.center,
                                      margin: new EdgeInsets.all(5.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            f.icon,
                                            color: m.isSelected
                                                ? Colors.white
                                                : Colors.grey,
                                            size: 30,
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            f.name,
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: f.isSelected
                                                    ? Colors.white
                                                    : Colors.grey),
                                          )
                                        ],
                                      ),
                                    ),
                                  ))
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Mobile',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 2.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Flexible(
                                child: TextField(
                                  maxLength: 10,
                                  controller: mobileController,
                                  decoration: const InputDecoration(
                                      hintText: "Enter Mobile Number"),
                                  enabled: !_status,
                                ),
                              ),
                            ],
                          )),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 15.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        'Pin Password',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  !_status ? _getPinEditIcon() : Container(),
                                ],
                              ),
                              Container(
                                margin: const EdgeInsets.all(20.0),
                                padding: const EdgeInsets.all(20.0),
                                child: PinPut(
                                  preFilledWidget: Icon(Icons.donut_small),
                                  fieldsCount: 4,
                                  onSubmit: (String pin) =>
                                      _showSnackBar(pin, context),
                                  focusNode: _pinPutFocusNode,
                                  controller: _pinPutController,
                                  submittedFieldDecoration:
                                      _pinPutDecoration.copyWith(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  selectedFieldDecoration: _pinPutDecoration,
                                  followingFieldDecoration:
                                      _pinPutDecoration.copyWith(
                                    borderRadius: BorderRadius.circular(5.0),
                                    border: Border.all(
                                      color: Colors.deepPurpleAccent
                                          .withOpacity(.8),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10.0),
                            ],
                          ),
                        ),
                      ),
                      !_status ? _getActionButtons() : Container(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  // ignore: deprecated_member_use
                  child: RaisedButton(
                child: Text("Save"),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () {
                  print(nameController.text);
                  print(mobileController.text);
                  print(userGender);
                  print(pin);
                  if (oldpin == pin) {
                    if (nameController.text.length >= 4 &&
                        mobileController.text.length == 10) {
                      update();
                      setState(() {
                        _status = true;
                      });
                    }
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(pinErrorsnackBar);
                  }
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  // ignore: deprecated_member_use
                  child: RaisedButton(
                child: Text("Cancel"),
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () {
                  setState(() {
                    _status = true;
                  });
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String pin, BuildContext context) {
    setState(() {
      this.pin = pin;
    });

    final snackBar = SnackBar(
      duration: const Duration(seconds: 3),
      content: Container(
        height: 60.0,
        child: Center(
          child: Text(
            'Your Pin Password is : $pin',
            style: const TextStyle(fontSize: 25.0),
          ),
        ),
      ),
      backgroundColor: Colors.purpleAccent,
    );
    Scaffold.of(context)
      // ignore: deprecated_member_use
      ..hideCurrentSnackBar()
      // ignore: deprecated_member_use
      ..showSnackBar(snackBar);
  }

  Widget _getEditIcon() {
    return GestureDetector(
      child: CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }

  void update() async {
    print('update call...');
    try {
      await firestore
          .collection('rojnishi')
          .doc(widget.user.email.toString())
          .update({
        'name': nameController.text,
        'mobilenumber': mobileController.text,
        'password': pin,
        'gender': userGender
      });
    } catch (e) {
      print(e);
    }
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pop(context);
  }

  Widget _getPinEditIcon() {
    return GestureDetector(
      child: CircleAvatar(
        backgroundColor: Colors.blue,
        radius: 14.0,
        child: Icon(
          Icons.refresh,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
}
