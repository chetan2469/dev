import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReadHttp extends StatefulWidget {
  ReadHttp({Key key}) : super(key: key);

  @override
  _ReadHttpState createState() => _ReadHttpState();
}

class _ReadHttpState extends State<ReadHttp> {
  String response;
  @override
  void initState() {
    super.initState();
    getResponce();
  }

  getResponce() async {
    await getResponceFromAPI();

    if (response.contains('SMS-SHOOT-ID')) {
    } else {
      print('not found !!');
    }
  }

  getResponceFromAPI() async {
    final response = await http.get('http://numbersapi.com/42');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      setState(() {
        this.response = response.body;
      });
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(),
      ),
    );
  }
}
