import 'package:flutter/material.dart';
import 'package:wxb/routes/navigaiton_service.dart';
import 'package:wxb/routes/router_navigation.dart';
import 'package:wxb/webview_ext.dart';
import 'dart:io';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

typedef CallMethods = Future<String> Function(dynamic params);
final flutterWebviewPlugin = new FlutterWebviewPlugin();
final jsMethods = Map<String, CallMethods>.from({
  "openNewWebView": (params) async {
    String url = params["url"];
    bool navBarHidden = params['navBarHidden'] ?? false;
    if (Platform.isAndroid) {
      pushWithoutAnimation(
        new WebviewExt(
          url: url,
          showNavBar: !navBarHidden,
        ),
        NavigationService.navigatorKey.currentState.context,
      ).then((value) => flutterWebviewPlugin.show());
      Future.delayed(Duration(milliseconds: 400), () {
        flutterWebviewPlugin.hide();
      });
    } else {
      flutterWebviewPlugin.hide();
      NavigationService.navigatorKey.currentState.pushNamed('/newwebview', arguments: {
        "url": url,
        "showNavBar": !navBarHidden,
      }).then((value) {
        flutterWebviewPlugin.show();
      });
    }
  },
  "openNewWebView_extWebview": (params) async {
    print("新打开的webview执行了jsbridge");
    String url = params["url"];
    bool navBarHidden = params['navBarHidden'] ?? false;
    if (Platform.isAndroid) {
      pushWithoutAnimation(
        new WebviewExt(
          url: url,
          showNavBar: !navBarHidden,
          key: UniqueKey(),
        ),
        NavigationService.navigatorKey.currentState.context,
      );
    } else {
      NavigationService.navigatorKey.currentState.pushNamed(
        '/newwebview',
        arguments: {
          "url": url,
          "showNavBar": !navBarHidden,
        },
      );
    }
  }
});
