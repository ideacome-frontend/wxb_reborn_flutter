import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:overlay_webview/overlay_webview.dart';
import 'package:wxb/common/Global.dart';
import 'package:wxb/component/back_buton.dart';
import 'package:wxb/config/env.dart';
import 'package:wxb/store/app_bar.dart';
import 'package:wxb/utils/bridge/js_methoods.dart';
import 'package:wxb/utils/screen_util.dart';

// ignore: must_be_immutable
class WebPage extends StatefulWidget {
  final String url;
  final bool showNavBar;
  WebViewController webView;

  WebPage({Key key, this.url, this.showNavBar = false}) : super(key: key) {
    webView = WebViewController(id: key?.toString() ?? 'main');
  }
  @override
  _WebPageState createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  int loadCount = 0;
  String title = '';
  // final _flutterWebviewPlugin = new FlutterWebviewPlugin();
  // final _flutterJsMethod = new FlutterToJsMethod();
  @override
  void initState() {
    Global.webPages.add(widget.webView);
    super.initState();
  }

  @override
  void dispose() {
    Global.webPages.remove(widget.webView);
    super.dispose();
  }

  PreferredSizeWidget renderAppBar() {
    if ($appBarStore.show || widget.showNavBar) {
      return PreferredSize(
          child: Container(
              alignment: Alignment.bottomCenter,
              height: ScreenUtil.statusBarHeight + 50,
              color: Colors.white,
              child: Transform.translate(
                offset: Offset(0, -3),
                child: SizedBox(
                  height: 50,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [backButton(context)]),
                        ],
                      ),
                      Center(
                        child: Text(
                          $appBarStore.title,
                          style: TextStyle(color: Colors.black87, fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              )),
          preferredSize: Size.fromHeight(ScreenUtil.statusBarHeight + 50));
      // return AppBar(
      //   elevation: 0,
      //   title: Text(
      //     $appBarStore.title,
      //     style: TextStyle(color: Colors.black87, fontSize: 17),
      //   ),
      //   backgroundColor: Colors.white,
      //   centerTitle: true,
      //   leading: backButton(context, color: Colors.black87),
      // );
    }
    return PreferredSize(
        child: DecoratedBox(
          decoration: BoxDecoration(color: Colors.white),
          child: SizedBox(
            height: ScreenUtil.statusBarHeight,
          ),
        ),
        preferredSize: Size.fromHeight(ScreenUtil.statusBarHeight));
  }

  DateTime lastPopTime;

  @override
  Widget build(BuildContext context) {
    loadCount++;
    return WillPopScope(
        child: AnnotatedRegion(
            value: SystemUiOverlayStyle.dark,
            child: Observer(builder: (context) {
              return Scaffold(
                appBar: renderAppBar(),
                body: ConstrainedBox(
                  constraints: BoxConstraints.expand(),
                  child: WebView(
                    controller: widget.webView,
                    url: widget.url ?? EnvConfig.originUrl,
                    background: Container(
                      color: Colors.white,
                      constraints: BoxConstraints.expand(),
                    ),
                    onPageStart: (event) {
                      widget.webView.exec('document.title').then((value) {
                        if (value is String && !value.contains('http')) {
                          $appBarStore.setAppBar(title: value);
                        }
                      });
                      _postHostInfo();
                    },
                    onPageEnd: (event) {
                      widget.webView.exec('document.title').then((value) {
                        if (value is String && !value.contains('http')) {
                          $appBarStore.setAppBar(title: value);
                        }
                      });
                      _postHostInfo();
                    },
                    onPostMessage: (PostMessageEvent event) {
                      final String message = event.message;
                      Map obj = jsonDecode(message);
                      String cmd = obj['cmd'];
                      Map params = obj['params'];
                      String uniqueId = obj['uniqueId'];
                      if (jsMethods.containsKey(cmd)) {
                        print("调用方法$cmd");
                        jsMethods[cmd](params).then((res) {
                          this._postMessage(res, uniqueId);
                        });
                        return;
                      } else {
                        this._failureMsg(uniqueId, 'not supported');
                      }
                    },
                  ),
                ),
              );
            })),
        onWillPop: () async {
          final canBack = await widget.webView.canGoBack();
          if (canBack) {
            widget.webView.back();
            return false;
          }
          if (Navigator.of(context).canPop()) {
            return true;
          }
          if (lastPopTime == null || DateTime.now().difference(lastPopTime) > Duration(seconds: 2)) {
            lastPopTime = DateTime.now();
            Fluttertoast.showToast(msg: '再按一次退出');
            return false;
          } else {
            lastPopTime = DateTime.now();
            await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            return true;
          }
        });
  }

  // 发送消息
  _postMessage(String data, String uniqueId, {bool isNewWebView = false}) {
    widget.webView.exec('flutterBridge._postResponse({"uniqueId":"$uniqueId",response:"$data"})');
  }

  // 发送失败的消息
  _failureMsg(String uniqueId, String reason, {bool isNewWebView = false}) {
    widget.webView.exec('flutterBridge._notifyFailure({"uniqueId":"$uniqueId",reason:"$reason"})');
  }

  // 初始化设备信息
  _postHostInfo() {
    widget.webView.exec('flutterBridge._receiveHostInfo(${Global.hostInfo.toJson()})');
  }
}
