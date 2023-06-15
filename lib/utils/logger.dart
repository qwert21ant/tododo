import 'dart:developer' as dev;

import 'package:flutter/widgets.dart';

abstract class Logger {
  static void log(String text) => dev.log(text);

  static void nav(String text) => dev.log(text, name: 'nav');
  static void state(String text) => dev.log(text, name: 'state');
  static void logic(String text) => dev.log(text, name: 'logic');
}

class NavigatorLogger extends NavigatorObserver {
  @override
  void didPop(Route route, Route? previousRoute) {
    Logger.nav('pop route: ${route.settings.name}');
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    Logger.nav('push route: ${route.settings.name}');
  }
}
