/**
 * 屏幕适配工具类
 * create by yanqiqi on 2019/09/12
 * email : 1204074417@qq.com
 */
import 'package:flutter/material.dart';

class ScreenUtil {
  static MediaQueryData mediaQuery;
  static double _width;
  static double _height;
  static double _topbarH; // 状态栏的高度,加上顶部的安全区域
  static double _botbarH = mediaQuery.padding.bottom; // ios的底部安全区域
  static double _pixelRatio = mediaQuery.devicePixelRatio;
  static double _textScaleFactor = mediaQuery.textScaleFactor;
  static var _ratio;
  static init(int number, BuildContext context) {
    mediaQuery = MediaQuery.of(context);
    _width = mediaQuery.size.width;
    _height = mediaQuery.size.height;
    _topbarH = mediaQuery.padding.top; // 状态栏的高度,加上顶部的安全区域
    _botbarH = mediaQuery.padding.bottom; // ios的底部安全区域
    _pixelRatio = mediaQuery.devicePixelRatio;
    _textScaleFactor = mediaQuery.textScaleFactor;
    int uiwidth = number is int ? number : 750;
    _ratio = _width / uiwidth;
  }

  static px2dp(number) {
    return number * _ratio;
  }

  static double get onepx {
    return 1 / _pixelRatio;
  }

  static double get screenW {
    return _width;
  }

  static double get screenH {
    return _height;
  }

  static double get statusBarHeight {
    return _topbarH;
  }

  static double get safeAreaHeight {
    return _botbarH;
  }

  // 按照系统的字体缩放指定文字大小
  static double fontSizeScale(double num) {
    return px2dp(num) / _textScaleFactor;
  }
}
