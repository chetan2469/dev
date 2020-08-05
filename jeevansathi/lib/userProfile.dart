// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:intl/intl.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'constants/firebase_constants.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'dart:io';
// import 'package:image/image.dart' as Im;
// import 'package:path_provider/path_provider.dart';
// import 'dart:math' as Math;

// class UserProfile extends StatefulWidget {
//   static const String routeName = '/contacts';
//   final String email;

//   UserProfile(this.email);

//   @override
//   UserProfileState createState() => UserProfileState();
// }

// enum AppBarBehavior { normal, pinned, floating, snapping }

// class UserProfileState extends State<UserProfile> {
//   final double _appBarHeight = 256.0;

//   FirebaseUser user;

//   final nameFieldController = TextEditingController();

//   final genderFieldController = TextEditingController();

//   static const genderList = <String>['Male ', 'Female', 'Other'];

//   static const horoscopeMatchList = <String>['Yes', 'No', 'Does Not Matter'];

//   static const maritalStatusList = <String>[
//     'Never Married (अविवाहित)',
//     'Widowed (विधवा)',
//     'Divorced (घटस्फोटित)'
//   ];

//   static const UserprofileCreatedByList = <String>[
//     'Myself (मी स्वतः)',
//     'Parent (पालक)',
//     'Uncle ()',
//     'Other ()'
//   ];

//   static const moonShineList = <String>[
//     'Dont Know (माहित नाही)',
//     'Aries (मेष)',
//     'Taurus (वृषभ)',
//     'Gemini (मिथुन)',
//     'Cancer (कर्क)',
//     'Leo (सिंह)',
//     'Virgo (कन्या)',
//     'Scorpio (वृश्चिक)',
//     'Libra (तुला)',
//     'Sagitttarius (धनु)',
//     'Capricorn (मकर)',
//     'Auqarious (कुंभ)',
//     'Pisces (मीन)'
//   ];

//   @override
//   void initState() {
//     super.initState();

//     cFirebaseAuth.currentUser().then(
//           (user) => setState(() {
//             email = user.email;
//           }),
//         );
//   }

//   bool manglic = false;

//   String gender,
//       moonshine = 'Dont Know (माहित नाही)',
//       horoscopeMatch = 'Yes',
//       email;
//   String userprofileCreatedBy, height = '';
//   String name = '',
//       thumbnail,
//       photoUrl,
//       proffesion = '',
//       education = '',
//       maritalStatus = 'Never Married (अविवाहित)',
//       expectations = '',
//       moreInfo = '';
//   DateTime dob, _fromDay = DateTime.now();
//   TimeOfDay _fromTime = const TimeOfDay(hour: 0, minute: 00);
//   String mob1, mob2, birthState, birthPlace, currentRecidential;
//   File _imageFile;

//   bool processing = false;

//   void onClickSave() async {
//     setState(() {
//       processing = true;
//     });
//     dob = new DateTime(_fromDay.year, _fromDay.month, _fromDay.day,
//         _fromTime.hour, _fromTime.minute);

//     if (name != null && mob1 != null && _imageFile != null && gender != null) {
//       uploadFile();
//       pushToFireStore();
//     } else {
//       print('______________________________________');
//     }
//   }

//   Future pushToFireStore() async {
//     await uploadFile();

//     Firestore.instance.collection('SAK').document(email.toString()).updateData({
//       'name': name,
//       'height': height,
//       'gender': gender,
//       'moonshine': moonshine,
//       'horoscopeMatch': horoscopeMatch,
//       'UserprofileCreatedBy': userprofileCreatedBy,
//       'proffesion': proffesion,
//       'education': education,
//       'maritalStatus': maritalStatus,
//       'expectations': expectations,
//       'moreInfo': moreInfo,
//       'mob1': mob1,
//       'mob2': mob2,
//       'birthState': birthState,
//       'birthPlace': birthPlace,
//       'currentRecidential': currentRecidential,
//       'dob': dob,
//       'email': email
//     });
//     print('_________________==================___________________');
//     setState(() {
//       processing = false;
//     });
//     showModal(context);
//   }

//   Future<Uint8List> testCompressFile(File file, int val) async {
//     var result = await FlutterImageCompress.compressWithFile(
//       file.absolute.path,
//       minWidth: val * 8,
//       minHeight: val * 8,
//       quality: 95,
//     );
//     print(file.lengthSync());
//     print(result.length);

//     return result;
//   }

//   Future uploadFile() async {
//     setState(() {
//       processing = true;
//     });
//     print('_________________Uploading...........');
//     if (_imageFile != null) {
//       final tempDir = await getTemporaryDirectory();
//       final path = tempDir.path;
//       int rand = new Math.Random().nextInt(10000);
//       print('___________orignal_________length__________________' +
//           _imageFile.lengthSync().toString());

//       _imageFile = testCompressFile(_imageFile, 400) as File;

//       final StorageReference firebaseStorageRef = FirebaseStorage.instance
//           .ref()
//           .child(name.replaceAll(new RegExp(r"\s+\b|\b\s"), "") +
//               dob.toString().replaceAll(new RegExp(r"\s+\b|\b\s"), "") +
//               '.jpg');
//       StorageUploadTask task = firebaseStorageRef.putFile(_imageFile);

//       var dowurl = await (await task.onComplete).ref.getDownloadURL();
//       photoUrl = dowurl.toString();
//       print('___________photoURL_________length__________________' +
//           _imageFile.lengthSync().toString());

//       Firestore.instance
//           .collection('SAK')
//           .document(email)
//           .updateData({'photoUrl': photoUrl, 'thumbnail': photoUrl});
//     }
//   }

//   Future<Null> _pickImageFromGallery() async {
//     final File imageFile =
//         await ImagePicker.pickImage(source: ImageSource.gallery);
//     setState(() => this._imageFile = imageFile);
//     uploadFile();
//   }

//   Future<Null> _pickImageFromCamera() async {
//     final File imageFile =
//         await ImagePicker.pickImage(source: ImageSource.camera);
//     setState(() => this._imageFile = imageFile);
//     uploadFile();
//   }

//   AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;

//   final List<DropdownMenuItem<String>> _dropDownGender = genderList
//       .map(
//         (String value) => DropdownMenuItem<String>(
//           value: value,
//           child: Text(value),
//         ),
//       )
//       .toList();

//   final List<DropdownMenuItem<String>> _dropDownUserProfileCreatedBy =
//       UserprofileCreatedByList.map(
//     (String value) => DropdownMenuItem<String>(
//       value: value,
//       child: Text(value),
//     ),
//   ).toList();

//   final List<DropdownMenuItem<String>> _dropDownHoroscopeMatch =
//       horoscopeMatchList
//           .map(
//             (String value) => DropdownMenuItem<String>(
//               value: value,
//               child: Text(value),
//             ),
//           )
//           .toList();

//   final List<DropdownMenuItem<String>> _dropDownMaritalStatus =
//       maritalStatusList
//           .map(
//             (String value) => DropdownMenuItem<String>(
//               value: value,
//               child: Text(value),
//             ),
//           )
//           .toList();

//   final List<DropdownMenuItem<String>> _dropDownMoonShine = moonShineList
//       .map(
//         (String value) => DropdownMenuItem<String>(
//           value: value,
//           child: Text(value),
//         ),
//       )
//       .toList();

//   @override
//   Widget build(BuildContext context) {
//     return Theme(
//       data: ThemeData(
//         brightness: Brightness.light,
//         primarySwatch: Colors.pink,
//         platform: Theme.of(context).platform,
//       ),
//       child: Scaffold(
//         body: CustomScrollView(
//           slivers: <Widget>[
//             SliverAppBar(
//               expandedHeight: _appBarHeight,
//               pinned: _appBarBehavior == AppBarBehavior.pinned,
//               floating: _appBarBehavior == AppBarBehavior.floating ||
//                   _appBarBehavior == AppBarBehavior.snapping,
//               snap: _appBarBehavior == AppBarBehavior.snapping,
//               actions: <Widget>[
//                 IconButton(
//                   icon: const Icon(Icons.camera_alt),
//                   tooltip: 'photo',
//                   onPressed: () async {
//                     await _pickImageFromCamera();
//                   },
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.camera),
//                   tooltip: 'select',
//                   onPressed: () async {
//                     await _pickImageFromGallery();
//                   },
//                 ),
//                 RaisedButton(
//                   onPressed: () {
//                     onClickSave();
//                     showModalProcessing(context);
//                   },
//                   child: Text(
//                     'save',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   color: Colors.transparent,
//                 )
//               ],
//               flexibleSpace: FlexibleSpaceBar(
//                 title: Text(name),
//                 background: Stack(
//                   fit: StackFit.expand,
//                   children: <Widget>[
//                     this._imageFile == null
//                         ? Image.network('',
//                             fit: BoxFit.cover, height: _appBarHeight)
//                         : Image.file(
//                             this._imageFile,
//                             fit: BoxFit.cover,
//                             height: _appBarHeight,
//                           ),
//                     const DecoratedBox(
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           begin: Alignment(0.0, -1.0),
//                           end: Alignment(0.0, -0.4),
//                           colors: <Color>[Color(0x60000000), Color(0x00000000)],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SliverList(
//               delegate: SliverChildListDelegate(<Widget>[
//                 AnnotatedRegion<SystemUiOverlayStyle>(
//                   value: SystemUiOverlayStyle.dark,
//                   child: Container(
//                     padding: EdgeInsets.all(10),
//                     margin: EdgeInsets.all(10),
//                     child: Column(
//                       children: <Widget>[
//                         processing ? CircularProgressIndicator() : SizedBox(),
//                         TextField(
//                             onChanged: (String str) {
//                               setState(() {
//                                 name = str;
//                               });
//                             },
//                             decoration: InputDecoration(
//                               border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.only(
//                                 bottomRight: Radius.circular(30),
//                               )),
//                               labelText: 'Name*',
//                             )),
//                         SizedBox(height: 20.0),
//                         TextField(
//                             onChanged: (String str) {
//                               setState(() {
//                                 proffesion = str;
//                               });
//                             },
//                             decoration: InputDecoration(
//                               border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.only(
//                                 bottomRight: Radius.circular(30),
//                               )),
//                               labelText: 'Proffesion*',
//                             )),
//                         SizedBox(height: 20.0),
//                         TextField(
//                             onChanged: (String str) {
//                               setState(() {
//                                 education = str;
//                               });
//                             },
//                             decoration: InputDecoration(
//                               border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.only(
//                                 bottomRight: Radius.circular(30),
//                               )),
//                               labelText: 'Education',
//                             )),
//                         SizedBox(height: 20.0),
//                         TextField(
//                             keyboardType: TextInputType.number,
//                             onChanged: (String str) {
//                               setState(() {
//                                 height = str;
//                               });
//                             },
//                             decoration: InputDecoration(
//                               border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.only(
//                                 bottomRight: Radius.circular(30),
//                               )),
//                               labelText: 'Height in feet',
//                             )),
//                         SizedBox(height: 20.0),
//                         ListTile(
//                           leading: Text("Gender"),
//                           trailing: DropdownButton(
//                             onChanged: ((String str) {
//                               setState(() {
//                                 gender = str;
//                               });
//                             }),
//                             items: _dropDownGender,
//                             value: gender,
//                           ),
//                         ),
//                         ListTile(
//                           leading: Text('Marital Status*'),
//                           trailing: DropdownButton(
//                             onChanged: ((String str) {
//                               setState(() {
//                                 maritalStatus = str;
//                               });
//                             }),
//                             value: maritalStatus,
//                             items: _dropDownMaritalStatus,
//                           ),
//                         ),
//                         _DateTimePicker(
//                           labelText: 'Date Time Of Birth Day*',
//                           selectedDate: _fromDay,
//                           selectedTime: _fromTime,
//                           selectDate: (DateTime date) {
//                             setState(() {
//                               _fromDay = date;
//                             });
//                           },
//                           selectTime: (TimeOfDay time) {
//                             setState(() {
//                               _fromTime = time;
//                               print(time);
//                             });
//                           },
//                         ),
//                         SizedBox(height: 40.0),
//                         TextField(
//                             onChanged: (String str) {
//                               setState(() {
//                                 mob1 = str;
//                               });
//                             },
//                             keyboardType: TextInputType.number,
//                             decoration: InputDecoration(
//                               border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.only(
//                                 bottomRight: Radius.circular(30),
//                               )),
//                               labelText: 'Mobile Number*',
//                             )),
//                         SizedBox(height: 20.0),
//                         TextField(
//                             onChanged: (String str) {
//                               setState(() {
//                                 mob2 = str;
//                               });
//                             },
//                             keyboardType: TextInputType.number,
//                             decoration: InputDecoration(
//                               border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.only(
//                                 bottomRight: Radius.circular(30),
//                               )),
//                               labelText: 'Optional Mobile Number :',
//                             )),
//                         SizedBox(height: 20.0),
//                         TextField(
//                             onChanged: (String str) {
//                               setState(() {
//                                 birthState = str;
//                               });
//                             },
//                             decoration: InputDecoration(
//                               border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.only(
//                                 bottomRight: Radius.circular(30),
//                               )),
//                               labelText: 'Birth State ex : Maharastra*',
//                             )),
//                         SizedBox(height: 20.0),
//                         TextField(
//                             onChanged: (String str) {
//                               setState(() {
//                                 birthPlace = str;
//                               });
//                             },
//                             decoration: InputDecoration(
//                               border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.only(
//                                 bottomRight: Radius.circular(30),
//                               )),
//                               labelText: 'Birth city / district ex: Pune',
//                             )),
//                         SizedBox(height: 20.0),
//                         TextField(
//                             onChanged: (String str) {
//                               setState(() {
//                                 currentRecidential = str;
//                               });
//                             },
//                             decoration: InputDecoration(
//                               border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.only(
//                                 bottomRight: Radius.circular(30),
//                               )),
//                               labelText: 'Current Residential Address:',
//                             )),
//                         SizedBox(height: 40.0),
//                         ListTile(
//                           leading: Text('Horoscope Match'),
//                           trailing: DropdownButton(
//                             value: horoscopeMatch,
//                             hint: Text('Horoscope Match'),
//                             onChanged: ((String newValue) {
//                               setState(() {
//                                 horoscopeMatch = newValue;
//                               });
//                             }),
//                             items: _dropDownHoroscopeMatch,
//                           ),
//                         ),
//                         SizedBox(height: 20.0),
//                         ListTile(
//                           leading: Text("Manglik मंगलिक आहे का?"),
//                           trailing: Switch(
//                             onChanged: (bool value) {
//                               setState(() => this.manglic = value);
//                             },
//                             value: this.manglic,
//                           ),
//                         ),
//                         SizedBox(height: 20.0),
//                         ListTile(
//                           leading: Text('Moonshine'),
//                           trailing: DropdownButton(
//                             value: moonshine,
//                             onChanged: ((String newValue) {
//                               setState(() {
//                                 moonshine = newValue;
//                               });
//                             }),
//                             items: _dropDownMoonShine,
//                           ),
//                         ),
//                         SizedBox(height: 20.0),
//                         ListTile(
//                           leading: Text('UserProfile Created by'),
//                           title: DropdownButton(
//                             value: userprofileCreatedBy,
//                             onChanged: ((String str) {
//                               setState(() {
//                                 userprofileCreatedBy = str;
//                               });
//                             }),
//                             items: _dropDownUserProfileCreatedBy,
//                           ),
//                         ),
//                         SizedBox(height: 20.0),
//                         Container(
//                           child: TextField(
//                               onChanged: (String str) {
//                                 setState(() {
//                                   moreInfo = str;
//                                 });
//                               },
//                               maxLines: 4,
//                               decoration: InputDecoration(
//                                 border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.only(
//                                   bottomRight: Radius.circular(30),
//                                 )),
//                                 labelText: 'More Info About you :',
//                               )),
//                         ),
//                         SizedBox(height: 20.0),
//                         Container(
//                           child: TextField(
//                               onChanged: (String str) {
//                                 setState(() {
//                                   expectations = str;
//                                 });
//                               },
//                               maxLines: 4,
//                               decoration: InputDecoration(
//                                 border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.only(
//                                   bottomRight: Radius.circular(30),
//                                 )),
//                                 labelText: 'Expectations:',
//                               )),
//                         ),
//                         SizedBox(height: 40.0),
//                       ],
//                     ),
//                   ),
//                 ),
//               ]),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void showModal(context) {
//     showModalBottomSheet(
//         context: context,
//         builder: (BuildContext bc) {
//           return Container(
//               child: Container(
//             color: Colors.black,
//             child: Text(
//               "UserProfile Created Successfully !!",
//               style: TextStyle(color: Colors.white),
//             ),
//           ));
//         });
//   }

//   void showModalProcessing(context) {
//     showModalBottomSheet(
//         context: context,
//         builder: (BuildContext bc) {
//           return Container(
//               child: Container(
//             color: Colors.black,
//             child: Text(
//               "UserProfile is Creating Please Wait...",
//               style: TextStyle(color: Colors.white),
//             ),
//           ));
//         });
//   }

//   void showModalProcessingError(context) {
//     showModalBottomSheet(
//         context: context,
//         builder: (BuildContext bc) {
//           return Container(
//               child: Container(
//             color: Colors.black,
//             child: Text(
//               "Please select all Mandatory Details...",
//               style: TextStyle(color: Colors.white),
//             ),
//           ));
//         });
//   }
// }

// class _DateTimePicker extends StatelessWidget {
//   const _DateTimePicker({
//     Key key,
//     this.labelText,
//     this.selectedDate,
//     this.selectedTime,
//     this.selectDate,
//     this.selectTime,
//   }) : super(key: key);

//   final String labelText;
//   final DateTime selectedDate;
//   final TimeOfDay selectedTime;
//   final ValueChanged<DateTime> selectDate;
//   final ValueChanged<TimeOfDay> selectTime;

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       firstDate: DateTime(1960, 1),
//       lastDate: DateTime(2020),
//     );
//     if (picked != null && picked != selectedDate) selectDate(picked);
//   }

//   Future<void> _selectTime(BuildContext context) async {
//     final TimeOfDay picked = await showTimePicker(
//       context: context,
//       initialTime: selectedTime,
//     );
//     if (picked != null && picked != selectedTime) selectTime(picked);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final TextStyle valueStyle = Theme.of(context).textTheme.title;
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: <Widget>[
//         Expanded(
//           flex: 4,
//           child: _InputDropdown(
//             labelText: labelText,
//             valueText: DateFormat.yMMMd().format(selectedDate),
//             valueStyle: valueStyle,
//             onPressed: () {
//               _selectDate(context);
//             },
//           ),
//         ),
//         const SizedBox(width: 12.0),
//         Expanded(
//           flex: 3,
//           child: _InputDropdown(
//             valueText: selectedTime.format(context),
//             valueStyle: valueStyle,
//             onPressed: () {
//               _selectTime(context);
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _InputDropdown extends StatelessWidget {
//   const _InputDropdown({
//     Key key,
//     this.child,
//     this.labelText,
//     this.valueText,
//     this.valueStyle,
//     this.onPressed,
//   }) : super(key: key);

//   final String labelText;
//   final String valueText;
//   final TextStyle valueStyle;
//   final VoidCallback onPressed;
//   final Widget child;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onPressed,
//       child: InputDecorator(
//         decoration: InputDecoration(
//           labelText: labelText,
//         ),
//         baseStyle: valueStyle,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             Text(valueText, style: valueStyle),
//             Icon(
//               Icons.arrow_drop_down,
//               color: Theme.of(context).brightness == Brightness.light
//                   ? Colors.grey.shade700
//                   : Colors.white70,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
