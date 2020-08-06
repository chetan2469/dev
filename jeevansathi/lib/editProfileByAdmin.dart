import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'constants/firebase_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';
import 'dart:math' as Math;
import 'dashboard.dart';
import 'datatype/Record.dart';

class EditProfileByAdmin extends StatefulWidget {
  static const String routeName = '/contacts';
  String documentPath;

  final DocumentSnapshot data;

  int age;

  EditProfileByAdmin(this.data);

  @override
  EditProfileByAdminState createState() => EditProfileByAdminState();
}

enum AppBarBehavior { normal, pinned, floating, snapping }

class EditProfileByAdminState extends State<EditProfileByAdmin> {
  final double _appBarHeight = 256.0;
  FirebaseUser user;

  bool nameValidater = false,
      educationValidater = false,
      proffesionValidater = false,
      heightValidater = false,
      mob1Validater = false,
      birthPlaceValidater = false,
      birthStateValidater = false,
      currentAddressValidater = false;

  final nameFieldController = TextEditingController();
  final proffesionFieldController = TextEditingController();
  final educationFieldController = TextEditingController();
  final heightFieldController = TextEditingController();
  final mob1FieldController = TextEditingController();
  final mob2FieldController = TextEditingController();
  final birthStateFieldController = TextEditingController();
  final birthCityFieldController = TextEditingController();
  final currentAddressFieldController = TextEditingController();

  final infoFieldController = TextEditingController();
  final expectationsFieldController = TextEditingController();

  final genderFieldController = TextEditingController();

  static const genderList = <String>['Male ', 'Female', 'Other'];

  static const horoscopeMatchList = <String>['Yes', 'No', 'Does Not Matter'];

  static const maritalStatusList = <String>[
    'Never Married (अविवाहित)',
    'Widowed (विधवा)',
    'Divorced (घटस्फोटित)'
  ];

  static const EditProfileByAdminCreatedByList = <String>[
    'Myself (मी स्वतः)',
    'Parent (पालक)',
    'Uncle ()',
    'Other ()'
  ];

  static const moonShineList = <String>[
    'Dont Know (माहित नाही)',
    'Aries (मेष)',
    'Taurus (वृषभ)',
    'Gemini (मिथुन)',
    'Cancer (कर्क)',
    'Leo (सिंह)',
    'Virgo (कन्या)',
    'Scorpio (वृश्चिक)',
    'Libra (तुला)',
    'Sagitttarius (धनु)',
    'Capricorn (मकर)',
    'Auqarious (कुंभ)',
    'Pisces (मीन)'
  ];

  Record record;

  @override
  void initState() {
    super.initState();

    record = Record.fromSnapshot(widget.data);

    cFirebaseAuth.currentUser().then(
          (user) => setState(() {
            email = user.email;
          }),
        );

    Firestore.instance
        .document(widget.documentPath)
        .get()
        .then((DocumentSnapshot doc) {
      if (doc.exists) {
        print("${email.toString()}_____FOUND_________${widget.documentPath}");

        setState(() {
          nameValidater = true;
          educationValidater = true;
          proffesionValidater = true;
          heightValidater = true;
          mob1Validater = true;
          birthPlaceValidater = true;
          birthStateValidater = true;
          currentAddressValidater = true;

          nameFieldController.text = record.name;
          proffesionFieldController.text = record.proffesion;
          educationFieldController.text = record.education;
          heightFieldController.text = record.height;
          Timestamp dob = record.dob;

          _fromDay = dob.toDate();
          _fromTime = TimeOfDay.fromDateTime(_fromDay);

          mob1FieldController.text = record.mob1;
          mob2FieldController.text = record.mob1;
          birthCityFieldController.text = record.birthPlace;
          birthStateFieldController.text = record.birthState;
          currentAddressFieldController.text = record.currentRecidential;

          infoFieldController.text = record.moreInfo;
          expectationsFieldController.text = record.expectations;
          //  manglic = doc["manglik"];
          photoUrl = record.photoUrl;
          gender = record.gender;
          proffesionFieldController.text = record.proffesion;
          maritalStatus = record.maritalStatus;
          horoscopeMatch = record.horoscopeMatch;
          active = record.active;
        });
      } else {
        print(
            "${email.toString()}_____NOT FOUND_________${widget.documentPath}");
      }
    });
  }

  bool manglic = false;

  String gender,
      moonshine = 'Dont Know (माहित नाही)',
      horoscopeMatch = 'Yes',
      email;
  bool agreement = false;
  String EditProfileByAdminCreatedBy, height = '';
  String name = '',
      thumbnail,
      photoUrl =
          'https://forwardsummit.ca/wp-content/uploads/2019/01/avatar-default.png',
      proffesion = '',
      education = '',
      maritalStatus = 'Never Married (अविवाहित)',
      expectations = '',
      moreInfo = '';
  DateTime dob, _fromDay = DateTime.now();
  TimeOfDay _fromTime = const TimeOfDay(hour: 0, minute: 00);
  String mob1, mob2, birthState, birthPlace, currentRecidential;
  File _imageFile;
  bool active = false;

  bool processing = false;

  void onClickSave() {
    setState(() {
      processing = true;
    });
    dob = new DateTime(_fromDay.year, _fromDay.month, _fromDay.day,
        _fromTime.hour, _fromTime.minute);

    pushToFireStore();
  }

  Future pushToFireStore() async {
    await uploadFile();
    var rng = new Random();
    Firestore.instance.collection('SAK').document(email.toString()).setData({
      'sakId': 'SAK' +
          nameFieldController.text.substring(0, 2).toUpperCase() +
          rng.nextInt(99).toString() +
          dob.day.toString() +
          (dob.year % 100).toString(),
      'tokenId': '',
      'name': nameFieldController.text.toUpperCase(),
      'height': heightFieldController.text,
      'gender': gender,
      'moonshine': moonshine.toUpperCase(),
      'horoscopeMatch': horoscopeMatch,
      'EditProfileByAdminCreatedBy': EditProfileByAdminCreatedBy,
      'photoUrl': photoUrl,
      'thumbnail': thumbnail,
      'proffesion': proffesionFieldController.text,
      'education': educationFieldController.text,
      'maritalStatus': maritalStatus,
      'expectations': expectationsFieldController.text,
      'moreInfo': infoFieldController.text,
      'mob1': mob1FieldController.text,
      'mob2': mob2FieldController.text,
      'birthState': birthStateFieldController.text.toUpperCase(),
      'birthPlace': birthCityFieldController.text.toUpperCase(),
      'currentRecidential': currentAddressFieldController.text,
      'dob': dob,
      'email': email,
      'thumbnail': thumbnail,
      'active': active
    });
    setState(() {
      processing = false;
      Navigator.pushReplacementNamed(context, '/dashboard');
    });
    showModal(context);
  }

  Future uploadFile() async {
    setState(() {
      processing = true;
    });
    if (_imageFile != null) {
      final tempDir = await getTemporaryDirectory();
      final path = tempDir.path;
      int rand = new Math.Random().nextInt(10000);
      print('____________________length');
      print(_imageFile.lengthSync());

      Im.Image image = Im.decodeImage(_imageFile.readAsBytesSync());
      // choose the size here, it will maintain aspect ratio

      if (_imageFile.lengthSync() > 3000000) {
        _imageFile = new File('$path/img_$rand.jpg')
          ..writeAsBytesSync(Im.encodeJpg(image, quality: 10));
      } else if (_imageFile.lengthSync() > 2000000) {
        _imageFile = new File('$path/img_$rand.jpg')
          ..writeAsBytesSync(Im.encodeJpg(image, quality: 15));
      } else if (_imageFile.lengthSync() > 1500000) {
        _imageFile = new File('$path/img_$rand.jpg')
          ..writeAsBytesSync(Im.encodeJpg(image, quality: 17));
      } else if (_imageFile.lengthSync() > 1000000) {
        _imageFile = new File('$path/img_$rand.jpg')
          ..writeAsBytesSync(Im.encodeJpg(image, quality: 20));
      } else if (_imageFile.lengthSync() > 500000) {
        _imageFile = new File('$path/img_$rand.jpg')
          ..writeAsBytesSync(Im.encodeJpg(image, quality: 22));
      } else {
        _imageFile = new File('$path/img_$rand.jpg')
          ..writeAsBytesSync(Im.encodeJpg(image, quality: 23));
      }

      final StorageReference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child(name.replaceAll(new RegExp(r"\s+\b|\b\s"), "") +
              dob.toString().replaceAll(new RegExp(r"\s+\b|\b\s"), "") +
              '.jpg');
      StorageUploadTask task = firebaseStorageRef.putFile(_imageFile);

      var dowurl = await (await task.onComplete).ref.getDownloadURL();
      photoUrl = dowurl.toString();
      await compressImage();
    }
  }

  Future compressImage() async {
    File imageFile = _imageFile;
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = new Math.Random().nextInt(10000);

    Im.Image image = Im.decodeImage(_imageFile.readAsBytesSync());
    Im.Image smallerImage = Im.gaussianBlur(Im.copyResize(image), 1);

    imageFile = new File('$path/img_$rand.jpg')
      ..writeAsBytesSync(Im.encodeJpg(smallerImage, quality: 80));
    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child(name.replaceAll(new RegExp(r"\s+\b|\b\s"), "") +
            dob.toString().replaceAll(new RegExp(r"\s+\b|\b\s"), "") +
            'thumbnail.jpg');
    StorageUploadTask task = firebaseStorageRef.putFile(imageFile);

    var dowurl = await (await task.onComplete).ref.getDownloadURL();
    thumbnail = dowurl.toString();
  }

  Future<Null> _pickImageFromGallery() async {
    final File imageFile =
        await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() => this._imageFile = imageFile);
  }

  Future<Null> _pickImageFromCamera() async {
    final File imageFile =
        await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() => this._imageFile = imageFile);
  }

  AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;

  final List<DropdownMenuItem<String>> _dropDownGender = genderList
      .map(
        (String value) => DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      )
      .toList();

  final List<DropdownMenuItem<String>> _dropDownEditProfileByAdminCreatedBy =
      EditProfileByAdminCreatedByList.map(
    (String value) => DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    ),
  ).toList();

  final List<DropdownMenuItem<String>> _dropDownHoroscopeMatch =
      horoscopeMatchList
          .map(
            (String value) => DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            ),
          )
          .toList();

  final List<DropdownMenuItem<String>> _dropDownMaritalStatus =
      maritalStatusList
          .map(
            (String value) => DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            ),
          )
          .toList();

  final List<DropdownMenuItem<String>> _dropDownMoonShine = moonShineList
      .map(
        (String value) => DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.pink,
        platform: Theme.of(context).platform,
      ),
      child: WillPopScope(
        onWillPop: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => Dashboard()));
        },
        child: Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: _appBarHeight,
                pinned: _appBarBehavior == AppBarBehavior.pinned,
                floating: _appBarBehavior == AppBarBehavior.floating ||
                    _appBarBehavior == AppBarBehavior.snapping,
                snap: _appBarBehavior == AppBarBehavior.snapping,
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
                    tooltip: 'photo',
                    onPressed: () async => await _pickImageFromCamera(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.camera),
                    tooltip: 'select',
                    onPressed: () async => await _pickImageFromGallery(),
                  ),
                  RaisedButton(
                    onPressed: () {
                      if (nameValidater &&
                          educationValidater &&
                          proffesionValidater &&
                          heightValidater &&
                          mob1Validater &&
                          birthStateValidater &&
                          birthPlaceValidater &&
                          currentAddressValidater &&
                          agreement) {
                        onClickSave();
                        showModalProcessing(context);
                      } else {
                        showModalProcessingError(context);
                      }
                    },
                    child: Text(
                      'save',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.transparent,
                  )
                ],
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(name),
                  background: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      this._imageFile == null
                          ? Image.network(photoUrl,
                              fit: BoxFit.cover, height: _appBarHeight)
                          : Image.file(
                              this._imageFile,
                              fit: BoxFit.cover,
                              height: _appBarHeight,
                            ),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(0.0, -1.0),
                            end: Alignment(0.0, -0.4),
                            colors: <Color>[
                              Color(0x60000000),
                              Color(0x00000000)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(<Widget>[
                  AnnotatedRegion<SystemUiOverlayStyle>(
                    value: SystemUiOverlayStyle.dark,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          processing ? CircularProgressIndicator() : SizedBox(),
                          TextField(
                              controller: nameFieldController,
                              onChanged: (String str) {
                                setState(() {
                                  name = str;
                                  if (str.length == 0) {
                                    setState(() {
                                      nameValidater = false;
                                    });
                                  } else {
                                    setState(() {
                                      nameValidater = true;
                                    });
                                  }
                                });
                              },
                              decoration: InputDecoration(
                                errorText: !nameValidater
                                    ? 'Insert Your Good Name'
                                    : null,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(30),
                                )),
                                labelText: 'Name*',
                              )),
                          SizedBox(height: 20.0),
                          TextField(
                              controller: proffesionFieldController,
                              onChanged: (String str) {
                                setState(() {
                                  proffesion = str;
                                });
                                if (str.length == 0) {
                                  setState(() {
                                    proffesionValidater = false;
                                  });
                                } else {
                                  setState(() {
                                    proffesionValidater = true;
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                errorText: !proffesionValidater
                                    ? 'Insert Your Proffesion'
                                    : null,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(30),
                                )),
                                labelText: 'Proffesion*',
                              )),
                          SizedBox(height: 20.0),
                          TextField(
                              controller: educationFieldController,
                              onChanged: (String str) {
                                setState(() {
                                  education = str;
                                });

                                if (str.length == 0) {
                                  setState(() {
                                    educationValidater = false;
                                  });
                                } else {
                                  setState(() {
                                    educationValidater = true;
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                errorText: !educationValidater
                                    ? 'Insert Your Education'
                                    : null,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(30),
                                )),
                                labelText: 'Education',
                              )),
                          SizedBox(height: 20.0),
                          TextField(
                              controller: heightFieldController,
                              keyboardType: TextInputType.number,
                              onChanged: (String str) {
                                setState(() {
                                  height = str;
                                });
                                if (str.length == 0) {
                                  setState(() {
                                    heightValidater = false;
                                  });
                                } else {
                                  setState(() {
                                    heightValidater = true;
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                errorText: !heightValidater
                                    ? 'Insert Your Height'
                                    : null,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(30),
                                )),
                                labelText: 'Height in feet',
                              )),
                          SizedBox(height: 20.0),
                          ListTile(
                            leading: Text("Gender"),
                            trailing: DropdownButton(
                              onChanged: ((String str) {
                                setState(() {
                                  gender = str;
                                });
                              }),
                              items: _dropDownGender,
                              value: gender,
                            ),
                          ),
                          ListTile(
                            leading: Text('Marital Status*'),
                            trailing: DropdownButton(
                              onChanged: ((String str) {
                                setState(() {
                                  maritalStatus = str;
                                });
                              }),
                              value: maritalStatus,
                              items: _dropDownMaritalStatus,
                            ),
                          ),
                          _DateTimePicker(
                            labelText: 'Date Time Of Birth Day*',
                            selectedDate: _fromDay,
                            selectedTime: _fromTime,
                            selectDate: (DateTime date) {
                              setState(() {
                                _fromDay = date;
                              });
                            },
                            selectTime: (TimeOfDay time) {
                              setState(() {
                                _fromTime = time;
                                print(time);
                              });
                            },
                          ),
                          SizedBox(height: 40.0),
                          TextField(
                              controller: mob1FieldController,
                              onChanged: (String str) {
                                setState(() {
                                  mob1 = str;
                                  if (str.length == 0) {
                                    setState(() {
                                      mob1Validater = false;
                                    });
                                  } else {
                                    setState(() {
                                      mob1Validater = true;
                                    });
                                  }
                                });
                              },
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                errorText: !mob1Validater
                                    ? 'Insert Your Mobile Number to Contact'
                                    : null,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(30),
                                )),
                                labelText: 'Mobile Number*',
                              )),
                          SizedBox(height: 20.0),
                          TextField(
                              controller: mob2FieldController,
                              onChanged: (String str) {
                                setState(() {
                                  mob2 = str;
                                });
                              },
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(30),
                                )),
                                labelText: 'Optional Mobile Number :',
                              )),
                          SizedBox(height: 20.0),
                          TextField(
                              controller: birthStateFieldController,
                              onChanged: (String str) {
                                setState(() {
                                  birthState = str;
                                  if (str.length == 0) {
                                    setState(() {
                                      birthStateValidater = false;
                                    });
                                  } else {
                                    setState(() {
                                      birthStateValidater = true;
                                    });
                                  }
                                });
                              },
                              decoration: InputDecoration(
                                errorText: !birthStateValidater
                                    ? 'Insert Your Birth State'
                                    : null,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(30),
                                )),
                                labelText: 'Birth State ex : Maharastra*',
                              )),
                          SizedBox(height: 20.0),
                          TextField(
                              controller: birthCityFieldController,
                              onChanged: (String str) {
                                setState(() {
                                  birthPlace = str;
                                  if (str.length == 0) {
                                    setState(() {
                                      birthPlaceValidater = false;
                                    });
                                  } else {
                                    setState(() {
                                      birthPlaceValidater = true;
                                    });
                                  }
                                });
                              },
                              decoration: InputDecoration(
                                errorText: !birthPlaceValidater
                                    ? 'Insert Your Birth City or Villege'
                                    : null,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(30),
                                )),
                                labelText: 'Birth city / district ex: Pune',
                              )),
                          SizedBox(height: 20.0),
                          TextField(
                              controller: currentAddressFieldController,
                              onChanged: (String str) {
                                setState(() {
                                  currentRecidential = str;
                                  if (str.length == 0) {
                                    setState(() {
                                      currentAddressValidater = false;
                                    });
                                  } else {
                                    setState(() {
                                      currentAddressValidater = true;
                                    });
                                  }
                                });
                              },
                              decoration: InputDecoration(
                                errorText: !currentAddressValidater
                                    ? 'Insert Your Current Residential Address'
                                    : null,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(30),
                                )),
                                labelText: 'Current Residential Address:',
                              )),
                          SizedBox(height: 40.0),
                          ListTile(
                            leading: Text('Horoscope Match'),
                            trailing: DropdownButton(
                              value: horoscopeMatch,
                              hint: Text('Horoscope Match'),
                              onChanged: ((String newValue) {
                                setState(() {
                                  horoscopeMatch = newValue;
                                });
                              }),
                              items: _dropDownHoroscopeMatch,
                            ),
                          ),
                          SizedBox(height: 20.0),
                          ListTile(
                            leading: Text("Manglik मंगलिक आहे का?"),
                            trailing: Switch(
                              onChanged: (bool value) {
                                setState(() => this.manglic = value);
                              },
                              value: this.manglic,
                            ),
                          ),
                          SizedBox(height: 20.0),
                          ListTile(
                            leading: Text('Moonshine (रास )'),
                            trailing: DropdownButton(
                              value: moonshine,
                              onChanged: ((String newValue) {
                                setState(() {
                                  moonshine = newValue;
                                });
                              }),
                              items: _dropDownMoonShine,
                            ),
                          ),
                          SizedBox(height: 20.0),
                          ListTile(
                            leading: Text('EditProfileByAdmin Created by'),
                            title: DropdownButton(
                              value: EditProfileByAdminCreatedBy,
                              onChanged: ((String str) {
                                setState(() {
                                  EditProfileByAdminCreatedBy = str;
                                });
                              }),
                              items: _dropDownEditProfileByAdminCreatedBy,
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            child: TextField(
                                controller: infoFieldController,
                                onChanged: (String str) {
                                  setState(() {
                                    moreInfo = str;
                                  });
                                },
                                maxLines: 4,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(30),
                                  )),
                                  labelText:
                                      'Relatives Info  (तुमचे  जवळचे  नातेवाईक त्यांचा मोबाइलला नंबर ) :',
                                )),
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            child: TextField(
                                controller: expectationsFieldController,
                                onChanged: (String str) {
                                  setState(() {
                                    expectations = str;
                                  });
                                },
                                maxLines: 4,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(30),
                                  )),
                                  labelText: 'Expectations (तुमची अपेक्षा ):',
                                )),
                          ),
                          SizedBox(height: 20.0),
                          Wrap(
                            children: <Widget>[
                              Checkbox(
                                value: agreement,
                                onChanged: (bool value) {
                                  setState(() {
                                    agreement = value;
                                  });
                                },
                              ),
                              Text(
                                  "   I Allow to Publish information filled by me, if someone missuse this information then only i am responsible for that.  \n   आम्ही आमच्या मर्जीने माहिती देत आहोत , कोणी हेतुपूर्ण या माहितीचा चुकीचा वापर केला तर याला जबाबदार आम्हीच असणार आहोत. \n    हम अपनी मर्जीसे जानकारी दे रहे है , अगर कोई दिए गए जानकारी का गलत वापर करता है तो इसके लिए हम जिम्मेदार है !!")
                            ],
                          ),
                          SizedBox(height: 20.0),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showModal(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
              child: Container(
            color: Colors.black,
            child: Text(
              "EditProfileByAdmin Updated Successfully !! Will be available within 24 hours...",
              style: TextStyle(color: Colors.white),
            ),
          ));
        });
  }

  void showModalProcessing(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
              child: Container(
            color: Colors.black,
            child: Text(
              "EditProfileByAdmin is Updating Please Wait...",
              style: TextStyle(color: Colors.white),
            ),
          ));
        });
  }

  void showModalProcessingError(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
              child: Container(
            color: Colors.black,
            child: Text(
              "Please select all Mandatory Details... ",
              style: TextStyle(color: Colors.white),
            ),
          ));
        });
  }

  void showModalAgeError(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
              child: Container(
            color: Colors.black,
            child: Text(
              "वय १८ पेक्षा जास्त हवे. / Age should be 18+",
              style: TextStyle(color: Colors.white),
            ),
          ));
        });
  }
}

class _DateTimePicker extends StatelessWidget {
  const _DateTimePicker({
    Key key,
    this.labelText,
    this.selectedDate,
    this.selectedTime,
    this.selectDate,
    this.selectTime,
  }) : super(key: key);

  final String labelText;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final ValueChanged<DateTime> selectDate;
  final ValueChanged<TimeOfDay> selectTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1960, 1),
      lastDate: DateTime(2020),
    );
    if (picked != null && picked != selectedDate) selectDate(picked);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) selectTime(picked);
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.title;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          flex: 4,
          child: _InputDropdown(
            labelText: labelText,
            valueText: DateFormat.yMMMd().format(selectedDate),
            valueStyle: valueStyle,
            onPressed: () {
              _selectDate(context);
            },
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          flex: 3,
          child: _InputDropdown(
            valueText: selectedTime.format(context),
            valueStyle: valueStyle,
            onPressed: () {
              _selectTime(context);
            },
          ),
        ),
      ],
    );
  }
}

class _InputDropdown extends StatelessWidget {
  const _InputDropdown({
    Key key,
    this.child,
    this.labelText,
    this.valueText,
    this.valueStyle,
    this.onPressed,
  }) : super(key: key);

  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
        ),
        baseStyle: valueStyle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(valueText, style: valueStyle),
            Icon(
              Icons.arrow_drop_down,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey.shade700
                  : Colors.white70,
            ),
          ],
        ),
      ),
    );
  }
}
