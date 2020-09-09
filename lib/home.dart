import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wxb/component/back_buton.dart';
import 'package:wxb/config/env.dart';
import 'package:wxb/store/app_bar.dart';
import 'package:wxb/utils/js_channels.dart';
import 'package:wxb/utils/screen_util.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String url = "";
  double progress = 0;
  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  @override
  void initState() {
    super.initState();
    flutterWebviewPlugin.onStateChanged.listen((viewState) async {
      if (viewState.type == WebViewState.finishLoad) {
        flutterWebviewPlugin.evalJavascript('document.title').then((value) {
          $appBarStore.setAppBar(title: value);
        });
      }
    });
    // Future.delayed(Duration(seconds: 5), () {
    //   pushNamedAutoWebview(this.context, '/test');
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }

  PreferredSizeWidget renderAppBar() {
    print($appBarStore.show);
    if (!$appBarStore.show) {
      return PreferredSize(
          child: DecoratedBox(
            decoration: BoxDecoration(color: Colors.white),
            child: SizedBox(
              height: ScreenUtil.statusBarHeight,
            ),
          ),
          preferredSize: Size.fromHeight(ScreenUtil.statusBarHeight));
    }
    return AppBar(
      title: Text(
        $appBarStore.title,
        style: TextStyle(color: Colors.black87),
      ),
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: backButton(context, color: Colors.black87, backFun: () {
        flutterWebviewPlugin.canGoBack().then((value) {
          if (value) {
            $appBarStore.setAppBar(show: false);
            flutterWebviewPlugin.goBack();
          }
        });
      }),
    );
  }

  DateTime lastPopTime;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: AnnotatedRegion(
            value: SystemUiOverlayStyle.dark,
            child: Observer(
              builder: (context) {
                return WebviewScaffold(
                  enableAppScheme: false,
                  ignoreSSLErrors: true,
                  javascriptChannels: FlutterToJsMethod.jsChannels,
                  withJavascript: true,
                  url: EnvConfig.originUrl,
                  appBar: renderAppBar(),
                  // withZoom: true,
                  withLocalStorage: true,
                  // hidden: true,
                  // initialChild: Container(
                  //   color: Colors.redAccent,
                  //   child: const Center(
                  //     child: Text('Waiting.....'),
                  //   ),
                  // ),
                );
              },
            )),
        onWillPop: () async {
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
}
