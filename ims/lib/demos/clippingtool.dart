import 'package:flutter/material.dart';

class ClippingToolDemo extends StatefulWidget {
  @override
  _ClippingToolDemoState createState() => _ClippingToolDemoState();
}

class _ClippingToolDemoState extends State<ClippingToolDemo> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      child: Container(
        color: Colors.red,
      ),
      clipper: BottomWaveClipper(),
    );
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  // Path getClip(Size size) {
  //   Path path = Path();
  //   path.lineTo(0, size.height / 3);
  //   path.quadraticBezierTo(
  //       size.width / 2, size.height/2, size.width, size.height / 3);
  //   path.lineTo(size.width, 0);
  //   path.close();

  //   return path;
  // }
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0.0, size.height/3);

    // var x = Offset(size.width / 4, size.height);

    // var y = Offset(size.width / 2.25, size.height - 30.0);
    // path.quadraticBezierTo(x.dx, x.dy, y.dx, y.dy);

    var sx = Offset(size.width - (size.width / 2), size.height/2);
    var sy = Offset(size.width, size.height/3);

    path.quadraticBezierTo(sx.dx, sx.dy, sy.dx, sy.dy);

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
