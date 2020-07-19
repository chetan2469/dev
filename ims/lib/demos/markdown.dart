import 'package:flutter/material.dart';

class MarkdownDemo extends StatefulWidget {
  @override
  _MarkdownDemoState createState() => _MarkdownDemoState();
}

class _MarkdownDemoState extends State<MarkdownDemo> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

/*


Container(
                    margin: EdgeInsets.all(10),
                    height: 40,
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (String searchKey) {
                        debouncer.run(() {
                          setState(() {
                            searchStr = searchKey;

                            filteredStudentList = studentList
                                .where((str) => (str.name
                                        .toLowerCase()
                                        .contains(searchKey.toLowerCase()) ||
                                    str.pursuing_course
                                        .toLowerCase()
                                        .contains(searchKey.toLowerCase())))
                                .toList();
                          });
                        });
                      },
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          fillColor: Colors.white10,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35),
                          ),
                          prefixIcon: Icon(Icons.search, color: Colors.white),
                          hintText: "Search text...",
                          hintStyle: TextStyle(color: Colors.white)),
                    ),
                  )

*/
