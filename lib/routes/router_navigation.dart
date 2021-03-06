import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wxb/common/Global.dart';
import 'package:wxb/routes/navigaiton_service.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class NoAnimationPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationPageRoute({WidgetBuilder builder}) : super(builder: builder);

  @override
  Widget buildTransitions(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}

Future<T> pushWithoutAnimationClearStack<T extends Object>(Widget page, ctx) {
  Route route = NoAnimationPageRoute(builder: (BuildContext context) => page);
  return Navigator.pushAndRemoveUntil(ctx, route, (Route<dynamic> route) => false);
}

Future<T> pushWithoutAnimation<T extends Object>(Widget page, ctx) {
  Route route = NoAnimationPageRoute(builder: (BuildContext context) => page);
  return Navigator.push(ctx, route);
}

/// ios风格的路由跳转
Future<T> pushWithCupertino<T extends Object>(Widget page, ctx) {
  return Navigator.push(
    ctx,
    CupertinoPageRoute(
      fullscreenDialog: false,
      builder: (context) => page,
    ),
  );
}

Future<dynamic> pushNamedAutoWebview<T extends Object>(Widget page) {
  Global.webPages.last.hide();
  Route route = NoAnimationPageRoute(builder: (BuildContext context) => page);
  return NavigationService.navigateTo(route).then((value) => Global.webPages[Global.webPages.length - 2].show());
}
