import 'package:flutter/material.dart';

class Dia extends StatefulWidget {
  @override
  _DiaState createState() => _DiaState();
}

class _DiaState extends State<Dia> {
  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Red is winner"),
          actions: <Widget>[
            FlatButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Play again"),
              onPressed: () {
                print('Play again');
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          onPressed: () {
            _showDialog();
          },
          child: Text('click'),
        ),
      ),
    );
  }
}
