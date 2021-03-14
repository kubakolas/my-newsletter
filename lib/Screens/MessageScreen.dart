import 'dart:convert';
import 'package:mynewsletter/Model/Message.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MessageScreen extends StatefulWidget {

  Message message;

  MessageScreen(Message message) {
    this.message = message;
  }

  @override
  State<StatefulWidget> createState() {
    return MessageScreenState(message);
  }
}

class MessageScreenState extends State<MessageScreen> {
  Message message;
  WebViewController _controller;

  MessageScreenState(Message message) {
    this.message = message;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(message.subject, style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: WebView(
        initialUrl: 'about:blank',
        onWebViewCreated: (WebViewController webViewController) {
          _controller = webViewController;
          _loadHtmlFromAssets();
        },
      ),
    );
  }

  _loadHtmlFromAssets() {
    _controller.loadUrl(Uri.dataFromString(
        message.data,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8')
    ).toString());
  }
}
