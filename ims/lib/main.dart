import 'package:flutter/material.dart';
import 'package:ims/animation.dart';
import 'package:ims/auth.dart';
import 'package:ims/demos/calculator.dart';
import 'package:ims/demos/clippingtool.dart';
import 'package:ims/demos/dialogue.dart';
import 'package:ims/demos/listWheelScrollView.dart';
import 'package:ims/firebaseArrayCRUD/listArrayItems.dart';

import 'demos/jsonRead.dart';
import 'hero/HeroFirstAnimation.dart';

void main() => runApp(MyApp());
 
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "IMS",
      home:SignInG(),
    );
  }
}