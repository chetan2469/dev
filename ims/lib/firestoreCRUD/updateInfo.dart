import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'data/Record.dart';

class UpdateContestant extends StatefulWidget {
  DocumentSnapshot data;
  UpdateContestant(this.data);

  @override
  State<StatefulWidget> createState() {
    return _UpdateContestant();
  }
}

class _UpdateContestant extends State<UpdateContestant> {
  final nameFieldController = TextEditingController();
  final voteFieldController = TextEditingController();

  Record record;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    record = Record.fromSnapshot(widget.data);
    nameFieldController.text = record.name;
    voteFieldController.text = record.votes.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Band"),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.all(12),
              child: GestureDetector(
                onTap: () {
                  delete();
                },
                child: Icon(Icons.delete),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            update();
          },
          child: Icon(
            Icons.done,
          ),
        ),
        body: Center(
          child: Container(
            margin: EdgeInsets.only(top: 100, left: 40, right: 40),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: nameFieldController,
                  decoration: InputDecoration(
                      hintText: 'Enter Name Here',
                      border: OutlineInputBorder()),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: TextField(
                    controller: voteFieldController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: 'Enter Votes Here',
                        border: OutlineInputBorder()),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void update() async {
    Firestore.instance
        .collection('bandnames')
        .document(widget.data.documentID)
        .setData({
      'name': nameFieldController.text,
      'votes': int.parse(voteFieldController.text)
    });
    Navigator.pop(context);
  }

  void delete() async {
    Firestore.instance
        .collection('bandnames')
        .document(widget.data.documentID)
        .delete()
        .catchError((onError) {
      print(onError);
    });
    Navigator.pop(context);
  }
}
