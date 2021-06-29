import 'package:google_sign_in/google_sign_in.dart';

class UserInfo {
  GoogleSignInAccount gmailAccount;
  String username = '';
  String password = '';
  String gender = '';
  DateTime joinedDate = new DateTime(2021);
  String profilepicurl = '';

  UserInfo(this.gmailAccount, this.joinedDate, this.username, this.password,
      this.profilepicurl);
}
