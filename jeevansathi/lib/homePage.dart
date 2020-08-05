import 'package:flutter/material.dart';
import 'dashboard.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomePage();
  }
}

class _HomePage extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();
  FirebaseUser user;
  bool authenticate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(20),
              child: Text(
                "Log In with",
                style: TextStyle(
                    fontSize: 20, color: Colors.black.withOpacity(0.8)),
              ),
            ),
            Container(
              width: 140,
              height: 50,
              margin: EdgeInsets.all(10),
              child: RaisedButton(
                child: Text(
                  "Google",
                  style: TextStyle(color: Color(0xFFFBE9E7), fontSize: 20),
                ),
                splashColor: Color(0xFFFFCDD2),
                color: Color(0xFFEF5350),
                onPressed: () {
                  if (authenticate) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => Dashboard()));
                  }
                },
              ),
            ),
            Container(
              width: 140,
              height: 50,
              margin: EdgeInsets.all(10),
              child: RaisedButton(
                child: Text(
                  "Mobile",
                  style: TextStyle(color: Color(0xFFFBE9E7), fontSize: 20),
                ),
                splashColor: Color(0xFFFFCDD2),
                color: Color(0xFF263238),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
