import 'package:backdrop/backdrop.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rojnishi/data/staticDatas.dart';
import 'package:rojnishi/ui/backlayer.dart';

// ignore: must_be_immutable
class AddNote extends StatefulWidget {
  GoogleSignInAccount user;
  Function signout;
  AddNote(this.user, this.signout);
  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  double happyrate = 5;
  String name = '';
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController noteController = new TextEditingController();
  final snackBar = SnackBar(
      content: Text('Note length should greter than 10 characters...'));
  final snackBarSuccess =
      SnackBar(content: Text('Your Note added Successfully...'));

  @override
  void initState() {
    super.initState();
    setState(() {
      name = StaticDatas.username.split(' ')[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackdropScaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        child: Text('save'),
        onPressed: () async {
          if (noteController.text.length > 5) {
            bool a = await insert();
            if (a) {
              Navigator.pop(context);
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
      ),
      backLayer: BackdropLayer(widget.signout, widget.user),
      frontLayer: Center(
        child: ListView(
          children: [
            Container(
              height: 200,
              child: CachedNetworkImage(
                placeholder: (context, url) => Center(
                    child: Container(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator())),
                imageUrl:
                    'https://firebasestorage.googleapis.com/v0/b/flutter-chedo.appspot.com/o/pngs%2Fimage%202.png?alt=media&token=943c4131-94d1-46a1-845d-47aa3855f266',
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30),
              width: MediaQuery.of(context).size.width * .8,
              child: TextField(
                  controller: noteController,
                  cursorColor: Colors.black,
                  maxLines: 15,
                  decoration: InputDecoration(
                    fillColor: Color.fromARGB(205, 212, 229, 255),
                    filled: true,
                    hintText: ' Hey $name what happened today ??',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  )),
            ),
            Divider(),
            Container(
              child: Center(
                  child: Text(
                      'Give yourself rating how was happy you ware today ??')),
            ),
            Container(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.red[700],
                  inactiveTrackColor: Colors.red[100],
                  trackShape: RoundedRectSliderTrackShape(),
                  trackHeight: 4.0,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                  thumbColor: Colors.redAccent,
                  overlayColor: Colors.red.withAlpha(32),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                  tickMarkShape: RoundSliderTickMarkShape(),
                  activeTickMarkColor: Colors.red[700],
                  inactiveTickMarkColor: Colors.red[100],
                  valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                  valueIndicatorColor: Colors.redAccent,
                  valueIndicatorTextStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                child: Slider(
                  value: happyrate,
                  min: 0,
                  max: 10,
                  divisions: 10,
                  label: '$happyrate',
                  onChanged: (value) {
                    setState(
                      () {
                        happyrate = value;
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> insert() async {
    try {
      await firestore
          .collection('rojnishi')
          .doc(widget.user.email.toString())
          .collection('notes')
          .doc()
          .set({
        'isDeleted': false,
        'note': noteController.text,
        'dateTime': DateTime.now(),
        'happyRate': happyrate
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
