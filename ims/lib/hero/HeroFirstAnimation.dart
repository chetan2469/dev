import 'package:flutter/material.dart';
import 'package:ims/hero/secondPage.dart';
import 'package:flutter/cupertino.dart';

class HeroFirstAnimation extends StatefulWidget {
  @override
  _HeroFirstAnimationState createState() => _HeroFirstAnimationState();
}

class _HeroFirstAnimationState extends State<HeroFirstAnimation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SecondPage()));
          },
          child: Container(
            child: Hero(
              tag: "animDemo",
              child: Icon(
                Icons.play_arrow,
                size: 70.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
