import 'package:flutter/material.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Future<T> navigateTo<T>(Route<T> route) {
    return navigatorKey.currentState.push<T>(route);
  }

  static void goBack() {
    return navigatorKey.currentState.pop();
  }

  static BuildContext get getContext {
    return navigatorKey.currentState.overlay.context;
  }
}
