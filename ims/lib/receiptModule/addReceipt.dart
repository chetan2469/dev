import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:ims/constants/constants.dart';
import 'package:ims/data/course_record.dart';
import 'package:ims/data/receiptEntry.dart';
import 'package:ims/data/studentCourseEntry.dart';

class AddReceipt extends StatefulWidget {
  final DateTime date;
  final DocumentReference studentReference;
  final Function updateOutStandingAmount;
  final Function updateReceiptList;
  final int outStandingAmount;
  final List<StudentCourseEntry> selectedStudentCoursesList;

  const AddReceipt(
      this.selectedStudentCoursesList,
      this.date,
      this.studentReference,
      this.outStandingAmount,
      this.updateOutStandingAmount,
      this.updateReceiptList);

  @override
  _AddReceiptState createState() => _AddReceiptState();
}

class _AddReceiptState extends State<AddReceipt> {
  bool processing = false, status = true, editing = false;
  DateTime receipt_date, next_installment_date;
  StudentCourseEntry selectedCourse = null;
  int outStandingAmount, payingFees;
  String paymentMethod, receiptNumberFromBook, note;
  List<String> paymentMethodsList = [
    'Cash',
    'Gpay',
    'Paytm',
    'Phonepay',
    'Online',
    'Card',
    'Other'
  ]; // Option 2
  TextEditingController totalCourseFeesController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      paymentMethod = "Cash";
      selectedCourse = widget.selectedStudentCoursesList.last;
      receipt_date = widget.date;
      outStandingAmount = widget.outStandingAmount;
    });
  }

  void insert() async {
    setState(() {
      processing = true;
    });
    DocumentReference referenceId =
        Firestore.instance.collection('receipts').document();
    await referenceId.setData({
      'course_name': selectedCourse.course_name,
      'paying_amount': payingFees,
      'course_id': selectedCourse.reference.documentID,
      'receipt_date': receipt_date,
      'next_installment_date': next_installment_date,
      'payment_method': paymentMethod,
      'receipt_page_number': receiptNumberFromBook,
      'student_id': widget.studentReference.documentID,
      'note': note,
    });

    ReceiptEntry receiptEntry = ReceiptEntry(
        payingFees,
        paymentMethod,
        selectedCourse.reference.documentID,
        widget.studentReference.documentID,
        referenceId);

    widget.updateReceiptList(receiptEntry);

    setState(() {
      processing = false;
    });
    // widget.updateCourseList(studentCourseEntry);
    print(" Added Entry at " + referenceId.documentID);

     Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.mode ? Colors.black87 : Colors.white,
      appBar: AppBar(
        title: Text("Add Course"),
        actions: <Widget>[
          InkWell(
            onTap: () {
              if (selectedCourse != null && receipt_date != null) {
                insert();
              }
            },
            child: Container(
              margin: EdgeInsets.all(10),
              child: Icon(Icons.save),
            ),
          )
        ],
      ),
      body: Center(
        child: processing
            ? CircularProgressIndicator()
            : ListView(
                children: <Widget>[
                  selectedCourse != null
                      ? ListTile(
                          leading: Container(
                              margin: EdgeInsets.all(20),
                              child: Text('Receipt Number on book')),
                          title: Container(
                            margin: EdgeInsets.all(20),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '101'),
                              onChanged: (str) {
                                setState(() {
                                  receiptNumberFromBook = str;
                                });
                              },
                            ),
                          ),
                        )
                      : SizedBox(),
                  ListTile(
                    leading: Container(
                        margin: EdgeInsets.all(20),
                        child: Text("Choose Course ")),
                    title: Container(
                      child: DropdownButton<StudentCourseEntry>(
                        hint: Text("Select item"),
                        value: selectedCourse,
                        onChanged: (StudentCourseEntry Value) {
                          setState(() {
                            selectedCourse = Value;
                            print(selectedCourse.course_name);
                          });
                        },
                        items: widget.selectedStudentCoursesList
                            .map((StudentCourseEntry user) {
                          return DropdownMenuItem<StudentCourseEntry>(
                            value: user,
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.book),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  user.course_name,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  selectedCourse != null
                      ? ListTile(
                          leading: Container(
                              margin: EdgeInsets.all(20),
                              child: Text('Payment Method')),
                          title: DropdownButton(
                            // Not necessary for Option 1
                            value: paymentMethod,
                            onChanged: (newValue) {
                              setState(() {
                                paymentMethod = newValue;
                              });
                              print(paymentMethod);
                            },
                            items: paymentMethodsList.map((paymentMethod) {
                              return DropdownMenuItem(
                                child: new Text(paymentMethod),
                                value: paymentMethod,
                              );
                            }).toList(),
                          ),
                        )
                      : SizedBox(),
                  selectedCourse != null
                      ? ListTile(
                          leading: Container(
                              margin: EdgeInsets.all(20),
                              child: Text('Paying Fees')),
                          title: Container(
                            margin: EdgeInsets.all(20),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Paying Fees'),
                              onChanged: (String value) {
                                setState(() {
                                  payingFees = int.parse(value);
                                  outStandingAmount = widget.outStandingAmount -
                                      int.parse(value);
                                });
                              },
                            ),
                          ),
                        )
                      : SizedBox(),
                  selectedCourse != null
                      ? ListTile(
                          leading: Container(
                              margin: EdgeInsets.all(20),
                              child: Text('Outstanding Fees')),
                          title: Container(
                            margin: EdgeInsets.all(20),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: outStandingAmount.toString()),
                            ),
                          ),
                        )
                      : SizedBox(),
                  selectedCourse != null
                      ? Container(
                          margin: EdgeInsets.all(20),
                          child: InkWell(
                            onTap: () {
                              DatePicker.showDatePicker(context,
                                  showTitleActions: true,
                                  minTime: DateTime(2017, 1, 1),
                                  maxTime:
                                      DateTime.now().add(Duration(days: 365)),
                                  onChanged: (date) {
                                print('change $date');
                              },
                                  currentTime: DateTime.now(),
                                  locale: LocaleType.en);
                            },
                            child: Container(
                              child: ListTile(
                                leading: Text("Receipt Date    "),
                                trailing: Icon(Icons.calendar_today),
                                title: receipt_date != null
                                    ? Container(
                                        color: Colors.redAccent,
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                            receipt_date.day.toString() +
                                                ' / ' +
                                                receipt_date.month.toString() +
                                                ' / ' +
                                                receipt_date.year.toString(),
                                            style:
                                                TextStyle(color: Colors.white)),
                                      )
                                    : Container(
                                        color: Colors.redAccent,
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          "Select Date",
                                          style: TextStyle(color: Colors.white),
                                        )),
                              ),
                            ),
                          ),
                        )
                      : SizedBox(),
                  selectedCourse != null
                      ? Container(
                          margin: EdgeInsets.all(20),
                          child: InkWell(
                            onTap: () {
                              DatePicker.showDatePicker(context,
                                  showTitleActions: true,
                                  minTime: DateTime(1960, 1, 1),
                                  maxTime:
                                      DateTime.now().add(Duration(days: 730)),
                                  onChanged: (date) {
                                print('change $date');
                              }, onConfirm: (date) {
                                print('confirm $date');
                                setState(() {
                                  next_installment_date = date;
                                });
                              },
                                  currentTime: DateTime.now(),
                                  locale: LocaleType.en);
                            },
                            child: Container(
                              child: ListTile(
                                leading: Text(' Next Installment'),
                                trailing: Icon(Icons.calendar_today),
                                title: next_installment_date != null
                                    ? Container(
                                        color: Colors.redAccent,
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                            next_installment_date.day
                                                    .toString() +
                                                ' / ' +
                                                next_installment_date.month
                                                    .toString() +
                                                ' / ' +
                                                next_installment_date.year
                                                    .toString(),
                                            style:
                                                TextStyle(color: Colors.white)),
                                      )
                                    : Container(
                                        color: Colors.redAccent,
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          "Select Date",
                                          style: TextStyle(color: Colors.white),
                                        )),
                              ),
                            ),
                          ),
                        )
                      : SizedBox(),
                  Container(
                    margin: EdgeInsets.all(20),
                    child: TextField(
                      maxLines: 3,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Write some note...'),
                      onChanged: (str) {
                        setState(() {
                          note = str;
                        });
                      },
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
