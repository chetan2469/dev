import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pinput/pin_put/pin_put.dart';

import '../auth.dart';

// ignore: must_be_immutable
class SetPassword extends StatefulWidget {
  GoogleSignInAccount user;
  String name, mobileNumber;
  SetPassword(this.user, this.name, this.mobileNumber);
  @override
  SetPasswordState createState() => SetPasswordState();
}

class SetPasswordState extends State<SetPassword> {
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String pin = '';

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.deepPurpleAccent),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Builder(
        builder: (context) {
          return Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CircleAvatar(
                    maxRadius: 45,
                    backgroundImage:
                        NetworkImage(widget.user.photoUrl.toString()),
                  ),
                  Container(
                    margin: EdgeInsets.all(22),
                    child: Text(
                      'Set pin password for app ',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(20.0),
                    padding: const EdgeInsets.all(20.0),
                    child: PinPut(
                      fieldsCount: 4,
                      onSubmit: (String pin) => _showSnackBar(pin, context),
                      focusNode: _pinPutFocusNode,
                      controller: _pinPutController,
                      submittedFieldDecoration: _pinPutDecoration.copyWith(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      selectedFieldDecoration: _pinPutDecoration,
                      followingFieldDecoration: _pinPutDecoration.copyWith(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(
                          color: Colors.deepPurpleAccent.withOpacity(.8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      // ignore: deprecated_member_use
                      FlatButton(
                        onPressed: () => _pinPutController.text = '',
                        child: const Text('Clear All'),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.purple)),
                      ),
                      // ignore: deprecated_member_use
                      FlatButton(
                        onPressed: () => insert(widget.user),
                        child: const Text('Submit'),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.purple)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
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
            'Your app password is : $pin',
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

  void insert(GoogleSignInAccount user) async {
    print('insert call...');
    try {
      await firestore
          .collection('rojnishi')
          .doc(widget.user.email.toString())
          .set({
        'name': widget.name,
        'email': user.email,
        'joinedDate': DateTime.now(),
        'mobilenumber': widget.mobileNumber,
        'password': pin
      });
    } catch (e) {
      print(e);
    }
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Auth()));
  }
}
