import 'package:flutter/material.dart';

class ListWheel extends StatefulWidget {
  @override
  _ListWheelState createState() => _ListWheelState();
}

class _ListWheelState extends State<ListWheel> {
  final FixedExtentScrollController _controller = FixedExtentScrollController();

  List<String> friends = new List();

  List<Widget> friendNames = new List();

  @override
  void initState() {
    super.initState();
    friends = [
      "Suresh",
      "Ramesh",
      "Tejas",
      "Sameer",
      "Shreekant",
      "Aniruddh",
      "Sangram",
      "Vikas",
      "Shubham",
      "Hrushikesh",
    ];

    for (var item in friends) {
      friendNames.add(Container(
        child: Text(item.toString()),
      ));
    }
  }

  List<Widget> listtiles = [
    ListTile(
      leading: Icon(Icons.portrait),
      title: Text("Portrait"),
      subtitle: Text("Beautiful View..!"),
      trailing: Icon(Icons.arrow_forward_ios),
    ),
    ListTile(
      leading: Icon(Icons.landscape),
      title: Text("LandScape"),
      subtitle: Text("Beautiful View..!"),
      trailing: Icon(Icons.remove),
    ),
    ListTile(
      leading: Icon(Icons.map),
      title: Text("Map"),
      subtitle: Text("Map View..!"),
      trailing: Icon(Icons.wb_sunny),
    ),
    ListTile(
      leading: Icon(Icons.list),
      title: Text("List Example"),
      subtitle: Text("List Wheel Scroll view .!"),
      trailing: Icon(Icons.cloud),
    ),
    ListTile(
      leading: Icon(Icons.settings),
      title: Text("Settings"),
      subtitle: Text("Change the setting..!"),
      trailing: Icon(Icons.portrait),
    ),
    ListTile(
      leading: Icon(Icons.email),
      title: Text("Email"),
      subtitle: Text("Check Email..!"),
      trailing: Icon(Icons.arrow_forward),
    ),
    ListTile(
      leading: Icon(Icons.games),
      title: Text("Games"),
      subtitle: Text("Play Games..!"),
      trailing: Icon(Icons.zoom_out_map),
    ),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListWheelScrollView(
      controller: _controller,
      offAxisFraction: -1.3,
      itemExtent: 80,
      useMagnifier: true,
      magnification: 1.2,
      diameterRatio: 3.5,
      physics: FixedExtentScrollPhysics(),
      children: friends.map((frd) {
    return Card(
        child: Row(
      children: <Widget>[
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            frd,
            style: TextStyle(fontSize: 18.0),
          ),
        )),
      ],
    ));
  }).toList(),
    ));
  }
}
