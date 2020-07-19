import 'package:cloud_firestore/cloud_firestore.dart';

class Record {
  final List courses,receipts;
  final String name,
      address,
      mobileno,
      optionalno,
      aadharno,
      pursuing_course,
      batchtime,
      gender,
      imageurl;
  final int outStandingAmount;
  Timestamp dateofbirth, addDate;
  bool status;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['address'] != null),
        assert(map['mobileNo'] != null),
        assert(map['aadharNo'] != null),
        assert(map['batchTime'] != null),
        assert(map['imageUrl'] != null),
        name = map['name'],
        address = map['address'],
        mobileno = map['mobileNo'],
        optionalno = map['optNumber'],
        aadharno = map['aadharNo'],
        pursuing_course = map['pursuing_course'],
        batchtime = map['batchTime'],
        dateofbirth = map['dateOfBirth'],
        addDate = map['addDate'],
        status = map['status'],
        gender = map['gender'],
        courses = map['courses'],
        receipts = map['receipts'],
        outStandingAmount = map['outStandingAmount'],
        imageurl = map['imageUrl'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() =>
      "Record<$name:$address:$mobileno:$optionalno:$aadharno:$pursuing_course:$batchtime:$dateofbirth:$imageurl>";
}
