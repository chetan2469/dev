import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jeevansathi/constants/firebase_constants.dart';
import 'package:jeevansathi/createProfile.dart';
import 'package:jeevansathi/login.dart';
import 'package:jeevansathi/main.dart';
import 'package:jeevansathi/transitions/scaleRoute.dart';

class Home extends StatefulWidget {
  final String email;

  const Home({Key key, this.email}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: DelayedDisplay(
          delay: Duration(seconds: 1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 80,
                child: Image.asset('assets/sakRed.png'),
              ),
              Container(
                margin: EdgeInsets.all(40),
                child: Text(
                  'Dont Have SAK Profile ?\nCreate Now...',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black45, fontSize: 30),
                ),
              ),
              FlatButton(
                  color: Colors.green,
                  onPressed: () {
                    Navigator.pushReplacement(
                        context, ScaleRoute(page: CreateProfile(widget.email)));
                  },
                  child: Text("Lets Create Profile",
                      style: TextStyle(color: Colors.white))),
              SizedBox(
                height: 20,
              ),
              FlatButton(
                  color: Colors.red,
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    cGoogleSignIn.signOut();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FireGoogleLogin()));
                  },
                  child:
                      Text("Sign out", style: TextStyle(color: Colors.white))),
            ],
          ),
        ),
      ),
    );
  }
}
