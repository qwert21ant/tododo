import 'package:tododo/presentation/navigation/navigation_state.dart';
import 'package:tododo/utils/logger.dart';

import 'router_delegate.dart';

class NavMan {
  final MyRouterDelegate _routerDelegate;

  NavMan(this._routerDelegate);

  void openPage(NavigationState state) {
    Logger.info('Open page ${state.name}', 'navigation');

    _routerDelegate.setNewRoutePath(state);
  }

  void openMainPage() {
    Logger.info('Open main page', 'navigation');

    _routerDelegate.setNewRoutePath(NavigationState(Routes.main));
  }

  void openEditPage([int? taskIndex]) {
    if (taskIndex == null) {
      Logger.info('Open edit page (new task)', 'navigation');
    } else {
      Logger.info('Open edit page (#$taskIndex task)', 'navigation');
    }

    _routerDelegate
        .setNewRoutePath(NavigationState(Routes.edit, taskIndex: taskIndex));
  }
}
