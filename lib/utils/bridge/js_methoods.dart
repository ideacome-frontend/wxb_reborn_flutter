import 'package:flutter/material.dart';
import 'package:wxb/WebPage.dart';
import 'package:wxb/common/Global.dart';
import 'package:wxb/routes/navigaiton_service.dart';
import 'package:wxb/routes/router_navigation.dart';
import 'package:wxb/store/app_bar.dart';
import 'package:app_settings/app_settings.dart';

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
  },
  "setNavBarVisibility": (params) async {
    bool hidden = params['hidden'] ?? true;
    $appBarStore.setAppBar(show: !hidden);
  },
  "closeWebView": (params) async {
    if (Global.webPages.length > 1) {
      NavigationService.goBack();
    }
  },
  "gotoAppSettings": (params) async {
    AppSettings.openAppSettings();
  },
});
