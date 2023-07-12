import 'package:flutter/material.dart';

import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:tododo/presentation/navigation/navigation_state.dart';

import 'package:tododo/utils/logger.dart';

class NavMan {
  final RouterDelegate _routerDelegate;

  NavMan(this._routerDelegate);

  void openPage(NavigationState state) {
    Logger.info('Open page ${state.name}', 'navigation');

    if (state.name == Routes.main) {
      FirebaseAnalytics.instance.logEvent(name: 'open_main_page');
    } else if (state.name == Routes.edit) {
      FirebaseAnalytics.instance.logEvent(
        name: 'open_edit_page',
        parameters: {
          'new_task': state.taskIndex == null ? 1 : 0,
        },
      );
    }

    _routerDelegate.setNewRoutePath(state);
  }

  void openMainPage() {
    Logger.info('Open main page', 'navigation');

    FirebaseAnalytics.instance.logEvent(name: 'open_main_page');

    _routerDelegate.setNewRoutePath(NavigationState(Routes.main));
  }

  void openEditPage([int? taskIndex]) {
    if (taskIndex == null) {
      Logger.info('Open edit page (new task)', 'navigation');
    } else {
      Logger.info('Open edit page (#$taskIndex task)', 'navigation');
    }

    FirebaseAnalytics.instance.logEvent(
      name: 'open_edit_page',
      parameters: {
        'new_task': taskIndex == null ? 1 : 0,
      },
    );

    _routerDelegate
        .setNewRoutePath(NavigationState(Routes.edit, taskIndex: taskIndex));
  }
}
