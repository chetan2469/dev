import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jeevansathi/createProfile.dart';
import 'package:jeevansathi/dashboard.dart';
import 'package:jeevansathi/transitions/scaleRoute.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

import 'dashboard/home.dart';
import 'profile.dart';
import 'constants/firebase_constants.dart';
import 'datatype/Record.dart';

final kFirebaseAnalytics = FirebaseAnalytics();

// NOTE: to add firebase support, first go to firebase console, generate the
// firebase json file, and add configuration lines in the gradle files.
// C.f. this commit: https://github.com/X-Wei/flutter_catalog/commit/48792cbc0de62fc47e0e9ba2cd3718117f4d73d1.
class FireGoogleLogin extends StatefulWidget {
  const FireGoogleLogin({Key key}) : super(key: key);

  @override
  _FireGoogleLoginState createState() => _FireGoogleLoginState();
}

class _FireGoogleLoginState extends State<FireGoogleLogin> {
  FirebaseUser _user;
  bool status = false;
  Record profile;
  // If this._busy=true, the buttons are not clickable. This is to avoid
  // clicking buttons while a previous onTap function is not finished.
  bool _busy = false, processing = false, validSakUser = false;
  String msg = 'Signing in with google';

  @override
  void initState() {
    super.initState();
    setState(() {
      processing = true;
      signOut();
      processing = false;
    });
  }

  getUserData() {
    print('here in user data....');
    Firestore.instance
        .collection('SAK')
        .document(_user.email)
        .get()
        .then((DocumentSnapshot ds) {
      setState(() {
        profile = Record.fromSnapshot(ds);
        print(profile.name);
      });
    });
  }

  Future<void> getProfileStatus() async {
    Firestore.instance
        .collection('SAK')
        .document(_user.email)
        .get()
        .then((DocumentSnapshot ds) {
      setState(() {
        status = ds['active'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final avatar = CircleAvatar(
        backgroundImage: NetworkImage(
            _user != null
                ? _user.photoUrl
                : 'https://i.pinimg.com/originals/51/f6/fb/51f6fb256629fc755b8870c801092942.png',
            scale: 1.0));

    final googleLoginBtn = _user != null
        ? SizedBox()
        : Column(
            children: <Widget>[
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
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 20,
              ),
              MaterialButton(
                animationDuration: Duration(milliseconds: 500),
                hoverElevation: 11,
                color: Colors.grey[200],
                elevation: 5,
                child: ListTile(
                  leading: Icon(
                    FontAwesomeIcons.google,
                    color: Colors.red,
                  ),
                  title: Text(
                    'Log in with Google',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                onPressed: this._busy
                    ? null
                    : () async {
                        if (_user == null) {
                          setState(() {
                            this._busy = true;
                            this.processing = true;
                          });
                          final user = await this._googleSignIn();
                          setState(() {
                            this._busy = false;
                          });

                          isSakRegisteredAccount();
                        } else {
                          print('already user present');
                        }
                      },
              ),
            ],
          );

    final gap = SizedBox(height: 20);

    final yourProfile = _user != null && status
        ? MaterialButton(
            color: Colors.lightBlueAccent,
            elevation: 5,
            child: ListTile(
              leading: avatar,
              title: Text(
                'Activated SAK user Click to Continue ...',
                style: TextStyle(color: Colors.black),
              ),
            ),
            onPressed: () async {
              setState(() {
                processing = true;
                msg = 'Going to Dashboard';
              });
              Timer(const Duration(seconds: 2), () {
                setState(() {
                  processing = true;
                });

                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Dashboard(
                              user: _user,
                              profile: profile,
                            )));
              });
            },
          )
        : SizedBox();

    final profileFoundButNotActive =
        _user != null && status == false && processing == false
            ? DelayedDisplay(
                delay: Duration(seconds: 2),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Profile is not Activted !!',
                      style: TextStyle(color: Colors.red),
                    ),
                    gap,
                    MaterialButton(
                      color: Colors.green,
                      child: ListTile(
                        leading: Icon(
                          FontAwesomeIcons.whatsapp,
                          color: Colors.white,
                        ),
                        title: Text(
                          'WhatsApp us for Activation Process',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      onPressed: () async {
                        launchWhatsApp(
                            phone: "918793100815",
                            message:
                                "Please+activate+my+profile+on+SAK%5Cn+my+profile+email+is  " +
                                    _user.email);
                      },
                    ),
                    gap,
                    MaterialButton(
                      color: Colors.redAccent,
                      child: ListTile(
                        leading: Icon(
                          FontAwesomeIcons.procedures,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Update Profile',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    Profile(_user.email)));
                      },
                    )
                  ],
                ),
              )
            : SizedBox();

    // final sakProfile = _user == null
    //     ? SizedBox()
    //     : MaterialButton(
    //         color: Colors.blueAccent,
    //         child: ListTile(
    //           leading: avatar,
    //           title: Text(
    //             'SAK Profile Found !!',
    //             style: TextStyle(color: Colors.white),
    //           ),
    //         ),
    //         onPressed: () async {
    //           // Navigator.pushReplacement(context,
    //           //     MaterialPageRoute(builder: (context) => Dashboard()));
    //         },
    //       );
    final signOutBtn = _user == null
        ? SizedBox()
        : MaterialButton(
            color: Colors.redAccent,
            elevation: 12,
            child: Text(
              'Log out',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: this._busy
                ? null
                : () async {
                    setState(() {
                      this._busy = true;
                      msg = 'Signing out';
                      status = false;
                      processing = true;
                    });

                    await this.signOut();
                    setState(() {
                      this._busy = false;
                      msg = '';
                      processing = false;
                    });
                  },
          );
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: <Widget>[
          Container(),
          Positioned(
            left: 20,
            top: 20,
            child: Container(
                width: 50,
                alignment: Alignment.centerRight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.asset(
                  'assets/sakRed.png',
                )),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              DelayedDisplay(
                delay: Duration(seconds: 2),
                child: Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 10),
                  height: MediaQuery.of(context).size.height / 2.1,
                  child: Image.asset('assets/slider0.png'),
                ),
              ),
              processing
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: CircularProgressIndicator(),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Text(
                            msg,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    )
                  : Container(
                      margin: EdgeInsets.only(left: 60, right: 60),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          DelayedDisplay(
                              delay: Duration(milliseconds: 500),
                              child: yourProfile),
                          googleLoginBtn,
                          DelayedDisplay(
                              delay: Duration(seconds: 2),
                              child: profileFoundButNotActive),
                          gap,
                          DelayedDisplay(
                              delay: Duration(milliseconds: 700),
                              child: signOutBtn)
                        ],
                      ),
                    ),
            ],
          ),
        ],
      ),
    ));
  }

  // Sign in with Google.
  Future<FirebaseUser> _googleSignIn() async {
    final curUser = this._user ?? await FirebaseAuth.instance.currentUser();
    if (curUser != null && !curUser.isAnonymous) {
      return curUser;
    }
    final googleUser = await GoogleSignIn().signIn();
    final googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    // Note: user.providerData[0].photoUrl == googleUser.photoUrl.
    final user =
        (await FirebaseAuth.instance.signInWithCredential(credential)).user;
    kFirebaseAnalytics.logLogin();
    setState(() => this._user = user);

    return user;
  }

  Future<Null> signOut() async {
    setState(() {
      validSakUser = false;
    });
    FirebaseAuth.instance.signOut();
    await cGoogleSignIn.signOut();
    setState(() => this._user = null);
  }

  Future<Void> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount =
        await cGoogleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult =
        await FirebaseAuth.instance.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    assert(user.uid == currentUser.uid);
  }

  void isSakRegisteredAccount() {
    print('isSakRegisteredAccount method called');
    setState(() {
      processing = true;
      msg = 'Ckecking SAK Account';
    });
    print(_user.email);
    String documentPath = '/SAK/${_user.email.toString()}';
    print("${documentPath}_____________---------${_user.email}");

    Firestore.instance
        .document(documentPath)
        .get()
        .then((DocumentSnapshot doc) {
      if (doc.exists) {
        getProfileStatus();
        setState(() {
          validSakUser = true;
          print("________FOUND_______${documentPath}___");
          getUserData();
          print(status);
          // Navigator.pushReplacement(
          //     context, MaterialPageRoute(builder: (context) => Dashboard()));
        });
      } else {
        setState(() {
          validSakUser = false;
        });
        print("________NOT FOUND_______${documentPath}___");
        Navigator.pushReplacement(
            context, ScaleRoute(page: Home(email: _user.email)));
      }
    });
    print("______________________________________Valid SAK User = " +
        validSakUser.toString());

    if (!validSakUser) {
      print('going for registration');
    }

    setState(() {
      processing = false;
    });
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
