import 'package:cloud_firestore/cloud_firestore.dart';

class StudentCourseEntry {
  final String course_name;
  final int course_total_fees, course_remaining_fees;
  Timestamp course_start_date, course_end_date;
  final DocumentReference reference;

  List<dynamic> receiptList;

  StudentCourseEntry.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['course_name'] != null),
        assert(map['course_total_fees'] != null),
        assert(map['course_remaining_fees'] != null),
        assert(map['course_start_date'] != null),
        assert(map['course_end_date'] != null),
        course_name = map['course_name'],
        course_total_fees = map['course_total_fees'],
        course_remaining_fees = map['course_remaining_fees'],
        course_start_date = map['course_start_date'],
        receiptList = map['receipt'],
        course_end_date = map['course_end_date'];

  StudentCourseEntry.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}
