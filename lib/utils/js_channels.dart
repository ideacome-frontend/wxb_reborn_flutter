import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:webview_flutter/webview_flutter.dart' as ExtWebview;
import 'package:wxb/common/Global.dart';
import 'package:wxb/routes/navigaiton_service.dart';
import 'package:wxb/routes/router_navigation.dart';
// import 'package:wxb/store/app_bar.dart';
import 'package:wxb/webview_ext.dart';

typedef CallMethods = Future<String> Function(dynamic params);

class FlutterToJsMethod {
  static final flutterWebviewPlugin = new FlutterWebviewPlugin();
  ExtWebview.WebViewController _webController;

  static Map<String, CallMethods> cmdMap = Map<String, CallMethods>.from({
    "openNewWebView": (params) async {
      String url = params["url"];
      flutterWebviewPlugin.hide();
      if (Platform.isAndroid) {
        Future.delayed(Duration(milliseconds: 200), () {
          pushWithoutAnimation(
            new WebviewExt(
              url: url,
            ),
            NavigationService.navigatorKey.currentState.context,
          ).then((value) => flutterWebviewPlugin.show());
        });
      } else {
        NavigationService.navigatorKey.currentState.pushNamed('/newwebview', arguments: url).then((value) {
          flutterWebviewPlugin.show();
        });
      }
    },
    "openNewWebView_extWebview": (params) async {
      print("新打开的webview执行了jsbridge");
      String url = params["url"];
      if (Platform.isAndroid) {
        Future.delayed(Duration(milliseconds: 200), () {
          pushWithoutAnimation(
            new WebviewExt(
              url: url,
              key: UniqueKey(),
            ),
            NavigationService.navigatorKey.currentState.context,
          );
        });
      } else {
        NavigationService.navigatorKey.currentState.pushNamed(
          '/newwebview',
          arguments: url,
        );
      }
    }
  });

  Set<JavascriptChannel> jsChannels;

  Set<ExtWebview.JavascriptChannel> extJsChannels;

  FlutterToJsMethod({ExtWebview.WebViewController controller}) {
    this._webController = controller;
    this.jsChannels = [
      JavascriptChannel(
          name: 'WxbCmd',
          onMessageReceived: (JavascriptMessage message) {
            try {
              Map obj = jsonDecode(message.message);
              String cmd = obj['cmd'];
              Map params = obj['params'];
              String uniqueId = obj['uniqueId'];
              if (cmdMap.containsKey(cmd)) {
                print("调用方法$cmd");
                cmdMap[cmd](params).then((res) {
                  this._postMessage(res, uniqueId);
                });
              } else {
                _failureMsg(uniqueId, 'not supported');
              }
            } catch (e) {
              print(e);
            }
          }),
      JavascriptChannel(name: 'HostInfo', onMessageReceived: (JavascriptMessage message) {})
    ].toSet();

    this.extJsChannels = [
      ExtWebview.JavascriptChannel(
        name: 'WxbCmd',
        onMessageReceived: (ExtWebview.JavascriptMessage message) {
          try {
            Map obj = jsonDecode(message.message);
            String cmd = obj['cmd'];
            Map params = obj['params'];
            String uniqueId = obj['uniqueId'];
            if (cmdMap.containsKey('${cmd}_extWebview')) {
              print("调用方法$cmd");
              cmdMap['${cmd}_extWebview'](params).then((res) {
                this._postMessage(res, uniqueId);
              });
              return;
            }
            if (cmdMap.containsKey(cmd)) {
              print("调用方法$cmd");
              cmdMap[cmd](params).then((res) {
                this._postMessage(res, uniqueId);
              });
              return;
            } else {
              _failureMsg(uniqueId, 'not supported');
            }
          } catch (e) {
            print(e);
          }
        },
      ),
    ].toSet();
  }

  setContoller(ExtWebview.WebViewController controller) {
    this._webController = controller;
  }

  postHostInfo(dynamic controller) {
    if (controller is FlutterWebviewPlugin) {
      controller.evalJavascript('flutterBridge._receiveHostInfo(${Global.hostInfo.toJson()})');
    } else if (controller is ExtWebview.WebViewController) {
      controller.evaluateJavascript('flutterBridge._receiveHostInfo(${Global.hostInfo.toJson()})');
    }
  }

  _postMessage(String data, String uniqueId, {bool isNewWebView = false}) {
    if (isNewWebView) {
      _webController.evaluateJavascript('flutterBridge._postResponse({"uniqueId":$uniqueId,response:$data})');
      return;
    }
    flutterWebviewPlugin.evalJavascript('flutterBridge._postResponse({"uniqueId":$uniqueId,response:$data})');
  }

  _failureMsg(String uniqueId, String reason, {bool isNewWebView = false}) {
    if (isNewWebView) {
      _webController.evaluateJavascript('flutterBridge._notifyFailure({"uniqueId":$uniqueId,reason:$reason})');
      return;
    }
    flutterWebviewPlugin.evalJavascript('flutterBridge._notifyFailure({"uniqueId":$uniqueId,reason:$reason})');
  }
}
