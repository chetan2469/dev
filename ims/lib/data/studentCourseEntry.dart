import 'package:cloud_firestore/cloud_firestore.dart';

class StudentCourseEntry {
  final String course_name;
  final String course_total_fees, course_fees;
  Timestamp course_start_date, course_validity_date;
  final DocumentReference reference;

  StudentCourseEntry(
      {this.course_name,
      this.course_fees,
      this.course_start_date,
      this.course_total_fees,
      this.course_validity_date,
      this.reference});

  StudentCourseEntry.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['course_name'] != null),
        assert(map['course_total_fees'] != null),
        assert(map['course_fees'] != null),
        assert(map['course_start_date'] != null),
        assert(map['course_validity_date'] != null),
        course_name = map['course_name'],
        course_total_fees = map['course_total_fees'],
        course_fees = map['course_remaining_fees'],
        course_start_date = map['course_start_date'],
        course_validity_date = map['course_validity_date'];

  StudentCourseEntry.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}
