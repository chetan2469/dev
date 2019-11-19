import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ViewImage extends StatefulWidget {
  final String url;
  ViewImage(this.url);
  @override
  _ViewImageState createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Text('back'),
        onPressed: (){
          Navigator.pop(context);
          
        },
      ),
      body: Center(
          child: PhotoView(
        loadingChild: CircularProgressIndicator(),
        imageProvider: CachedNetworkImageProvider(widget.url),
      )),
    );
  }
}
