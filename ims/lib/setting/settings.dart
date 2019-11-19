import 'package:flutter/material.dart';
import 'package:ims/constants/constants.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool mode;
  List<String> _locations = ['A', 'B', 'C', 'D']; // Option 2
  String _selectedLocation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadConstants();
  }

  loadConstants() async {
    await Constants.getMode();
    setState(() {
      if (Constants.mode != null) {
        mode = Constants.mode;
      } else {
        Constants.setMode(mode);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mode ? Colors.white24 : Colors.white,
      appBar: AppBar(
        title: Text("Setting"),
        backgroundColor: mode ? Colors.black26 : Colors.black54,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(20),
            child: ListTile(
              title: Text(
                "App Dark Mode",
                style: TextStyle(
                    fontSize: 20, color: mode ? Colors.white : Colors.black87),
              ),
              trailing: Switch(
                value: mode,
                onChanged: (bool b) {
                  Constants.setMode(b);
                  setState(() {
                    mode = b;
                    Constants.setMode(mode);
                  });
                },
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            child: ListTile(
              leading: Text(
                'Font Size',
                style: TextStyle(
                    fontSize: 20, color: mode ? Colors.white : Colors.black87),
              ),
              trailing: DropdownButton<String>(
                hint: Text("select size"),
                items: <String>['A', 'B', 'C', 'D'].map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                onChanged: (_) {},
              ),
            ),
          )
        ],
      ),
    );
  }
}
