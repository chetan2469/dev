import 'package:flutter/material.dart';

class MembersInfo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MembersInfo();
  }
}

class _MembersInfo extends State<MembersInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: viewImage());
  }
}

class viewImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text('About'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Padding(
          padding: EdgeInsets.all(30.0),
          child: Column(
            children: <Widget>[
              Container(
                width: 99,
                margin: EdgeInsets.all(20),
                child: Image.asset('assets/sak.png'),
              ),
              Container(
                child: Text(
                  '       Somvanshi Arya Kshatriya Samaj is one of the community which has been spread all over India. The Origin of Somvanshi Arya Kshatriya Caste which was a bringing by Shri. Mukta Rishi was narrated by Lord Brahma the creator of the Universe to his Gem like son Narada Maharshi in Satva Loka.',
                  style: TextStyle(fontSize: 18),
                ),
              )
            ],
          )),
    );
  }
}
