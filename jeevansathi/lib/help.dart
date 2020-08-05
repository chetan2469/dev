import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Help extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Help();
  }
}

class _Help extends State<Help> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.blue[50]),
          ),
          Positioned(
            bottom: 10.0,
            left: 10.0,
            right: 10.0,
            child: Card(
              elevation: 8.0,
              color: Colors.black54,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    child: ListTile(
                      trailing: GestureDetector(
                        onTap: () {
                          print('Print');
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.backspace,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width: 80,
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Image.asset('assets/sakRed.png'),
                      ),
                      Text(
                        'Help ',
                        style: TextStyle(fontSize: 40, color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    leading: Container(
                      width: 30,
                      child: Icon(
                        FontAwesomeIcons.whatsapp,
                        color: Colors.green,
                      ),
                    ),
                    title: Text(
                      '8793100815',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    trailing: Text(
                      '( Chetan Dongarsane )',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                  ListTile(
                    leading: Container(
                      width: 30,
                      child: Icon(
                        FontAwesomeIcons.whatsapp,
                        color: Colors.green,
                      ),
                    ),
                    title: Text(
                      '8796729742',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    trailing: Text(
                      '( Preeti Bhange )',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.white70,
                          border: Border.all(color: Colors.white)),
                      child: Text(
                        '*Please do not call on following numbers... Help will Provided by Whatsapp only...',
                        style: TextStyle(fontSize: 15, color: Colors.red),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.white70,
                          border: Border.all(color: Colors.white)),
                      child: Text(
                        '*कृपया वरील दिलेल्या नंबर वर कॉल करू नये , मदतीसाठी whatsapp वर message करावा . आपल्या समस्येचे नक्की समाधान होईली . ...',
                        style: TextStyle(fontSize: 15, color: Colors.red),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 14, left: 14, top: 14, bottom: 3),
                    child: Text(
                      "SAK Jeevansathi",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Roboto",
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 3, right: 14, left: 14, bottom: 16),
                    child: Text(
                      "Somvanshi Arya Kshatriyas Matrimonial Portal",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Roboto",
                        fontSize: 10.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
