import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rojnishi/addPartner.dart';
import 'package:rojnishi/ui/profile.dart';
import 'package:rojnishi/friendNotes.dart';

import '../addNote.dart';
import '../auth.dart';

// ignore: must_be_immutable
class BackdropLayer extends StatefulWidget {
  Function signout;
  GoogleSignInAccount user;
  BackdropLayer(this.signout, this.user);
  @override
  _BackdropLayerState createState() => _BackdropLayerState();
}

class _BackdropLayerState extends State<BackdropLayer> {
  TextStyle backdropMenuStyle =
      TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddNote(widget.user, widget.signout)),
              );
            },
            child: ListTile(
                title: Text(
                  'Add Note',
                  style: backdropMenuStyle,
                ),
                leading: Icon(
                  Icons.add,
                  color: Colors.white,
                )),
          ),
          Divider(
            height: 5,
          ),
          InkWell(
            onTap: () {},
            child: ListTile(
                title: Text(
                  'View Notes',
                  style: backdropMenuStyle,
                ),
                leading: Icon(
                  Icons.view_agenda,
                  color: Colors.white,
                )),
          ),
          Divider(
            height: 5,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile(widget.user)),
              );
            },
            child: ListTile(
                title: Text(
                  'Edit Profile',
                  style: backdropMenuStyle,
                ),
                leading: Icon(
                  Icons.person,
                  color: Colors.white,
                )),
          ),
          Divider(
            height: 5,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddPartner()),
              );
            },
            child: ListTile(
                title: Text(
                  'Add Partner ( Who can view your notes )',
                  style: backdropMenuStyle,
                ),
                leading: Icon(
                  Icons.person_add,
                  color: Colors.white,
                )),
          ),
          Divider(
            height: 5,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FriendNotes()),
              );
            },
            child: ListTile(
                title: Text(
                  'Friend Notes',
                  style: backdropMenuStyle,
                ),
                leading: Icon(
                  Icons.person_add,
                  color: Colors.white,
                )),
          ),
          Divider(
            height: 5,
          ),
          InkWell(
            onTap: () {
              widget.signout();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Auth()));
            },
            child: ListTile(
                title: Text(
                  'Log Out',
                  style: backdropMenuStyle,
                ),
                leading: Icon(
                  Icons.logout,
                  color: Colors.white,
                )),
          ),
          Divider(
            height: 5,
          ),
        ],
      ),
    );
  }
}
