import 'package:flutter/material.dart';
import 'dart:async';

// ignore: must_be_immutable
class ProgressButtonWidget extends StatefulWidget {
  String buttonName;
  Color buttonTextColor, buttonColor;
  double padding;
  Function signIn;
  ProgressButtonWidget(
      {required this.buttonName,
      required this.buttonTextColor,
      required this.buttonColor,
      required this.signIn,
      required this.padding});
  @override
  _ProgressButtonWidgetState createState() => _ProgressButtonWidgetState();
}

class _ProgressButtonWidgetState extends State<ProgressButtonWidget>
    with TickerProviderStateMixin {
  int _state = 0;
  late Animation _animation;
  late AnimationController _controller;
  GlobalKey _globalKey = GlobalKey();
  double _width = double.maxFinite;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(
          left: widget.padding,
          right: widget.padding,
        ),
        child: Align(
          alignment: Alignment.center,
          child: PhysicalModel(
            elevation: 8,
            shadowColor: Colors.black,
            color: Colors.lightGreen,
            borderRadius: BorderRadius.circular(25),
            child: Container(
              key: _globalKey,
              height: 48,
              width: _width,
              // ignore: deprecated_member_use
              child: RaisedButton(
                animationDuration: Duration(milliseconds: 1000),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: EdgeInsets.all(0),
                child: setUpButtonChild(),
                onPressed: () {
                  setState(() {
                    if (_state == 0) {
                      animateButton();
                    }
                    widget.signIn();
                  });
                },
                elevation: 4,
                color: widget.buttonColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  setUpButtonChild() {
    if (_state == 0) {
      return Text(
        widget.buttonName,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      );
    } else if (_state == 1) {
      return SizedBox(
        height: 36,
        width: 36,
        child: CircularProgressIndicator(
          value: null,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else {
      return Icon(Icons.check, color: Colors.white);
    }
  }

  void animateButton() {
    double initialWidth = 200;

    _controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);

    _animation = Tween(begin: 0.0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {
          _width = initialWidth - ((initialWidth - 48) * _animation.value);
        });
      });
    _controller.forward();

    setState(() {
      _state = 1;
    });

    Timer(Duration(milliseconds: 3300), () {
      setState(() {
        _state = 0;
        _width = 200;
      });
    });
  }
}
