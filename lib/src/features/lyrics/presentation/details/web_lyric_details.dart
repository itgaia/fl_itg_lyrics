import 'package:flutter/material.dart';

class WebSongDetails extends StatelessWidget {
  final String songDetailsURL;

  WebSongDetails({required this.songDetailsURL});

  @override
  Widget build(BuildContext context) {
    return Text('lyrics detail (webview plugin is not compatible)');
    // return WebviewScaffold(
    //   url: songDetailsURL,
    //   appBar: AppBar(
    //     title: Text(ItgLocalization.tr('lyrics')),
    //   ),
    // );
  }
}
