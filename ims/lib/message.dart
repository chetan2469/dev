import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'enquiryForm.dart';

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  String url =
      'http://kutility.in/app/smsapi/index.php?key=45E37D3551796D&routeid=415&type=text&contacts=8793100815,9762673744&senderid=WEBDEV&msg=Hello+People%2C+have+a+great+day';
  String response;
  bool sending = false;

  getResponce() async {
    setState(() {
      sending = true;
    });
    await getResponceFromAPI();

    if (response.contains('SMS-SHOOT-ID')) {
      print('send successfullly !!');
    } else {
      print('Not send');
    }

    setState(() {
      sending = false;
    });
  }

  getResponceFromAPI() async {
    final response = await http.get(url);
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
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: sending
            ? CircularProgressIndicator()
            : RaisedButton(
                onPressed: getResponce,
                child: Text('send sms'),
              ),
      ),
    );
  }
}
