import 'dart:async';
import 'dart:convert' show json;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ims/showMenu.dart';

import 'constants/constants.dart';

GoogleSignIn _googleSignIn = GoogleSignIn();

class SignInG extends StatefulWidget {
  @override
  State createState() => SignInGState();
}

class SignInGState extends State<SignInG> {
  GoogleSignInAccount _currentUser;
  String _contactText;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _handleGetContact();
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleGetContact() async {
    setState(() {
      _contactText = "Loading contact info...";
    });
    final http.Response response = await http.get(
      'https://people.googleapis.com/v1/people/me/connections'
      '?requestMask.includeField=person.names',
      headers: await _currentUser.authHeaders,
    );
    if (response.statusCode != 200) {
      setState(() {
        _contactText = "People API gave a ${response.statusCode} "
            "response. Check logs for details.";
      });
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data = json.decode(response.body);
    final String namedContact = _pickFirstNamedContact(data);
    setState(() {
      if (namedContact != null) {
        _contactText = "I see you know $namedContact!";
      } else {
        _contactText = "No contacts to display.";
      }
    });
  }

  String _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic> connections = data['connections'];
    final Map<String, dynamic> contact = connections?.firstWhere(
      (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    );
    if (contact != null) {
      final Map<String, dynamic> name = contact['names'].firstWhere(
        (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      );
      if (name != null) {
        return name['displayName'];
      }
    }
    return null;
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  Widget _buildBody() {
    if (_currentUser != null) {
      return ShowMenu(_handleSignOut);
    } else {
      return Column(
        children: <Widget>[
          SafeArea(
            child: SizedBox(
              height: 20,
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: <Widget>[
                Container(
                  height: 53,
                  width: 300,
                  decoration: BoxDecoration(
                    //blue
                    color: Color.fromRGBO(62, 93, 187, 1),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  margin: EdgeInsets.only(top: 5),
                  child: Row(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: Colors.white,
                          border: Border.all(
                            width: 1,
                            color: Color.fromRGBO(62, 93, 187, 1),
                          ),
                        ),
                        height: 70,
                        width: 47,
                        child: Icon(
                          FontAwesomeIcons.facebookF,
                          size: 16,
                          color: Color.fromRGBO(62, 93, 187, 1),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 53,
                  width: 300,
                  margin: EdgeInsets.only(top: 17),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 64, 76, 1),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: RaisedButton(
                    onPressed: _handleSignIn,
                    child: Text('Sign In with Google'),
                  ),
                ),
                Container(
                  height: 53,
                  width: 300,
                  margin: EdgeInsets.only(top: 17),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 64, 76, 1),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: RaisedButton(
                    onPressed: (){
                      handleSignInEmail('chedo@chedo.in','123457');
                    },
                    child: Text('Sign In with Email'),
                  ),
                ),
                Container(
                  height: 53,
                  width: 300,
                  margin: EdgeInsets.only(top: 17),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 64, 76, 1),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: RaisedButton(
                    onPressed: (){
                      handleSignUp('chedo@chedo.in','123456');
                    },
                    child: Text('Register with email'),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 82, top: 20),
                  child: Row(
                    children: <Widget>[],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: _buildBody(),
    ));
  }

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await cFirebaseAuth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
    return user;
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<FirebaseUser> handleSignInEmail(String email, String password) async {
   try{
      AuthResult result =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    final FirebaseUser user = result.user;

    assert(user != null);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await auth.currentUser();
    assert(user.uid == currentUser.uid);

    print('signInEmail succeeded: $user');

    return user;
   }
   catch(e)
   {
     print(e.toString());
     print('password or email invalid');
     return null;
   }
  }

  Future<FirebaseUser> handleSignUp(email, password) async {

    try{
      AuthResult result = await auth.createUserWithEmailAndPassword(email: email, password: password);
    final FirebaseUser user = result.user;

    assert (user != null);
    assert (await user.getIdToken() != null);

    return user;
    }
    catch(e)
    {
      print('user already Exist');
      return null;
    }

  } 
}
