import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wxb/home.dart';
import 'package:wxb/pages/demo/test.dart';
import 'package:wxb/webview_ext.dart';

///命名路由
///如果需要传参,请加上arguments可选参数
final routes = {
  '/': (context) => HomePage(),
  '/test': (context, {arguments}) => TestPage(),
  '/newwebview': (context, {arguments}) => WebviewExt(
        url: arguments['url'],
        showNavBar: arguments['showNavBar'],
        key: UniqueKey(),
      ),
};

var onGenerateRoute = (RouteSettings settings) {
  // 统一处理 并指定ios风格动画
  final String name = settings.name;
  final Function pageContentBuilder = routes[name];
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = CupertinoPageRoute(
          fullscreenDialog: false, builder: (context) => pageContentBuilder(context, arguments: settings.arguments));
      return route;
    } else {
      final Route route =
          CupertinoPageRoute(fullscreenDialog: false, builder: (context) => pageContentBuilder(context));
      return route;
    }
  }
};
