import 'package:flutter/material.dart';
import 'package:wxb/WebPage.dart';
import 'package:wxb/common/Global.dart';
import 'package:wxb/routes/navigaiton_service.dart';
import 'package:wxb/routes/router_navigation.dart';

typedef CallMethods = Future<String> Function(dynamic params);
final jsMethods = Map<String, CallMethods>.from({
  "openNewWebView": (params) async {
    String url = params["url"];
    bool navBarHidden = params['navBarHidden'] ?? false;
    Global.webPages.last.hide();
    pushNamedAutoWebview(new WebPage(
      url: url,
      showNavBar: !navBarHidden,
      key: UniqueKey(),
    ));
    // NavigationService.navigatorKey.currentState.pushNamed('/web', arguments: {
    //   "url": url,
    //   "showNavBar": !navBarHidden,
    // }).then((value) {
    //   try {
    //     Global.webPages[Global.webPages.length - 2].show();
    //   } catch (e) {}
    // });
  },
});
