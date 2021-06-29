import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rojnishi/data/staticDatas.dart';
import 'package:rojnishi/readNote.dart';

class FriendNotes extends StatefulWidget {
  @override
  _FriendNotesState createState() => _FriendNotesState();
}

class _FriendNotesState extends State<FriendNotes> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String searchQuery = '';
  TextEditingController searchQueryController = TextEditingController();



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
                    'Friend List',
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
                          .doc(StaticDatas.userMail)
                          .collection('friends')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else
                          return ListView(
                            children: snapshot.requireData.docs.map((doc) {
                              return InkWell(
                                onTap: () {
                                  print(doc.id);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ReadNotes(doc.id.toString())));
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color:
                                            Color.fromARGB(205, 212, 229, 255),
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Container(
                                      child: ListTile(
                                        title: Text(doc.id),
                                        leading: Icon(Icons
                                            .connect_without_contact_outlined),
                                      ),
                                    )),
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
}
