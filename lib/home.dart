import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
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

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
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
    );
  }
}
