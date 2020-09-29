import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:wxb/common/Global.dart';
import 'package:wxb/home.dart';
import 'package:wxb/routes/navigaiton_service.dart';
import 'package:wxb/utils/screen_util.dart';
import 'package:wxb/routes/routes.dart' as Routes;

void main() {
  // 设置设备方向只允许垂直方向
  WidgetsFlutterBinding.ensureInitialized();
  Global.initHostInfo();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp());
  });
  if (Platform.isAndroid) {
    //设置Android头部的导航栏透明
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarBrightness: Brightness.dark);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        onGenerateRoute: Routes.onGenerateRoute,
        debugShowCheckedModeBanner: false,
        title: '喂小保',
        navigatorKey: NavigationService.navigatorKey,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        locale: Locale('zh', 'CH'),
        localizationsDelegates: [
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('zh', 'CH'),
        ],
        home: Builder(builder: (ctx) {
          ScreenUtil.init(750, ctx);
          return HomePage();
        }));
  }
}
