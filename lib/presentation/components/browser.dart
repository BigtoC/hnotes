import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:hnotes/presentation/theme.dart';

class Browser extends StatelessWidget {
  final String title;
  final String url;

  Browser({required this.title, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: Icon(Icons.clear, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
