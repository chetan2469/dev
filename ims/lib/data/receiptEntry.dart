import 'package:cloud_firestore/cloud_firestore.dart';

class ReceiptEntry {
  String course_name,
      course_id,
      receipt_page_number,
      payment_method,
      student_id,
      note;
  int paying_amount;
  Timestamp receipt_date, next_installment_date;
  DocumentReference reference;

  ReceiptEntry(
    this.paying_amount,
    this.payment_method,
    this.course_id,
    this.student_id,
    this.reference,
  );

  ReceiptEntry.fromMap(Map<String, dynamic> map, {this.reference})
      :
      // assert(map['course_name'] != null),
        assert(map['paying_amount'] != null),
        assert(map['course_id'] != null),
        assert(map['receipt_date'] != null),
        //  assert(map['next_installment_date'] != null),
        assert(map['payment_method'] != null),
        //   assert(map['receipt_page_number'] != null),
        assert(map['student_id'] != null),
        //  assert(map['note'] != null),
        course_name = map['course_name'],
        paying_amount = map['paying_amount'],
        course_id = map['course_id'],
        receipt_date = map['receipt_date'],
        next_installment_date = map['next_installment_date'],
        payment_method = map['payment_method'],
        receipt_page_number = map['receipt_page_number'],
        student_id = map['student_id'],
        note = map['note'];

  ReceiptEntry.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}
