import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ims/receiptMenu.dart/receipt.dart';
import 'package:ims/showMenu.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/auth_strings.dart';

import 'constants/constants.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class Auth extends StatefulWidget {
  @override
  State createState() => AuthState();
}

class AuthState extends State<Auth> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseUser user;

  bool canCheckBiometrics;
  var localAuth = LocalAuthentication();
  bool didAuthenticate;
  List<BiometricType> availableBiometrics;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //  check();

    cFirebaseAuth.currentUser().then(
          (user) => setState(() {
            this.user = user;
          }),
        );
  }

  Future initialSetup() async {
    canCheckBiometrics = await localAuth.canCheckBiometrics;

    didAuthenticate = await localAuth.authenticateWithBiometrics(
        localizedReason: 'Please authenticate to show account balance');

    availableBiometrics = await localAuth.getAvailableBiometrics();
  }

  check() async {
    const iosStrings = const IOSAuthMessages(
        cancelButton: 'cancel',
        goToSettingsButton: 'settings',
        goToSettingsDescription: 'Please set up your Touch ID.',
        lockOut: 'Please reenable your Touch ID');

    if (await localAuth.authenticateWithBiometrics(
        localizedReason: 'Please Authenticate Yourself',
        useErrorDialogs: true,
        iOSAuthStrings: iosStrings)) {
      print('Perfect !!');

      cFirebaseAuth.currentUser().then(
            (user) => setState(() {
              this.user = user;
              if (user != null) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) {
                      return ShowMenu(signOutGoogle);
                    },
                  ),
                );
              }
            }),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {
                  // check();
                },
                child: Icon(
                  Icons.fingerprint,
                  size: 150,
                ),
              ),
              SizedBox(height: 50),
              _signInButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.red,
      onPressed: () {
        signInWithGoogle().whenComplete(() {
          // check();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) {
                return ShowMenu(signOutGoogle);
              },
            ),
          );
        });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.gamepad),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return 'signInWithGoogle succeeded: $user';
  }

  void signOutGoogle() async {
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
    setState(() {
      user = null;
    });
    print("User Sign Out");
  }
}
