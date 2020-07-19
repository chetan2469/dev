import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging();

  Future initialise() async {
    // if (Platform.isIOS) {
    //   _fcm.requestNotificationPermissions(IosNotificationSettings());
    // }

    _fcm.configure(
      //called when app is in the forground and we get push notification
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        //called when app is closed completely and its opened
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        //called when app is in the background and its opened
        //from the push notification
        print("onResume: $message");
      },
    );
  }
}
