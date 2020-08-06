import 'package:cloud_firestore/cloud_firestore.dart';

class Record {
  final String name, sakId, gender;
  final String photoUrl;
  final String thumbnail;
  final String birthState;
  final String birthPlace;
  final String currentRecidential;
  final String education;
  final String proffesion, horoscopeMatch;
  final String height, maritalStatus;
  final Timestamp dob;
  final String email, expectations, moreInfo;
  final String mob1;
  final String mob2;
  final String profileCreatedBy;
  final bool active;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        name = map['name'],
        photoUrl = map['photoUrl'],
        thumbnail = map['thumbnail'],
        birthState = map['birthState'],
        birthPlace = map['birthPlace'],
        dob = map['dob'],
        height = map['height'],
        proffesion = map['proffesion'],
        education = map['education'],
        mob1 = map['mob1'],
        mob2 = map['mob2'],
        currentRecidential = map['currentRecidential'],
        moreInfo = map['moreInfo'],
        expectations = map['expectations'],
        maritalStatus = map['maritalStatus'],
        horoscopeMatch = map['horoscopeMatch'],
        sakId = map['sakId'],
        email = map['email'],
        gender = map['gender'],
        profileCreatedBy = map['profileCreatedBy'],
        active = map['active'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$photoUrl>";
}
