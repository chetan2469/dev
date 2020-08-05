import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ims/auth.dart';
import 'package:ims/ui_widgets/animatedLogo.dart';
import 'package:ims/ui_widgets/tubeWater/tubeWater.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  double percent = 43;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignInG(),
    );
  }
}

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:ims/auth.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);
//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   String title = "Title";
//   String helper = "helper";

//   FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();

//     _firebaseMessaging.configure(
//       onMessage: (message) async {
//         setState(() {
//           title = message["notification"]["title"];
//           helper = "You have recieved a new notification";
//         });
//       },
//       onResume: (message) async {
//         setState(() {
//           title = message["data"]["title"];
//           helper = "You have open the application from notification";
//         });
//       },
//     );
//   }

//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SignInG();
//   }
// }
