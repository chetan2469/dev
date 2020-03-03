import 'package:cloud_firestore/cloud_firestore.dart';

class StudentCourse {
 // final List receipt;
  final int remainingFees,totalFees;
  final String courseName;
  final Timestamp courseStartDate, courseEndDate;
  final DocumentReference reference;

  StudentCourse.fromMap(Map<String, dynamic> map, {this.reference})
      : 
        assert(map['courseName'] != null),

     // receipt = map['receipt'],
        courseName = map['courseName'],
        totalFees = map['totalFees'],
        remainingFees = map['remainingFees'],
        courseStartDate = map['courseStartDate'],
        courseEndDate = map['courseEndDate'];

  StudentCourse.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  }
