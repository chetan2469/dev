import 'package:cached_network_image/cached_network_image.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rojnishi/addNote.dart';
import 'package:rojnishi/data/notes.dart';
import 'package:rojnishi/ui/backlayer.dart';
import 'package:backdrop/backdrop.dart';

// ignore: must_be_immutable
class Dashboard extends StatefulWidget {
  Function signOut;
  GoogleSignInAccount user;
  Dashboard(this.signOut, this.user);
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    print(widget.user.photoUrl);
  }

  @override
  Widget build(BuildContext context) {
    return DelayedDisplay(
      child: BackdropScaffold(
        // ignore: deprecated_member_use
        title: Text("Dashboard"),
        // ignore: deprecated_member_use
        actions: <Widget>[
          Container(
            margin: EdgeInsets.all(8),
            child: CircleAvatar(
              maxRadius: 20,
              backgroundImage: NetworkImage(widget.user.photoUrl.toString()),
            ),
          ),
        ],
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddNote(widget.user, widget.signOut)),
            );
          },
          child: Icon(Icons.add),
        ),
        backLayer: BackdropLayer(widget.signOut, widget.user),
        frontLayer: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                    width: MediaQuery.of(context).size.width * .8,
                    height: MediaQuery.of(context).size.width * 1.5,
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Center(
                          child: Container(
                              width: 60,
                              height: 60,
                              child: CircularProgressIndicator())),
                      imageUrl:
                          'https://firebasestorage.googleapis.com/v0/b/flutter-chedo.appspot.com/o/pngs%2Fimage%202.png?alt=media&token=943c4131-94d1-46a1-845d-47aa3855f266',
                    )),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: firestore
                        .collection('rojnishi')
                        .doc(widget.user.email.toString())
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
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> deleteEntry(String id) async {
    try {
      await firestore
          .collection('rojnishi')
          .doc(widget.user.email.toString())
          .collection('notes')
          .doc(id)
          .update({
        'isDeleted': true,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
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

  String getTimeLabel(DateTime dt) {
    return dt.hour.toString() + ':' + dt.minute.toString();
  }

  DateTime convertDate(String sec) {
    DateTime dt = DateTime.fromMillisecondsSinceEpoch(int.parse(sec + '100'));
    return dt;
  }
}

// ignore: unused_element
class _NoteItem extends StatelessWidget {
  _NoteItem(this.note, this.reference);

  final Note note;
  final DocumentReference<Note> reference;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, top: 4),
      child: Row(
        children: [
          Flexible(
              child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.dateTime.toString(),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
