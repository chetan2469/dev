import 'dart:developer';

import 'package:flutter/material.dart';

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String val = '0';
  double a = 0, b = 0;
  String op = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(20),
                    child: Text(
                      val,
                      style: TextStyle(fontSize: 60),
                    ),
                    alignment: Alignment.bottomRight,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(5.0),
                          child: RaisedButton(
                            color: Colors.blueGrey,
                            child: Center(
                                child: Text(
                              '1',
                              style: TextStyle(fontSize: 30),
                            )),
                            onPressed: () {
                              setState(() {
                                if (val == '0') {
                                  val = '1';
                                } else {
                                  val = val + '1';
                                }
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(5.0),
                          child: RaisedButton(
                            color: Colors.blueGrey,
                            child: Center(
                                child: Text(
                              '2',
                              style: TextStyle(fontSize: 30),
                            )),
                            onPressed: () {
                              setState(() {
                                if (val == '0') {
                                  val = '2';
                                } else {
                                  val = val + '2';
                                }
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(5.0),
                          child: RaisedButton(
                            color: Colors.blueGrey,
                            child: Center(
                                child: Text(
                              '3',
                              style: TextStyle(fontSize: 30),
                            )),
                            onPressed: () {
                              setState(() {
                                if (val == '0') {
                                  val = '3';
                                } else {
                                  val = val + '3';
                                }
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(5.0),
                          child: RaisedButton(
                            color: Colors.blueGrey,
                            child: Center(
                                child: Text(
                              '+',
                              style: TextStyle(fontSize: 30),
                            )),
                            onPressed: () {
                              setState(() {
                                if (a != 0) {
                                  b = double.parse(val);
                                  val = '0';
                                  a = (a + b);
                                  b = 0;
                                  op = '+';
                                } else {
                                  val = (a + double.parse(val)).toString();
                                  a = double.parse(val);
                                  val = '';
                                  op = '+';
                                }

                                print("__a__"+a.toString());
                                print("__b__"+b.toString());
                                print("__v__"+val.toString());

                                
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(5.0),
                          child: RaisedButton(
                            color: Colors.blueGrey,
                            child: Center(
                                child: Text(
                              '4',
                              style: TextStyle(fontSize: 30),
                            )),
                            onPressed: () {
                              setState(() {
                                if (val == '0') {
                                  val = '4';
                                } else {
                                  val = val + '4';
                                }
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(5.0),
                          child: RaisedButton(
                            color: Colors.blueGrey,
                            child: Center(
                                child: Text(
                              '5',
                              style: TextStyle(fontSize: 30),
                            )),
                            onPressed: () {
                              setState(() {
                                if (val == '0') {
                                  val = '5';
                                } else {
                                  val = val + '5';
                                }
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(5.0),
                          child: RaisedButton(
                            color: Colors.blueGrey,
                            child: Center(
                                child: Text(
                              '6',
                              style: TextStyle(fontSize: 30),
                            )),
                            onPressed: () {
                              setState(() {
                                if (val == '0') {
                                  val = '6';
                                } else {
                                  val = val + '6';
                                }
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(5.0),
                          child: RaisedButton(
                            color: Colors.blueGrey,
                            child: Center(
                                child: Text(
                              '-',
                              style: TextStyle(fontSize: 30),
                            )),
                            onPressed: () {
                              setState(() {
                                a = double.parse(val);
                                val = '';
                                op = '-';
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(5.0),
                          child: RaisedButton(
                            color: Colors.blueGrey,
                            child: Center(
                                child: Text(
                              '7',
                              style: TextStyle(fontSize: 30),
                            )),
                            onPressed: () {
                              setState(() {
                                if (val == '0') {
                                  val = '7';
                                } else {
                                  val = val + '7';
                                }
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(5.0),
                          child: RaisedButton(
                            color: Colors.blueGrey,
                            child: Center(
                                child: Text(
                              '8',
                              style: TextStyle(fontSize: 30),
                            )),
                            onPressed: () {
                              setState(() {
                                if (val == '0') {
                                  val = '8';
                                } else {
                                  val = val + '8';
                                }
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(5.0),
                          child: RaisedButton(
                            color: Colors.blueGrey,
                            child: Center(
                                child: Text(
                              '9',
                              style: TextStyle(fontSize: 30),
                            )),
                            onPressed: () {
                              setState(() {
                                if (val == '0') {
                                  val = '9';
                                } else {
                                  val = val + '9';
                                }
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(5.0),
                          child: RaisedButton(
                            color: Colors.blueGrey,
                            child: Center(
                                child: Text(
                              '/',
                              style: TextStyle(fontSize: 30),
                            )),
                            onPressed: () {
                              setState(() {
                                a = double.parse(val);
                                val = '';
                                op = '/';
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(5.0),
                          child: RaisedButton(
                            color: Colors.blueGrey,
                            child: Center(
                                child: Text(
                              'Ac',
                              style: TextStyle(fontSize: 30),
                            )),
                            onPressed: () {
                              setState(() {
                                val = '0';
                                a = 0;
                                b = 0;
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(5.0),
                          child: RaisedButton(
                            color: Colors.blueGrey,
                            child: Center(
                                child: Text(
                              '0',
                              style: TextStyle(fontSize: 30),
                            )),
                            onPressed: () {
                              setState(() {
                                if (val == '0') {
                                  val = '0';
                                } else {
                                  val = val + '0';
                                }
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(5.0),
                          child: RaisedButton(
                            color: Colors.blueGrey,
                            child: Center(
                                child: Text(
                              '.',
                              style: TextStyle(fontSize: 30),
                            )),
                            onPressed: () {
                              setState(() {
                                if (val == 0) {
                                  val = '0.';
                                } else {
                                  val = val + '.';
                                }
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(5.0),
                          child: RaisedButton(
                            color: Colors.blueGrey,
                            child: Center(
                                child: Text(
                              '*',
                              style: TextStyle(fontSize: 30),
                            )),
                            onPressed: () {
                              setState(() {
                                a = double.parse(val);
                                val = '';
                                op = '*';
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(5.0),
                        child: RaisedButton(
                          color: Colors.blueGrey,
                          child: Center(
                              child: Text(
                            '%',
                            style: TextStyle(fontSize: 30),
                          )),
                          onPressed: () {
                            setState(() {
                              a = double.parse(val);
                              val = '';
                              op = '%';
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(5.0),
                        child: RaisedButton(
                          color: Colors.blueGrey,
                          child: Center(
                              child: Text(
                            '=',
                            style: TextStyle(fontSize: 30),
                          )),
                          onPressed: () {
                            setState(() {
                              b = double.parse(val);
                              if (op == '+') {
                                val = (a + b).toString();
                              }
                              if (op == '-') {
                                val = (a - b).toString();
                              }
                              if (op == '*') {
                                val = (a * b).toString();
                              }
                              if (op == '/') {
                                val = (a / b).toString();
                              }
                              if (op == '%') {
                                val = (a % b).toString();
                              }

                              int dotLoc = val.indexOf('.');

                              if (val.length - dotLoc == 2 &&
                                  val[dotLoc + 1] == "0") {
                                val = val.substring(0, val.indexOf('.'));
                              }

                              op = '';
                            });

                            setState(() {
                              a = 0;
                              b = 0;
                              op = '';
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}