import 'package:flutter/material.dart';

import '../pages/edit_page/edit_page.dart';
import '../pages/main_page/main_page.dart';

abstract class Routes {
  static const String home = '/';
  static const String edit = '/edit';

  static final Map<String, Widget Function(BuildContext)> routes = {
    home: (_) => const MainPage(),
    edit: (context) =>
        EditPage(taskIndex: ModalRoute.of(context)?.settings.arguments as int?)
  };
}

abstract class NavMan {
  static final key = GlobalKey<NavigatorState>();

  static NavigatorState get _nav => key.currentState!;

  static Future<dynamic> openEditPage([int? taskIndex]) =>
      _nav.pushNamed(Routes.edit, arguments: taskIndex);

  static void pop() => _nav.pop();
}
