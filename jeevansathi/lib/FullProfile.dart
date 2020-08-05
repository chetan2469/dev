import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'datatype/Record.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class _ContactCategory extends StatelessWidget {
  const _ContactCategory({Key key, this.icon, this.children}) : super(key: key);

  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: themeData.dividerColor))),
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.subhead,
        child: SafeArea(
          top: false,
          bottom: false,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                width: 72.0,
                child: Icon(icon, color: themeData.primaryColor),
              ),
              Expanded(child: Column(children: children)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  _ContactItem({Key key, this.icon, this.lines, this.tooltip, this.onPressed})
      : assert(lines.length > 1),
        super(key: key);

  final IconData icon;
  final List<String> lines;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final List<Widget> columnChildren = lines
        .sublist(0, lines.length - 1)
        .map<Widget>((String line) => Text(line))
        .toList();
    columnChildren.add(Text(lines.last, style: themeData.textTheme.caption));

    final List<Widget> rowChildren = <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: columnChildren,
        ),
      ),
    ];
    if (icon != null) {
      rowChildren.add(SizedBox(
        width: 72.0,
        child: IconButton(
          icon: Icon(icon),
          color: themeData.primaryColor,
          onPressed: onPressed,
        ),
      ));
    }
    return MergeSemantics(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: rowChildren,
        ),
      ),
    );
  }
}

class ProfileContactInfo extends StatefulWidget {
  final DocumentSnapshot data;
  Record record;
  int age;

  ProfileContactInfo(this.data) {
    record = Record.fromSnapshot(data);
  }

  @override
  ProfileContactInfoState createState() => ProfileContactInfoState();
}

enum AppBarBehavior { normal, pinned, floating, snapping }

class ProfileContactInfoState extends State<ProfileContactInfo> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  final double _appBarHeight = 256.0;

  AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.pink,
        platform: Theme.of(context).platform,
      ),
      child: Scaffold(
        key: _scaffoldKey,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: _appBarHeight,
              pinned: _appBarBehavior == AppBarBehavior.pinned,
              floating: _appBarBehavior == AppBarBehavior.floating ||
                  _appBarBehavior == AppBarBehavior.snapping,
              snap: _appBarBehavior == AppBarBehavior.snapping,
              actions: <Widget>[
                PopupMenuButton<AppBarBehavior>(
                  onSelected: (AppBarBehavior value) {
                    setState(() {
                      _appBarBehavior = value;
                    });
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuItem<AppBarBehavior>>[
                        const PopupMenuItem<AppBarBehavior>(
                          value: AppBarBehavior.normal,
                          child: Text('App bar scrolls away'),
                        ),
                        const PopupMenuItem<AppBarBehavior>(
                          value: AppBarBehavior.pinned,
                          child: Text('App bar stays put'),
                        ),
                        const PopupMenuItem<AppBarBehavior>(
                          value: AppBarBehavior.floating,
                          child: Text('App bar floats'),
                        ),
                        const PopupMenuItem<AppBarBehavior>(
                          value: AppBarBehavior.snapping,
                          child: Text('App bar snaps'),
                        ),
                      ],
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  widget.record.name.toString(),
                  style: TextStyle(backgroundColor: Colors.black26),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl: widget.record.photoUrl,
                      fit: BoxFit.cover,
                      height: _appBarHeight,
                    ),
                    // This gradient ensures that the toolbar icons are distinct
                    // against the background image.
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0.0, -1.0),
                          end: Alignment(0.0, -0.4),
                          colors: <Color>[Color(0x60000000), Color(0x00000000)],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(<Widget>[
                AnnotatedRegion<SystemUiOverlayStyle>(
                  value: SystemUiOverlayStyle.dark,
                  child: _ContactCategory(
                    icon: Icons.person,
                    children: <Widget>[
                      _ContactItem(
                        lines: <String>[
                          widget.record.name,
                          'Name',
                        ],
                      ),
                      _ContactItem(
                        lines: <String>[
                          widget.record.proffesion,
                          'Proffesion',
                        ],
                      ),
                      _ContactItem(
                        lines: <String>[
                          widget.record.maritalStatus,
                          'Marital Status',
                        ],
                      ),
                      _ContactItem(
                        lines: <String>[
                          widget.record.moreInfo,
                          'More Info',
                        ],
                      ),
                      _ContactItem(
                        lines: <String>[
                          widget.record.expectations +
                                      " " +
                                      widget.record.horoscopeMatch.toString() ==
                                  "Yes"
                              ? "Horoscope Should Match "
                              : "Horoscope Should Match",
                          'Expectations',
                        ],
                      ),
                      _ContactItem(
                        lines: <String>[
                          widget.record.height + "  ft",
                          'Heigth',
                        ],
                      ),
                    ],
                  ),
                ),
                AnnotatedRegion<SystemUiOverlayStyle>(
                  value: SystemUiOverlayStyle.dark,
                  child: _ContactCategory(
                    icon: Icons.call,
                    children: <Widget>[
                      _ContactItem(
                        tooltip: 'Send message',
                        onPressed: () {
                          _scaffoldKey.currentState.showSnackBar(const SnackBar(
                            content: Text(
                                'Pretend that this opened your SMS application.'),
                          ));
                        },
                        lines: <String>[
                          widget.record.mob1.toString(),
                          'Mobile',
                        ],
                      ),
                      _ContactItem(
                        tooltip: 'Send message',
                        onPressed: () {
                          _scaffoldKey.currentState.showSnackBar(const SnackBar(
                            content: Text(
                                'Pretend that this opened your SMS application.'),
                          ));
                        },
                        lines: <String>[
                          widget.record.mob2!=null?widget.record.mob2.toString():'-----',
                          'Mobile',
                        ],
                      ),
                    ],
                  ),
                ),
                _ContactCategory(
                  icon: Icons.contact_mail,
                  children: <Widget>[
                    _ContactItem(
                      icon: Icons.email,
                      tooltip: 'Send personal e-mail',
                      onPressed: () {
                        _scaffoldKey.currentState.showSnackBar(const SnackBar(
                          content:
                              Text('Here, your e-mail application would open.'),
                        ));
                      },
                      lines: <String>[
                        widget.record.email.toString(),
                        'Profile Created by',
                      ],
                    ),
                  ],
                ),
                _ContactCategory(
                  icon: Icons.today,
                  children: <Widget>[
                    _ContactItem(
                      lines: <String>[
                        DateFormat.yMMMd().format(widget.record.dob.toDate()),
                        'Birthday'
                      ],
                    ),
                    _ContactItem(
                      lines: <String>[
                        widget.record.dob.toDate().hour.toString() +
                            " : " +
                            widget.record.dob.toDate().minute.toString() +
                            " ",
                        'Birth Time ( 24-Hour Time Format )'
                      ],
                    ),
                  ],
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
