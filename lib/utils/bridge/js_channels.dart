import 'dart:convert';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:webview_flutter/webview_flutter.dart' as ExtWebview;
import 'package:wxb/common/Global.dart';
import 'package:wxb/utils/bridge/js_methoods.dart';

typedef CallMethods = Future<String> Function(dynamic params);

class FlutterToJsMethod {
  static final flutterWebviewPlugin = new FlutterWebviewPlugin();
  ExtWebview.WebViewController _webController;

  Set<JavascriptChannel> jsChannels;

  Set<ExtWebview.JavascriptChannel> extJsChannels;

  FlutterToJsMethod({ExtWebview.WebViewController controller}) {
    this._webController = controller;
    this.jsChannels = [
      JavascriptChannel(
          name: 'WebViewBridge',
          onMessageReceived: (JavascriptMessage message) {
            try {
              Map obj = jsonDecode(message.message);
              String cmd = obj['cmd'];
              Map params = obj['params'];
              String uniqueId = obj['uniqueId'];
              if (jsMethods.containsKey(cmd)) {
                print("调用方法$cmd");
                jsMethods[cmd](params).then((res) {
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
        name: 'WebViewBridge',
        onMessageReceived: (ExtWebview.JavascriptMessage message) {
          try {
            Map obj = jsonDecode(message.message);
            String cmd = obj['cmd'];
            Map params = obj['params'];
            String uniqueId = obj['uniqueId'];
            if (jsMethods.containsKey('${cmd}_extWebview')) {
              print("调用方法$cmd");
              jsMethods['${cmd}_extWebview'](params).then((res) {
                this._postMessage(res, uniqueId);
              });
              return;
            }
            if (jsMethods.containsKey(cmd)) {
              print("调用方法$cmd");
              jsMethods[cmd](params).then((res) {
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
