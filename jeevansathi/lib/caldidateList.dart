import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'candidateDetailsView.dart';
import 'navDrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'datatype/Record.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';
import 'dart:async';
import 'FullProfile.dart';

class CandidateList extends StatefulWidget {
  final String gender;

  const CandidateList(this.gender);

  @override
  _CandidateList createState() {
    return _CandidateList();
  }
}

class _CandidateList extends State<CandidateList> {
  final Debouncer debouncer = Debouncer(50);
  List<Record> candidateList = new List();
  List<Record> filteredcandidateList = new List();
  bool processing = true, labelshow = true;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String searchStr = "";
  String searchBy = 'Name';
  Icon actionIcon = new Icon(Icons.search);
  Widget appBarTitle =
      new Text("Find Jeevansathi Here", style: TextStyle(color: Colors.black));
  String courseChar = 'C';
  static const searchByItems = <String>['SAK-ID', 'Name', 'City', 'Age'];

  double width;
  File _cachedFile;
  Color fevColor = Colors.white;
  Icon selectIcon = new Icon(
    Icons.location_city,
    color: Colors.white,
  );

  @override
  void initState() {
    super.initState();
    _onRefresh();
  }

  Widget labelSwitch() {
    return Switch(
      value: labelshow,
      focusColor: Colors.blueAccent,
      onChanged: (value) {
        setState(() {
          labelshow = value;
          print(labelshow);
        });
      },
      activeTrackColor: Colors.lightGreenAccent,
      activeColor: Colors.green,
    );
  }

  String getSortByChip(int index) {
    if (searchBy == 'SAK-ID') {
      return filteredcandidateList[index].sakId.toString();
    } else if (searchBy == 'Name') {
      return filteredcandidateList[index].name.length > 12
          ? filteredcandidateList[index].name.substring(0, 10) + '...'
          : filteredcandidateList[index].name;
    } else if (searchBy == 'City') {
      return filteredcandidateList[index].birthPlace.length > 12
          ? filteredcandidateList[index].birthPlace.substring(0, 10) + '...'
          : filteredcandidateList[index].birthPlace;
    } else if (searchBy == 'Age') {
      return filteredcandidateList[index].dob.toDate().day.toString() +
          ' / ' +
          filteredcandidateList[index].dob.toDate().month.toString() +
          ' / ' +
          filteredcandidateList[index].dob.toDate().year.toString();
    }
  }

  sortBy() {
    if (searchBy == 'Name') {
      filteredcandidateList.sort((a, b) {
        return a.name.trim().toLowerCase().compareTo(b.name.toLowerCase());
      });
    } else if (searchBy == 'City') {
      filteredcandidateList.sort((a, b) {
        return a.birthPlace
            .toString()
            .toLowerCase()
            .compareTo(b.birthPlace.toString().toLowerCase());
      });
    } else if (searchBy == 'SAK-ID') {
      filteredcandidateList.sort((a, b) {
        return a.sakId.toLowerCase().compareTo(b.sakId.toLowerCase());
      });
    } else if (searchBy == 'Age') {
      filteredcandidateList.sort((b, a) {
        return a.dob.compareTo(b.dob);
      });
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

  String getWhereValue() {
    if (searchBy == 'SAK-ID') {
      return 'sakId';
    } else if (searchBy == 'Name') {
      return 'name';
    } else if (searchBy == 'City') {
      return 'birthPlace';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue[50].withOpacity(0.1),
          elevation: 0,
          title: appBarTitle,
          iconTheme: IconThemeData(color: Colors.black),
          actions: <Widget>[
            IconButton(
              alignment: Alignment.centerLeft,
              icon: actionIcon,
              onPressed: () {
                print(searchStr);
                setState(() {
                  if (this.actionIcon.icon == Icons.search) {
                    this.actionIcon = Icon(Icons.close);
                    this.appBarTitle = Container(
                      child: TextField(
                        textCapitalization: TextCapitalization.sentences,
                        onChanged: (String searchKey) {
                          debouncer.run(() {
                            setState(() {
                              searchStr = searchKey;

                              filteredcandidateList = candidateList
                                  .where((str) => (str.name
                                          .toLowerCase()
                                          .contains(searchKey.toLowerCase()) ||
                                      str.name
                                          .toLowerCase()
                                          .contains(searchKey.toLowerCase())))
                                  .toList();
                            });
                          });
                        },
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            fillColor: Colors.white38,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(35),
                            ),
                            prefixIcon:
                                Icon(Icons.search, color: Colors.black54),
                            hintText: "Search text...",
                            hintStyle: TextStyle(color: Colors.black54)),
                      ),
                    );
                  } else {
                    this.actionIcon = Icon(Icons.search);
                    this.appBarTitle = Text('');
                  }
                });
              },
            ),
          ],
        ),
        resizeToAvoidBottomPadding: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: BottomAppBar(
          elevation: 20,
          child: Container(
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text('Sort By : '),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: DropdownButton(
                    hint: Text('sort by'),
                    icon: Icon(
                      Icons.sort_by_alpha,
                      color: Colors.black,
                    ),
                    value: searchBy,
                    style: TextStyle(color: Colors.black),
                    onChanged: ((String str) {
                      setState(() {
                        searchBy = str;
                      });
                      sortBy();
                    }),
                    items: _dropDownMenuItems,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: labelSwitch(),
                ),
                Container(
                  child: Text('labels'),
                ),
              ],
            ),
          ),
        ),
        body: processing
            ? Center(child: CircularProgressIndicator())
            : Container(
                color: Colors.grey[100],
                child: SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: true,
                  header: WaterDropHeader(),
                  footer: CustomFooter(
                    builder: (BuildContext context, LoadStatus mode) {
                      Widget body;
                      if (mode == LoadStatus.idle) {
                        body = Text("no more data");
                      } else if (mode == LoadStatus.loading) {
                        body = CircularProgressIndicator();
                      } else if (mode == LoadStatus.failed) {
                        body = Text("Load Failed!Click retry!");
                      } else if (mode == LoadStatus.canLoading) {
                        body = Text("release to load more");
                      } else {
                        body = Text("No more Data");
                      }
                      return Container(
                        height: 55.0,
                        child: Center(child: body),
                      );
                    },
                  ),
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  onLoading: _onLoading,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemCount: filteredcandidateList.length,
                    itemBuilder: (BuildContext cotext, int i) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CandidateShowDetails(
                                      filteredcandidateList[i])));
                        },
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: Stack(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                    left: 6, right: 6, top: 6, bottom: 6),
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      alignment: FractionalOffset.topCenter,
                                      image: CachedNetworkImageProvider(
                                          filteredcandidateList[i].thumbnail !=
                                                  null
                                              ? filteredcandidateList[i]
                                                  .thumbnail
                                              : 'https://www.cirquebijou.co.uk/wp-content/uploads/2016/12/placeholder-female1.jpg'),
                                    ),
                                    borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(15.0),
                                      topRight: const Radius.circular(15.0),
                                      bottomLeft: const Radius.circular(15.0),
                                      bottomRight: const Radius.circular(15.0),
                                    )),
                              ),
                              labelshow
                                  ? Container(
                                      padding:
                                          EdgeInsets.only(bottom: 1, right: 10),
                                      alignment: AlignmentDirectional(1, 1),
                                      child: Chip(
                                        backgroundColor: Colors.green[400],
                                        label: Text(
                                          getSortByChip(i),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ));
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

  void _onRefresh() async {
    print("____________________onRefreshing______________________");
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()

    await fetchCandidateData();
    _refreshController.refreshCompleted();

    // demoListEntry();
    // for change some datatypes of data....
  }

  void _onLoading() async {
    print("____________________onLoading______________________");
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    //await fetchStudentData();
    _refreshController.loadComplete();
  }

  fetchCandidateData() async {
    setState(() {
      processing = true;
      filteredcandidateList.clear();
      candidateList.clear();
    });
    final QuerySnapshot result = await Firestore.instance
        .collection('SAK')
        .where("active", isEqualTo: true)
        .where("gender", isEqualTo: widget.gender)
        .getDocuments();

    final List<DocumentSnapshot> documents = result.documents;

    documents.forEach((data) {
      final record = Record.fromSnapshot(data);
      candidateList.add(record);
      filteredcandidateList.add(record);
    });

    setState(() {
      processing = false;
    });

    filteredcandidateList.sort((a, b) {
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
  }
}

// class viewImage extends StatelessWidget {
//   final DocumentSnapshot data;
//   Record record;
//   int age;

//   viewImage(this.data) {
//     record = Record.fromSnapshot(data);
//     age = Timestamp.now().toDate().year - record.dob.toDate().year;
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton.extended(
//         icon: Icon(Icons.contacts),
//         label: Text("More Info..."),
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => ProfileContactInfo(data)),
//           );
//         },
//       ),
//       backgroundColor: Colors.black12,
//       body: Padding(
//         padding: EdgeInsets.all(30.0),
//         child: Stack(
//           children: <Widget>[
//             Align(
//               alignment: Alignment.center,
//               child: Hero(
//                 tag: "hero",
//                 child: Container(
//                   width: (MediaQuery.of(context).size.width),
//                   child: PhotoView(
//                     imageProvider: CachedNetworkImageProvider(record.photoUrl),
//                   ),
//                 ),
//               ),
//             ),
//             Align(
//               alignment: Alignment.topRight,
//               child: OutlineButton(
//                 onPressed: () => Navigator.of(context).pop(),
//                 child: Icon(
//                   Icons.close,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 1,
//             ),
//             Positioned(
//               bottom: 20.0,
//               left: 10.0,
//               right: 10.0,
//               child: Card(
//                 elevation: 8.0,
//                 color: Colors.black38,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 child: Column(
//                   children: <Widget>[
//                     Padding(
//                       padding: const EdgeInsets.only(
//                           right: 14, left: 14, top: 14, bottom: 3),
//                       child: Text(
//                         record.name.toUpperCase(),
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontFamily: "Roboto",
//                           fontSize: 18.0,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(
//                           right: 14, left: 14, top: 3, bottom: 3),
//                       child: Text(
//                         '( ${record.education.toUpperCase()} )',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontFamily: "Roboto",
//                           fontSize: 18.0,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     Wrap(
//                       children: <Widget>[
//                         Chip(
//                           padding: EdgeInsets.all(10),
//                           label: Text(
//                             'Age : ${age.toString()}',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                           backgroundColor: Colors.red,
//                         ),
//                         Chip(
//                           label: Text(
//                             'Height : ${record.height}',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                           backgroundColor: Colors.orangeAccent,
//                         ),
//                         Chip(
//                           avatar: Icon(
//                             Icons.location_on,
//                             color: Colors.white,
//                           ),
//                           label: Text(
//                             record.birthPlace,
//                             style: TextStyle(color: Colors.white),
//                           ),
//                           backgroundColor: Colors.green,
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 20,
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
class Debouncer {
  final int milliSeconds;
  VoidCallback action;
  Timer _timer;

  Debouncer(this.milliSeconds);

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliSeconds), action);
  }
}
