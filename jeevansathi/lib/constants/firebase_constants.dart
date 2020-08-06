import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

// For firebase authentication.
final cFirebaseAuth = FirebaseAuth.instance;
// Google sign-in configuration.
final cGoogleSignIn = GoogleSignIn();
// A reference to the firebase realtime database.
final cFirebaseDbRef = FirebaseDatabase.instance.reference();
// A reference for uploading files to firebase storage.
final cFirebaseStorageRef = FirebaseStorage.instance.ref();

// Animation duration for sending message.
const cAnimationDuration = 700;
// Route name of the login screen.
const cLoginScreenRouteName = 'LoginScreen';
