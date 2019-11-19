import 'package:flutter/material.dart';

class SilverAppBar extends StatefulWidget {
  @override
  _SilverAppBar createState() => _SilverAppBar();
}

class _SilverAppBar extends State<SilverAppBar> {
  List l = new List();
  @override
  void initState() {
    super.initState();
    for (var i = 0; i < 20; i++) {
      l.add(l);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset('asset/logo.jpg'),
            ),
            expandedHeight: 200,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ListTile(
                title: Text('$index'),
              ),
              childCount: 20,
            ),
          )
        ],
      ),
    );
  }
}
