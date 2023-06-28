import 'package:flutter/material.dart';

import 'package:tododo/pages/main_page/main_page.dart';
import 'package:tododo/pages/edit_page/edit_page.dart';
import 'package:tododo/pages/load_page/load_page.dart';

abstract class Routes {
  static const String main = '/';
  static const String edit = '/edit';
  static const String load = '/load';

  static final Map<String, Widget Function(BuildContext)> routes = {
    main: (_) => const MainPage(),
    edit: (context) =>
        EditPage(taskIndex: ModalRoute.of(context)?.settings.arguments as int?),
    load: (_) => const LoadPage(),
  };
}

abstract class NavMan {
  static final key = GlobalKey<NavigatorState>();

  static NavigatorState get _nav => key.currentState!;

  static Future<dynamic> openEditPage([int? taskIndex]) =>
      _nav.pushNamed(Routes.edit, arguments: taskIndex);

  static Future<void> openMainPage() =>
      _nav.pushReplacementNamed(Routes.main);

  static void pop() => _nav.pop();
}
