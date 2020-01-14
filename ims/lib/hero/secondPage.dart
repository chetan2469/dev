import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: ()
        {
          Navigator.pop(context);
        },
              child: Container(
          child: Hero(
            tag: "animDemo",
            child: Icon(
              Icons.play_arrow,
              size: 200.0,
            ),
          ),
        ),
      ),
    );
  }
}
