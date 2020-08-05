import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'navDrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'datatype/Record.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';
import 'dart:async';
import 'FullProfile.dart';

class Search extends StatefulWidget {
  @override
  _Search createState() {
    return _Search();
  }
}

class _Search extends State<Search> {
  double width;
  File _cachedFile;
  Color fevColor = Colors.white;
  String searchBy = 'Name';
  Widget appBarTitle = new Text("");
  Icon actionIcon = new Icon(Icons.search);
  Icon selectIcon = new Icon(
    Icons.location_city,
    color: Colors.white,
  );
  String searchStr = "";
  static const searchByItems = <String>[
    'SAK-ID',
    'Name',
    'City',
  ];

  String getWhereValue() {
    if (searchBy == 'SAK-ID') {
      return 'sakId';
    } else if (searchBy == 'Name') {
      return 'name';
    } else if (searchBy == 'City') {
      return 'birthPlace';
    }
  }

  final List<DropdownMenuItem<String>> _dropDownMenuItems = searchByItems
      .map(
        (String value) => DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
          backgroundColor: Colors.pink,
          centerTitle: true,
          title: appBarTitle,
          actions: <Widget>[
            IconButton(
              alignment: Alignment.centerLeft,
              icon: actionIcon,
              onPressed: () {
                print(searchStr);
                setState(() {
                  if (this.actionIcon.icon == Icons.search) {
                    this.actionIcon = Icon(Icons.close);
                    this.appBarTitle = TextField(
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (String searchKey) {
                        setState(() {
                          searchStr = searchKey.toUpperCase();
                        });
                      },
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search, color: Colors.white),
                          hintText: "Enter Search text...",
                          hintStyle: TextStyle(color: Colors.white)),
                    );
                  } else {
                    this.actionIcon = Icon(Icons.search);
                    this.appBarTitle = Text('');
                  }
                });
              },
            ),
            Container(color: Colors.white, width: 20),
            Container(
              color: Colors.white,
              child: DropdownButton(
                value: searchBy,
                style: TextStyle(color: Colors.black),
                onChanged: ((String str) {
                  setState(() {
                    searchBy = str;
                  });
                  print(searchBy);
                }),
                items: _dropDownMenuItems,
              ),
            )
          ]),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("SAK")
          .where(getWhereValue(), isGreaterThanOrEqualTo: searchStr)
          .where("active", isEqualTo: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return LinearProgressIndicator(
            backgroundColor: Color(0xFFFFFF),
            valueColor: AlwaysStoppedAnimation(
              Color(0xFFF50057),
            ),
          );
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return GridView.count(
      // Create a grid with 2 columns. If you change the scrollDirection to
      // horizontal, this would produce 2 rows.
      crossAxisCount: 2,
      scrollDirection: Axis.vertical,
      // Generate 100 Widgets that display their index in the List
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);

    int age = Timestamp.now().toDate().year - record.dob.toDate().year;

    return GestureDetector(
      onTap: () async {
        Navigator.push(
            context,
            MaterialPageRoute(
                fullscreenDialog: true,
                builder: (BuildContext context) => viewImage(data)));
      },
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 6, right: 6, top: 6, bottom: 6),
            decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  alignment: FractionalOffset.topCenter,
                  image: CachedNetworkImageProvider(record.thumbnail),
                ),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(15.0),
                  topRight: const Radius.circular(15.0),
                  bottomLeft: const Radius.circular(15.0),
                  bottomRight: const Radius.circular(15.0),
                )),
          ),
          Container(
              padding: EdgeInsets.only(bottom: 1, right: 2),
              alignment: AlignmentDirectional(0, 1),
              child: Row(
                children: <Widget>[
                  Chip(
                    backgroundColor: Colors.pink,
                    label: Text(
                      record.sakId != null ? record.sakId.toString() : "SAK",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }

  Future<Null> downloadFile(String httpPath) async {
    final RegExp regExp = RegExp('([^?/]*\.(jpg))');
    final String fileName = regExp.stringMatch(httpPath);
    final Directory tempDir = Directory.systemTemp;
    final File file = File('${tempDir.path}/$fileName');

    final StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
    final StorageFileDownloadTask downloadTask = ref.writeToFile(file);

    final int byteNumber = (await downloadTask.future).totalByteCount;

    print(byteNumber);

    setState(() => _cachedFile = file);
  }
}

class viewImage extends StatelessWidget {
  final DocumentSnapshot data;
  Record record;
  int age;

  viewImage(this.data) {
    record = Record.fromSnapshot(data);
    age = Timestamp.now().toDate().year - record.dob.toDate().year;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.contacts),
        label: Text("More Info..."),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfileContactInfo(data)),
          );
        },
      ),
      backgroundColor: Colors.black12,
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Hero(
                tag: "hero",
                child: Container(
                  width: (MediaQuery.of(context).size.width),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: OutlineButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: 1,
            ),
            Positioned(
              bottom: 20.0,
              left: 10.0,
              right: 10.0,
              child: Card(
                elevation: 8.0,
                color: Colors.black38,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 14, left: 14, top: 14, bottom: 3),
                      child: Text(
                        record.name.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Roboto",
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 14, left: 14, top: 3, bottom: 3),
                      child: Text(
                        '( ${record.education.toUpperCase()} )',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Roboto",
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Wrap(
                      children: <Widget>[
                        Chip(
                          padding: EdgeInsets.all(10),
                          label: Text(
                            'Age : ${age.toString()}',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.red,
                        ),
                        Chip(
                          label: Text(
                            'Height : ${record.height}',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.orangeAccent,
                        ),
                        Chip(
                          avatar: Icon(
                            Icons.location_on,
                            color: Colors.white,
                          ),
                          label: Text(
                            record.birthPlace,
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.green,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
