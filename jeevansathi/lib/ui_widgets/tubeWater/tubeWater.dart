import 'package:flutter/material.dart';
import 'package:jeevansathi/ui_widgets/waveView.dart';

import '../appTheme.dart';

class TubeWater extends StatefulWidget {
  final double percent;
  final String label;
  final Color liquidColor, liquidUpperLayerColor;
  final Color tubeBorderColor;
  final Color tubeFontColor;

  const TubeWater(
      {Key key,
      this.percent = 80,
      this.label = "level",
      this.liquidUpperLayerColor = Colors.blue,
      this.tubeFontColor = Colors.white,
      this.tubeBorderColor = Colors.black,
      @required this.liquidColor})
      : super(key: key);

  @override
  _TubeWaterState createState() => _TubeWaterState();
}

class _TubeWaterState extends State<TubeWater> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.blue[50].withOpacity(0.6),
          ),
          width: 160,
          height: 160,
          child: Transform.scale(
              scale: 0.8,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    right: 10,
                    child: Container(
                        width: 60,
                        height: 150,
                        decoration: BoxDecoration(
                            border: Border.all(color: widget.tubeBorderColor),
                            borderRadius: BorderRadius.circular(80)),
                        child: WaveView(
                          percentageValue: widget.percent,
                          liquidColor: widget.liquidColor,
                          liquidUpperLayerColor: widget.liquidUpperLayerColor,
                        )),
                  ),
                  Positioned(
                      top: 40,
                      left: 10,
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          widget.label,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ))
                ],
              ))),
    );
  }
}
