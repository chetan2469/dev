import 'package:flutter/material.dart';

class RitchTextDemo extends StatefulWidget {
  @override
  _RitchTextDemoState createState() => _RitchTextDemoState();
}

class _RitchTextDemoState extends State<RitchTextDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.all(20),
          child: RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 16),
              children: <TextSpan>[
                TextSpan(
                    text: 'Lorem Ipsum ',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 29)),
                TextSpan(
                    text:
                        'is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the'),
                TextSpan(text: '1500s,',style: TextStyle(backgroundColor: Colors.yellowAccent,)),
                
                TextSpan(
                    text:'when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
