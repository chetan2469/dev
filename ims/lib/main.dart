import 'package:flutter/material.dart';
import 'package:ims/animation.dart';
import 'package:ims/auth.dart';
import 'package:ims/demos/dialogue.dart';

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
      home: SignInG(),
    );
  }
}