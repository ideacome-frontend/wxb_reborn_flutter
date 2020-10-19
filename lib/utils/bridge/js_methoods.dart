import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
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
  "saveImage": (params) async {
    String url = params["url"];
    if (Platform.isAndroid) {
      if (!await Permission.storage.request().isGranted) {
        return;
      }
    }
    Uint8List imageBytes;
    if (url.contains('http')) {
      var response = await new Dio().get(url, options: Options(responseType: ResponseType.bytes));
      imageBytes = Uint8List.fromList(response.data);
    } else {
      // base64 转字节
      imageBytes = base64Decode(url.split(',')[1]);
    }
    await ImageGallerySaver.saveImage(imageBytes, name: "wxb_img_" + new DateTime.now().toString());
  }
});
