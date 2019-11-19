import 'dart:async';
import 'dart:io';
import 'dart:math' as Math;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ims/constants/constants.dart';
import 'package:ims/data/course_record.dart';
import 'package:ims/data/record.dart';
import 'package:ims/data/studentCourseEntry.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Receipt extends StatefulWidget {
  @override
  _ReceiptState createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  List<StudentCourseEntry> courseRecordList = List();
  bool processing = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: RaisedButton(
          child: Text('Load Data'),
          onPressed: () {
             fetchStudentCourseData();
            // fetchStudentData();
          },
        ),
      ),
    );
  }

  fetchStudentCourseData() async {
    setState(() {
      processing = true;
      courseRecordList.clear();
    });
    final QuerySnapshot result =
        await Firestore.instance.collection('student_course').getDocuments();

    final List<DocumentSnapshot> documents = result.documents;
    documents.forEach((data) {
      final record = StudentCourseEntry.fromSnapshot(data);
      courseRecordList.add(record);
    print("_____________________________"+record.receiptList.length.toString());


    for (var i = 0; i < record.receiptList.length; i++) {
      print(i.toString()+' '+record.receiptList[i].toString());
    }

    });

    setState(() {
      processing = false;
    });
  }
}

// class Receipt extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return DemoScreen();
//   }
// }

// class DemoScreen extends StatefulWidget {
//   @override
//   _DemoScreenState createState() => _DemoScreenState();
// }

// class _DemoScreenState extends State<DemoScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Material Chips Input'),
//         ),
//         body: Container(
//           margin: EdgeInsets.all(20),
//           child: ChipsInput<Course>(
//             decoration: InputDecoration(
//                 contentPadding: EdgeInsets.all(1),
//                 border:
//                     OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
//                 prefixIcon: Icon(Icons.search),
//                 hintText: 'Add Course'),
//             findSuggestions: _findSuggestions,
//             onChanged: _onChanged,
//             chipBuilder: (BuildContext context, ChipsInputState<Course> state,
//                 Course course) {
//               return InputChip(
//                 key: ObjectKey(course),
//                 label: RichText(
//                   text: TextSpan(children: [
//                     TextSpan(
//                         text: "  "+course.name+" ",
//                         style: TextStyle(backgroundColor: Colors.red,fontSize: 20)),
//                     TextSpan(
//                         text: DateFormat('dd-mm-yy').format(course.startDate),
//                         style: TextStyle(backgroundColor: Colors.grey)),
//                   ]),
//                 ),
//                 onDeleted: () => state.deleteChip(course),
//                 onSelected: (_) => _onChipTapped(course),
//                 materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//               );
//             },
//             suggestionBuilder: (BuildContext context,
//                 ChipsInputState<Course> state, Course course) {
//               return ListTile(
//                 key: ObjectKey(course),
//                 title: Text(course.name),
//                 onTap: () => state.selectSuggestion(course),
//               );
//             },
//           ),
//         ));
//   }

//   void _onChipTapped(Course course) {
//     print('$course');
//   }

//   void _onChanged(List<Course> data) {
//     print('onChanged $data');
//   }

//   Future<List<Course>> _findSuggestions(String query) async {
//     if (query.length != 0) {
//       return mockResults.where((course) {
//         return course.name.contains(query);
//       }).toList(growable: false);
//     } else {
//       return const <Course>[];
//     }
//   }
// }

// // -------------------------------------------------

// // -------------------------------------------------

// typedef ChipsInputSuggestions<T> = Future<List<T>> Function(String query);
// typedef ChipSelected<T> = void Function(T data, bool selected);
// typedef ChipsBuilder<T> = Widget Function(
//     BuildContext context, ChipsInputState<T> state, T data);

// class ChipsInput<T> extends StatefulWidget {
//   const ChipsInput({
//     Key key,
//     this.decoration = const InputDecoration(),
//     @required this.chipBuilder,
//     @required this.suggestionBuilder,
//     @required this.findSuggestions,
//     @required this.onChanged,
//     this.onChipTapped,
//   }) : super(key: key);

//   final InputDecoration decoration;
//   final ChipsInputSuggestions findSuggestions;
//   final ValueChanged<List<T>> onChanged;
//   final ValueChanged<T> onChipTapped;
//   final ChipsBuilder<T> chipBuilder;
//   final ChipsBuilder<T> suggestionBuilder;

//   @override
//   ChipsInputState<T> createState() => ChipsInputState<T>();
// }

// class ChipsInputState<T> extends State<ChipsInput<T>>
//     implements TextInputClient {
//   static const kObjectReplacementChar = 0xFFFC;

//   Set<T> _chips = Set<T>();
//   List<T> _suggestions;
//   int _searchId = 0;

//   FocusNode _focusNode;
//   TextEditingValue _value = TextEditingValue();
//   TextInputConnection _connection;

//   String get text => String.fromCharCodes(
//         _value.text.codeUnits.where((ch) => ch != kObjectReplacementChar),
//       );

//   bool get _hasInputConnection => _connection != null && _connection.attached;

//   void requestKeyboard() {
//     if (_focusNode.hasFocus) {
//       _openInputConnection();
//     } else {
//       FocusScope.of(context).requestFocus(_focusNode);
//     }
//   }

//   void selectSuggestion(T data) {
//     setState(() {
//       _chips.add(data);
//       _updateTextInputState();
//       _suggestions = null;
//     });
//     widget.onChanged(_chips.toList(growable: false));
//   }

//   void deleteChip(T data) {
//     setState(() {
//       _chips.remove(data);
//       _updateTextInputState();
//     });
//     widget.onChanged(_chips.toList(growable: false));
//   }

//   @override
//   void initState() {
//     super.initState();
//     _focusNode = FocusNode();
//     _focusNode.addListener(_onFocusChanged);
//   }

//   void _onFocusChanged() {
//     if (_focusNode.hasFocus) {
//       _openInputConnection();
//     } else {
//       _closeInputConnectionIfNeeded();
//     }
//     setState(() {
//       // rebuild so that _TextCursor is hidden.
//     });
//   }

//   @override
//   void dispose() {
//     _focusNode?.dispose();
//     _closeInputConnectionIfNeeded();
//     super.dispose();
//   }

//   void _openInputConnection() {
//     if (!_hasInputConnection) {
//       _connection = TextInput.attach(this, TextInputConfiguration());
//       _connection.setEditingState(_value);
//     }
//     _connection.show();
//   }

//   void _closeInputConnectionIfNeeded() {
//     if (_hasInputConnection) {
//       _connection.close();
//       _connection = null;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     var chipsChildren = _chips
//         .map<Widget>(
//           (data) => widget.chipBuilder(context, this, data),
//         )
//         .toList();

//     final theme = Theme.of(context);

//     chipsChildren.add(
//       Container(
//         height: 32.0,
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             Text(
//               text,
//               style: theme.textTheme.subhead.copyWith(
//                 height: 1.5,
//               ),
//             ),
//             _TextCaret(
//               resumed: _focusNode.hasFocus,
//             ),
//           ],
//         ),
//       ),
//     );

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       //mainAxisSize: MainAxisSize.min,
//       children: <Widget>[
//         GestureDetector(
//           behavior: HitTestBehavior.opaque,
//           onTap: requestKeyboard,
//           child: InputDecorator(
//             decoration: widget.decoration,
//             isFocused: _focusNode.hasFocus,
//             isEmpty: _value.text.length == 0,
//             child: Wrap(
//               children: chipsChildren,
//               spacing: 4.0,
//               runSpacing: 4.0,
//             ),
//           ),
//         ),
//         Expanded(
//           child: ListView.builder(
//             itemCount: _suggestions?.length ?? 0,
//             itemBuilder: (BuildContext context, int index) {
//               return widget.suggestionBuilder(
//                   context, this, _suggestions[index]);
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   void updateEditingValue(TextEditingValue value) {
//     final oldCount = _countReplacements(_value);
//     final newCount = _countReplacements(value);
//     setState(() {
//       if (newCount < oldCount) {
//         _chips = Set.from(_chips.take(newCount));
//       }
//       _value = value;
//     });
//     _onSearchChanged(text);
//   }

//   int _countReplacements(TextEditingValue value) {
//     return value.text.codeUnits
//         .where((ch) => ch == kObjectReplacementChar)
//         .length;
//   }

//   @override
//   void performAction(TextInputAction action) {
//     _focusNode.unfocus();
//   }

//   void _updateTextInputState() {
//     final text =
//         String.fromCharCodes(_chips.map((_) => kObjectReplacementChar));
//     _value = TextEditingValue(
//       text: text,
//       selection: TextSelection.collapsed(offset: text.length),
//       composing: TextRange(start: 0, end: text.length),
//     );
//     _connection.setEditingState(_value);
//   }

//   void _onSearchChanged(String value) async {
//     final localId = ++_searchId;
//     final results = await widget.findSuggestions(value);
//     if (_searchId == localId && mounted) {
//       setState(() => _suggestions = results
//           .where((course) => !_chips.contains(course))
//           .toList(growable: false));
//     }
//   }

//   @override
//   void updateFloatingCursor(RawFloatingCursorPoint point) {
//     // TODO: implement updateFloatingCursor
//   }
// }

// class _TextCaret extends StatefulWidget {
//   const _TextCaret({
//     Key key,
//     this.duration = const Duration(milliseconds: 500),
//     this.resumed = false,
//   }) : super(key: key);

//   final Duration duration;
//   final bool resumed;

//   @override
//   _TextCursorState createState() => _TextCursorState();
// }

// class _TextCursorState extends State<_TextCaret>
//     with SingleTickerProviderStateMixin {
//   bool _displayed = false;
//   Timer _timer;

//   @override
//   void initState() {
//     super.initState();
//     _timer = Timer.periodic(widget.duration, _onTimer);
//   }

//   void _onTimer(Timer timer) {
//     setState(() => _displayed = !_displayed);
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return FractionallySizedBox(
//       heightFactor: 0.7,
//       child: Opacity(
//         opacity: _displayed && widget.resumed ? 1.0 : 0.0,
//         child: Container(
//           width: 2.0,
//           color: theme.primaryColor,
//         ),
//       ),
//     );
//   }
// }

// String today = DateTime.now().toString();

// var mockResults = <Course>[
//   Course('C', DateTime.now()),
//   Course('DSA', DateTime.now()),
//   Course('C++', DateTime.now()),
//   Course('Java', DateTime.now()),
//   Course('Flutter', DateTime.now()),
//   Course('Python', DateTime.now()),
// ];

// class Course {
//   final String name;
//   final DateTime startDate;
//   const Course(this.name, this.startDate);

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is Course && runtimeType == other.runtimeType && name == other.name;

//   @override
//   int get hashCode => name.hashCode;

//   @override
//   String toString() {
//     return 'course{$name}';
//   }
// }
