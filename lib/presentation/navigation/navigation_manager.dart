import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';

import 'package:tododo/presentation/navigation/navigation_state.dart';

import 'package:tododo/services/firebase_services.dart';

import 'package:tododo/utils/logger.dart';

class NavMan {
  final RouterDelegate _routerDelegate;

  NavMan(this._routerDelegate);

  void openPage(NavigationState state) {
    Logger.info('Open page ${state.name}', 'navigation');

    if (state.name == Routes.main) {
      GetIt.I<FirebaseServices>().logEvent('open_main_page');
    } else if (state.name == Routes.edit) {
      GetIt.I<FirebaseServices>().logEvent(
        'open_edit_page',
        {'new_task': state.taskIndex == null ? 1 : 0},
      );
    }

    _routerDelegate.setNewRoutePath(state);
  }

  void openMainPage() {
    Logger.info('Open main page', 'navigation');

    GetIt.I<FirebaseServices>().logEvent('open_main_page');

    _routerDelegate.setNewRoutePath(NavigationState(Routes.main));
  }

  void openEditPage([int? taskIndex]) {
    if (taskIndex == null) {
      Logger.info('Open edit page (new task)', 'navigation');
    } else {
      Logger.info('Open edit page (#$taskIndex task)', 'navigation');
    }

    GetIt.I<FirebaseServices>().logEvent(
      'open_edit_page',
      {'new_task': taskIndex == null ? 1 : 0},
    );

    _routerDelegate
        .setNewRoutePath(NavigationState(Routes.edit, taskIndex: taskIndex));
  }
}
