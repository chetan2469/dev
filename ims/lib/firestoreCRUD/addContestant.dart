import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'list.dart';

class AddContestant extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddContestant();
  }
}

class _AddContestant extends State<AddContestant> {
  final nameFieldController = TextEditingController();
  final voteFieldController = TextEditingController();
  String name;
  int votes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Band"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print(name);
            print(votes);
            insert();
          },
          child: Icon(Icons.add),
        ),
        body: Center(
          child: Container(
            margin: EdgeInsets.only(top: 100, left: 40, right: 40),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: nameFieldController,
                  onChanged: (String str) {
                    name = str.toString();
                  },
                  decoration: InputDecoration(
                      hintText: 'Enter Name Here',
                      border: OutlineInputBorder()),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: TextField(
                    controller: voteFieldController,
                    onChanged: (String str) {
                      votes = int.parse(str);
                    },
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

  void insert() async {
    Firestore.instance.collection('bandnames').document().setData({
      'name': nameFieldController.text,
      'votes': int.parse(voteFieldController.text)
    });
    nameFieldController.text = '';
    voteFieldController.text = '';
    Navigator.pop(context);
  }
}
