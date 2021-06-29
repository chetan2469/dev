import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ReadNotes extends StatefulWidget {
  String whoseNotes;
  ReadNotes(this.whoseNotes);
  @override
  _ReadNotesState createState() => _ReadNotesState();
}

class _ReadNotesState extends State<ReadNotes> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ListTile(
                  leading: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back_ios),
                  ),
                  title: Text(
                    widget.whoseNotes,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                    child: CachedNetworkImage(
                  placeholder: (context, url) => Center(
                      child: Container(
                          width: 60,
                          height: 60,
                          child: CircularProgressIndicator())),
                  imageUrl:
                      'https://firebasestorage.googleapis.com/v0/b/flutter-chedo.appspot.com/o/logo%2Fconnect.png?alt=media&token=e752ba05-89d9-4974-b0d9-874e59739035',
                )),
              ),
              Expanded(
                  flex: 8,
                  child: Container(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: firestore
                          .collection('rojnishi')
                          .doc(widget.whoseNotes)
                          .collection('notes')
                          .orderBy('dateTime', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else
                          return ListView(
                            children: snapshot.requireData.docs.map((doc) {
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color.fromARGB(205, 212, 229, 255),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                margin: EdgeInsets.all(5),
                                child: ExpansionTile(
                                  textColor: Colors.red,
                                  backgroundColor:
                                      Color.fromARGB(205, 212, 229, 255),
                                  title: ListTile(
                                    title: Text(getDateLabel(convertDate(
                                        (doc.data() as dynamic)['dateTime']
                                            .toString()
                                            .split('=')[1]
                                            .split(',')[0]))),
                                    subtitle: Text(getTimeLabel(convertDate(
                                        (doc.data() as dynamic)['dateTime']
                                            .toString()
                                            .split('=')[1]
                                            .split(',')[0]))),
                                    trailing: CircleAvatar(
                                      foregroundColor: Colors.blueAccent,
                                      child: Text(
                                          (doc.data() as dynamic)['happyRate']
                                              .toString()),
                                    ),
                                  ),
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(20),
                                      child: Text(
                                        (doc.data() as dynamic)['note']
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                      alignment: Alignment.topLeft,
                                    )
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                      },
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  String getTimeLabel(DateTime dt) {
    return dt.hour.toString() + ':' + dt.minute.toString();
  }

  DateTime convertDate(String sec) {
    DateTime dt = DateTime.fromMillisecondsSinceEpoch(int.parse(sec + '100'));
    return dt;
  }

  String getDateLabel(DateTime dt) {
    if (dt.day == DateTime.now().day &&
        dt.month == DateTime.now().month &&
        dt.year == DateTime.now().year) {
      return 'Today ';
    } else if (dt.day == (DateTime.now().day - 1) &&
        dt.month == DateTime.now().month &&
        dt.year == DateTime.now().year) {
      return 'Yesterday ';
    }
    return dt.day.toString() +
        ' / ' +
        dt.month.toString() +
        ' / ' +
        dt.year.toString();
  }
}
