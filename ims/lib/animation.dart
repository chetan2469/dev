import 'package:flutter/material.dart';

class AnimationIcon extends StatefulWidget {
  @override
  _AnimationIconState createState() => _AnimationIconState();
}

class _AnimationIconState extends State<AnimationIcon>with SingleTickerProviderStateMixin {
  
  AnimationController _animationController;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 2000));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animated Icon Demo'),
        centerTitle: true,
      ),
      body: Container(
        child: Center(
          child: IconButton(
            iconSize: 50,
            icon: AnimatedIcon(
              icon: AnimatedIcons.view_list,
              progress: _animationController,
            ),
            onPressed: () => _handleOnPressed(),
          ),
        ),
      ),
    );
  }

  void _handleOnPressed() {
    setState(() {
      isPlaying = !isPlaying;
      isPlaying
          ? _animationController.forward()
          : _animationController.reverse();
    });
  }
}
