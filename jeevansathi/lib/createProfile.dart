import 'dart:ffi';
import 'dart:math';
import 'dart:typed_data';

import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'constants/firebase_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';
import 'dart:math' as Math;

import 'login.dart';

class CreateProfile extends StatefulWidget {
  static const String routeName = '/contacts';
  String documentPath;
  final String email;
  CreateProfile(this.email) {
    documentPath = '/SAK/${email.toString()}';
  }

  @override
  CreateProfileState createState() => CreateProfileState();
}

enum AppBarBehavior { normal, pinned, floating, snapping }

class CreateProfileState extends State<CreateProfile> {
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

  static const genderList = <String>['Male', 'Female', 'Other'];

  static const horoscopeMatchList = <String>['Yes', 'No', 'Does Not Matter'];

  static const maritalStatusList = <String>[
    'Never Married (अविवाहित)',
    'Widowed (विधवा)',
    'Divorced (घटस्फोटित)'
  ];

  static const CreateProfileCreatedByList = <String>[
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

  @override
  void initState() {
    super.initState();

    cFirebaseAuth.currentUser().then(
          (user) => setState(() {
            email = user.email;
          }),
        );
  }

  bool manglic = false;

  String gender = 'Male',
      moonshine = 'Dont Know (माहित नाही)',
      horoscopeMatch = 'Yes',
      email;
  bool agreement = false;
  String CreateProfileCreatedBy, height = '';
  String name = '',
      thumbnail = '',
      photoUrl = ''
          'https://forwardsummit.ca/wp-content/uploads/2019/01/avatar-default.png',
      proffesion = '',
      education = '',
      maritalStatus = 'Never Married (अविवाहित)',
      expectations = '',
      moreInfo = '';
  DateTime dob;
  Timestamp _fromDay = Timestamp.fromDate(DateTime(2000));
  TimeOfDay _fromTime = const TimeOfDay(hour: 0, minute: 00);
  String mob1, mob2, birthState, birthPlace, currentRecidential;
  File _imageFile;
  bool active = false;

  bool processing = false, imageProcessing = false;

  void onClickSave() {
    if (_imageFile != null && photoUrl.length > 10 && thumbnail.length > 10) {
      setState(() {
        processing = true;
      });
      pushToFireStore();
    } else {
      showModal(context, "Please upload your Photo...");
    }
  }

  Future pushToFireStore() async {
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
      'moonshine': moonshine,
      'horoscopeMatch': horoscopeMatch,
      'CreateProfileCreatedBy': CreateProfileCreatedBy,
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
      'active': active,
      'selfDestroyed': false,
      'entryDate': DateTime.now()
    });
    setState(() {
      processing = false;
      //Navigator.pop(context);
    });
    showSucessModal(context,
        "CreateProfile Updated Successfully !! Will be available within 24 hours...");
  }

  Future uploadFile() async {
    setState(() {
      imageProcessing = true;
    });
    print('_________________Uploading...........');
    if (_imageFile != null) {
      final tempDir = await getTemporaryDirectory();
      final path = tempDir.path;
      int rand = new Math.Random().nextInt(10000);
      print('___________orignal_________length__________________' +
          _imageFile.lengthSync().toString());

      final StorageReference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child(name.replaceAll(new RegExp(r"\s+\b|\b\s"), "") +
              widget.email.replaceAll(new RegExp(r"\s+\b|\b\s"), "") +
              '.jpg');
      print('___________rename_________file__________________' +
          _imageFile.lengthSync().toString());
      StorageUploadTask task = firebaseStorageRef.putFile(_imageFile);

      var dowurl = await (await task.onComplete).ref.getDownloadURL();
      setState(() {
        photoUrl = dowurl.toString();
      });
      print('___________photoURL_________length__________________' +
          _imageFile.lengthSync().toString());

      compressImage();
    }
  }

  Future compressImage() async {
    File imageFile;
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = new Math.Random().nextInt(10000);
    print('___________photo____is_____compressing__________________');
    setState(() {
      imageFile = _imageFile;
    });

    Im.Image image = Im.decodeImage(_imageFile.readAsBytesSync());

    imageFile = new File('$path/img_$rand.jpg')
      ..writeAsBytesSync(Im.encodeJpg(image, quality: 20));

    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child(name.replaceAll(new RegExp(r"\s+\b|\b\s"), "") +
            widget.email.replaceAll(new RegExp(r"\s+\b|\b\s"), "") +
            'thumbnail.jpg');

    StorageUploadTask task = firebaseStorageRef.putFile(imageFile);

    var dowurl = await (await task.onComplete).ref.getDownloadURL();
    setState(() {
      thumbnail = dowurl.toString();
    });
    print('___________thumbnail URL SIZE ___________  ' +
        imageFile.lengthSync().toString());

    setState(() {
      imageProcessing = false;
    });
    print(photoUrl);
    print(thumbnail);
  }

  void getImageFile(ImageSource source) async {
    //Clicking or Picking from Gallery

    var image = await ImagePicker.pickImage(source: source);
    //Cropping the image

    File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      maxWidth: 512,
      maxHeight: 512,
    );

    //Compress the image

    var result = await FlutterImageCompress.compressAndGetFile(
      croppedFile.path,
      image.path,
      quality: 80,
    );

    setState(() {
      _imageFile = result;
      print(_imageFile.lengthSync());
    });
    uploadFile();
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

  final List<DropdownMenuItem<String>> _dropDownCreateProfileCreatedBy =
      CreateProfileCreatedByList.map(
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
        primarySwatch: Colors.lightGreen,
        platform: Theme.of(context).platform,
      ),
      child: Scaffold(
        body: DelayedDisplay(
          delay: Duration(seconds: 1),
          child: CustomScrollView(
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
                    onPressed: () async => getImageFile(ImageSource.camera),
                  ),
                  IconButton(
                    icon: const Icon(Icons.camera),
                    tooltip: 'select',
                    onPressed: () async => getImageFile(ImageSource.gallery),
                  ),
                  RaisedButton(
                    onPressed: () {
                      if (imageProcessing) {
                        showModal(context, 'Image is uploading please wait...');
                      } else {
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
                        } else {
                          showModal(context, 'please fill your all  details');
                        }
                      }
                    },
                    child: Text(
                      'saves',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.transparent,
                  )
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      imageProcessing
                          ? Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                              ),
                            )
                          : this._imageFile == null
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
                                    borderRadius: BorderRadius.circular(0)),
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
                                    borderRadius: BorderRadius.circular(0)),
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
                                    borderRadius: BorderRadius.circular(0)),
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
                                    borderRadius: BorderRadius.circular(0)),
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
                            selectedDate: _fromDay.toDate(),
                            selectedTime: _fromTime,
                            selectDate: (DateTime date) {
                              setState(() {
                                dob = date;
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
                                    borderRadius: BorderRadius.circular(0)),
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
                                    borderRadius: BorderRadius.circular(0)),
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
                                    borderRadius: BorderRadius.circular(0)),
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
                                    borderRadius: BorderRadius.circular(0)),
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
                                    borderRadius: BorderRadius.circular(0)),
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
                            leading: Text('CreateProfile Created by'),
                            title: DropdownButton(
                              value: CreateProfileCreatedBy,
                              onChanged: ((String str) {
                                setState(() {
                                  CreateProfileCreatedBy = str;
                                });
                              }),
                              items: _dropDownCreateProfileCreatedBy,
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
                                      borderRadius: BorderRadius.circular(0)),
                                  labelText:
                                      'Relatives Info  (तुमचे  जवळचे  नातेवाईक त्यांचा म���बाइलला नंबर ) :',
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
                                      borderRadius: BorderRadius.circular(0)),
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

  void showModal(context, String str) {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text(str),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text('Ok'),
          ),
        ],
      ),
    );
  }

  void showSucessModal(context, String str) {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text(str),
        actions: <Widget>[
          new FlatButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => FireGoogleLogin()));
            },
            child: new Text('Ok'),
          ),
        ],
      ),
    );
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
