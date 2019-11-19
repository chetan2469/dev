import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

// For firebase authentication.
final cFirebaseAuth = FirebaseAuth.instance;
// Google sign-in configuration.
final cGoogleSignIn = GoogleSignIn();
// A reference for uploading files to firebase storage.
final cFirebaseStorageRef = FirebaseStorage.instance.ref();

// Animation duration for sending message.
const cAnimationDuration = 700;
// Route name of the login screen.
const cLoginScreenRouteName = 'LoginScreen';

class Constants {
  static bool mode;
  static int fontSize;

  static setMode(bool b) async {
    mode = b;
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("chedo_ims_darkmode_on", b);
  }

  static getMode() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    mode = pref.getBool("chedo_ims_darkmode_on");
  }

  static setFontSize(int fs) async {
    fontSize = fs;
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt("chedo_ims_font_size", fontSize);
  }

  static getFontSize() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    fontSize = pref.getInt("chedo_ims_font_size");
  }

  static Future<bool> getConst() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    print(pref.getBool("chedo_ims_constants"));
  }
}
