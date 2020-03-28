import 'package:flutter/material.dart';
import 'package:ims/auth.dart';
import 'package:ims/demos/animatedSwitcher.dart';
import 'package:ims/demos/clippingtool.dart';

main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSwitcherDemo(),
    );
  }
}
