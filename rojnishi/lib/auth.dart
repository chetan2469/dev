import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rive/rive.dart';
import 'package:rojnishi/dashboard.dart';
import 'package:rojnishi/data/staticDatas.dart';
import 'package:rojnishi/registration.dart';
import 'package:rojnishi/ui/progressButtonWidget.dart';
import 'package:flutter/cupertino.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
  scopes: <String>[
    'email',
  ],
);

class Auth extends StatefulWidget {
  @override
  State createState() => AuthState();
}

class AuthState extends State<Auth> {
  GoogleSignInAccount? _currentUser;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  void signout() {
    _handleSignOut();
    _currentUser!.clearAuthCache();
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  Widget _frontImage() {
    return Container(
        width: MediaQuery.of(context).size.width * .9,
        height: MediaQuery.of(context).size.width * 1.5,
        child: RiveAnimation.asset('assets/girl.riv'));
  }

  Widget _buildBody() {
    GoogleSignInAccount? user = _currentUser;
    if (user != null) {
      // insert(user);
      isNewUser(user);
      setState(() {
        StaticDatas.userMail = user.email;
      });
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(user.photoUrl.toString()),
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.all(5),
                    child: Text(
                      user.displayName.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Text(
                    user.email,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                  ),
                ],
              )
            ],
          ),
          Container(
            margin: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.all(20),
                    // ignore: deprecated_member_use
                    child: RaisedButton(
                      child: Text("Log Out"),
                      textColor: Colors.white,
                      color: Color.fromARGB(250, 255, 103, 74),
                      onPressed: () {
                        signout();
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                    )),
                Container(
                    margin: EdgeInsets.all(20),
                    // ignore: deprecated_member_use
                    child: RaisedButton(
                      child: Text("Continue"),
                      textColor: Colors.white,
                      color: Color.fromARGB(200, 47, 91, 102),
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.scale,
                                alignment: Alignment.bottomCenter,
                                child: Dashboard(signout, user)));
                        // Navigator.pushReplacement(
                        //     context,
                        //     CupertinoPageRoute(
                        //         builder: (context) =>
                        //             Dashboard(signout, user)));
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                    ))
              ],
            ),
          )
        ],
      );
    } else {
      return Container(
        child: ProgressButtonWidget(
          buttonName: "Sign In with Google",
          buttonTextColor: Colors.white,
          buttonColor: Colors.red,
          signIn: _handleSignIn,
          padding: 60,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: Column(
            children: [
              _frontImage(),
              _buildBody(),
            ],
          ),
        ));
  }

// Container(
//                   height: MediaQuery.of(context).size.height * .7,
//                   child: Image.network(
//                       'https://firebasestorage.googleapis.com/v0/b/flutter-chedo.appspot.com/o/pngs%2Fpngsmall-min.png?alt=media&token=a68aa868-8ae5-4d87-a6fd-b144b334d982')),
  void isNewUser(GoogleSignInAccount user) async {
    DocumentSnapshot documentSnapshot;
    try {
      documentSnapshot = await firestore
          .collection('rojnishi')
          .doc(user.email.toString())
          .get();
      print(documentSnapshot.data());
      if (documentSnapshot.data() == null) {
        print('new user  !!');
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => RegistrationUser(signout, user)));
        // insert(user);
      } else {
        print('found user !!');
        StaticDatas.joinedDate =
            (documentSnapshot.data() as dynamic)['joinedDate'].toString();
        StaticDatas.userMail =
            (documentSnapshot.data() as dynamic)['email'].toString();
        StaticDatas.mobileNumber =
            (documentSnapshot.data() as dynamic)['mobilenumber'].toString();
        StaticDatas.username =
            (documentSnapshot.data() as dynamic)['name'].toString();
        StaticDatas.password =
            (documentSnapshot.data() as dynamic)['password'].toString();
        StaticDatas.gender = (documentSnapshot.data() as dynamic)['gender'];
      }
    } catch (e) {
      print(e);
    }
  }
}
