import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wxb/component/back_buton.dart';
import 'package:wxb/utils/js_channels.dart';
import 'package:wxb/utils/screen_util.dart';

class WebviewExt extends StatefulWidget {
  final String url;
  WebviewExt({Key key, this.url}) : super(key: key);

  @override
  _WebviewExtState createState() => _WebviewExtState();
}

class _WebviewExtState extends State<WebviewExt> {
  String navTitle = '';
  WebViewController _controller;
  FlutterToJsMethod _flutterToJsMethod = new FlutterToJsMethod();
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final Completer<WebViewController> _controller = Completer<WebViewController>();
    return WillPopScope(
      child: Scaffold(
        appBar: PreferredSize(
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                children: [
                  SizedBox(height: ScreenUtil.statusBarHeight),
                  SizedBox(
                    height: 44,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        backButton(context),
                        Text(
                          navTitle,
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 17),
                        ),
                        SizedBox(
                          width: 48,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            preferredSize: Size.fromHeight(44)),
        body: WebView(
          initialUrl: widget.url,
          javascriptChannels: _flutterToJsMethod.extJsChannels,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller = webViewController;
            _flutterToJsMethod.setContoller(webViewController);
          },
          onPageFinished: (url) {
            _flutterToJsMethod.postHostInfo(_controller);
            _controller.getTitle().then((value) {
              setState(() {
                this.navTitle = value;
              });
            });
          },
          onPageStarted: (url) {
            _controller.getTitle().then((value) {
              setState(() {
                this.navTitle = value;
              });
            });
          },
        ),
      ),
      onWillPop: () async {
        print("willScope${widget.key}");
        bool canGoBack = await _controller.canGoBack();
        print(canGoBack);
        if (canGoBack) {
          _controller.goBack();
          return false;
        } else {
          new FlutterWebviewPlugin()..show();
          return true;
        }
      },
    );
  }
}
