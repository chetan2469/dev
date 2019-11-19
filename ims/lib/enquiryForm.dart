import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewContainer extends StatefulWidget {
  final String _url;
  WebViewContainer(this._url);
  @override
  _WebViewContainer createState() => _WebViewContainer();
}

class _WebViewContainer extends State<WebViewContainer> {
  
  final _key = UniqueKey();
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back_ios),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: WebView(
                  key: _key,
                  javascriptMode: JavascriptMode.unrestricted,
                  initialUrl: widget._url))
        ],
      ),
    );
  }
}
