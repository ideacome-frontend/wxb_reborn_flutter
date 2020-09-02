import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wxb/config/env.dart';
import 'package:wxb/utils/screen_util.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String url = "";
  double progress = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  DateTime lastPopTime;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: AnnotatedRegion(
          value: SystemUiOverlayStyle.dark,
          child: WebviewScaffold(
            enableAppScheme: false,
            ignoreSSLErrors: true,
            url: EnvConfig.originUrl,
            appBar: PreferredSize(
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.white),
                  child: SizedBox(
                    height: ScreenUtil.statusBarHeight,
                  ),
                ),
                preferredSize: Size.fromHeight(ScreenUtil.statusBarHeight)),
            // withZoom: true,
            withLocalStorage: true,
            // hidden: true,
            // initialChild: Container(
            //   color: Colors.redAccent,
            //   child: const Center(
            //     child: Text('Waiting.....'),
            //   ),
            // ),
          ),
        ),
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
