import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:wxb/common/host_info.dart';

const _themes = <MaterialColor>[
  Colors.blue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.red,
];

class Global {
  // static SharedPreferences _prefs;
  // static Profile profile = Profile();
  // // 网络缓存对象
  // static NetCache netCache = NetCache();

  // 可选的主题列表
  static List<MaterialColor> get themes => _themes;

  // 是否为release版
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  static HostInfo _hostInfo;

  static HostInfo get hostInfo => _hostInfo;

  static initHostInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (Platform.isIOS) {
      final isoInfo = await deviceInfo.iosInfo;
      _hostInfo = new HostInfo(isoInfo.systemName, packageInfo.version, isoInfo.systemVersion);
      print(_hostInfo.toJson());
    }
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      _hostInfo = new HostInfo("Android", packageInfo.version, androidInfo.version.release);
    }
  }

  //初始化全局信息，会在APP启动时执行
  // static Future init() async {
  //   _prefs = await SharedPreferences.getInstance();
  //   var _profile = _prefs.getString("profile");
  //   if (_profile != null) {
  //     try {
  //       profile = Profile.fromJson(jsonDecode(_profile));
  //     } catch (e) {
  //       print(e);
  //     }
  //   }

  //   // 如果没有缓存策略，设置默认缓存策略
  //   profile.cache = profile.cache ?? CacheConfig()
  //     ..enable = true
  //     ..maxAge = 3600
  //     ..maxCount = 100;

  //   //初始化网络请求相关配置
  //   Git.init();
  // }

  // 持久化Profile信息
  // static saveProfile() => _prefs.setString("profile", jsonEncode(profile.toJson()));

}
