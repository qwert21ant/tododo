import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tododo/presentation/pages/main_page/main_page.dart';
import 'package:tododo/presentation/pages/edit_page/edit_page.dart';
import 'package:tododo/presentation/pages/load_page/load_page.dart';

import 'package:tododo/utils/logger.dart';

import 'navigation_provider.dart';
import 'navigation_state.dart';

class MyRouterDelegate extends RouterDelegate<NavigationState>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<NavigationState> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  MyRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  NavigationState? state;

  @override
  NavigationState get currentConfiguration {
    return state ?? NavigationState(Routes.load);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [];

    if (state != null) {
      if (state!.name == Routes.load) {
        pages.add(const LoadPage());
      } else {
        pages.add(const MainPage());

        if (state!.name == Routes.edit) {
          pages.add(EditPage(taskIndex: state!.taskIndex));
        }
      }
    } else {
      pages.add(const LoadPage());
    }

    return RepositoryProvider(
      create: (context) => NavigationProvider(
        _openMainPage,
        _openEditPage,
        _pop,
      ),
      child: Navigator(
        key: navigatorKey,
        pages: pages.map<Page>((page) => MaterialPage(child: page)).toList(),
        onPopPage: (route, result) {
          if (!route.didPop(result)) return false;

          state = NavigationState(Routes.main);

          notifyListeners();
          return true;
        },
      ),
    );
  }

  @override
  Future<void> setNewRoutePath(NavigationState configuration) async {
    state = configuration;
    notifyListeners();
  }

  void _openMainPage() {
    Logger.info('Open main page', 'navigation');

    state = NavigationState(Routes.main);
    notifyListeners();
  }

  void _openEditPage([int? taskIndex]) {
    if (taskIndex == null) {
      Logger.info('Open edit page (new task)', 'navigation');
    } else {
      Logger.info('Open edit page (#$taskIndex task)', 'navigation');
    }

    state = NavigationState(Routes.edit, taskIndex: taskIndex);
    notifyListeners();
  }

  void _pop() {
    Logger.info('Pop page', 'navigation');

    if (state!.name == Routes.edit) {
      state = NavigationState(Routes.main);
    }

    notifyListeners();
  }
}
