import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rojnishi/data/staticDatas.dart';

class AddPartner extends StatefulWidget {
  @override
  _AddPartnerState createState() => _AddPartnerState();
}

class _AddPartnerState extends State<AddPartner> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String searchQuery = '';
  TextEditingController searchQueryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    'Add who can see your notes...',
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
                  flex: 2,
                  child: Container(
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Flexible(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Enter Partner full email id',
                                hintStyle: TextStyle(color: Colors.grey),
                                filled: true,
                                suffixIcon: Icon(Icons.search),
                                fillColor: Colors.white70,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0)),
                                  borderSide: BorderSide(
                                      color: Colors.red.withOpacity(.4),
                                      width: 2),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                              ),
                              onChanged: (str) {
                                setState(() {
                                  searchQuery = str;
                                });
                              },
                              controller: searchQueryController,
                            ),
                          ),
                        ],
                      ))),
              Expanded(
                  flex: 3,
                  child: Container(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: firestore.collection('rojnishi').where("email",
                          whereIn: [searchQuery, '']).snapshots(),
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
                                  margin: EdgeInsets.all(25),
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage((doc
                                            .data() as dynamic)['photoUrl']),
                                      ),
                                      title: Text(doc.id),
                                      trailing: IconButton(
                                          onPressed: () {
                                            addPartnerToFriendsArray(
                                                doc.id.toString());
                                          },
                                          icon: Icon(Icons.add)),
                                    ),
                                  ));
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

  void addPartnerToFriendsArray(String str) async {
    print('insert call...');
    try {
      await firestore
          .collection('rojnishi')
          .doc(str)
          .collection('friends')
          .doc(StaticDatas.userMail)
          .set({
        'friend_level': 1,
      });

      await firestore.collection('rojnishi').doc(StaticDatas.userMail).update({
        'friends': FieldValue.arrayUnion([str]),
      });
    } catch (e) {
      print(e);
    }
  }
}
