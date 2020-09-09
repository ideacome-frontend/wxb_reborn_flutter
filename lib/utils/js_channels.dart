import 'dart:convert';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

final flutterWebviewPlugin = new FlutterWebviewPlugin();

class FlutterToJsMethod {
  static Map<String, Function> cmdMap = Map.from({
    "openNewWebView": (params) {
      String url = params["url"];
      flutterWebviewPlugin.launch(url);
    }
  });
  static final Set<JavascriptChannel> jsChannels = [
    JavascriptChannel(
        name: 'Print',
        onMessageReceived: (JavascriptMessage message) {
          print(message.message);
        }),
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
              cmdMap[cmd](params);
            } else {
              _failureMsg(uniqueId, 'not supported');
            }
          } catch (e) {
            print(e);
          }
        }),
    JavascriptChannel(name: 'HostInfo', onMessageReceived: (JavascriptMessage message) {})
  ].toSet();

  // _postMessage(dynamic data) {}

  static _failureMsg(String uniqueId, String reason) {
    flutterWebviewPlugin.evalJavascript('flutterBridge._notifyFailure({"uniqueId":$uniqueId,reason:$reason})');
  }
}
