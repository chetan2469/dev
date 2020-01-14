import 'package:flutter/material.dart';

class AnimatedSwitcherDemo extends StatefulWidget {
  @override
  _AnimatedSwitcherDemoState createState() => _AnimatedSwitcherDemoState();
}

Widget _redBox() {
  return Container(
    margin: EdgeInsets.all(20),
    height: 200,
    width: 200,
    color: Colors.red,
  );
}

class _AnimatedSwitcherDemoState extends State<AnimatedSwitcherDemo> {
  int _count = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(child: child, scale: animation);
        },
        child: Text(
          _count.toString(),
          key: ValueKey<int>(_count),
          style: TextStyle(fontSize: 80),
        ),
      )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          setState(() {
            _count += 1;
          });
        },
      ),
    );
  }
}
