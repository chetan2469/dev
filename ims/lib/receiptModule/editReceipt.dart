import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ims/data/receiptEntry.dart';

class EditReceipt extends StatefulWidget {
  final ReceiptEntry receiptEntry;

  EditReceipt(this.receiptEntry);

  @override
  _EditReceiptState createState() => _EditReceiptState();
}

class _EditReceiptState extends State<EditReceipt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(widget.receiptEntry.paying_amount.toString()),
      ),
    );
  }
}
