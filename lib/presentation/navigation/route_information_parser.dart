import 'package:flutter/material.dart';

import 'package:tododo/utils/logger.dart';

import 'navigation_state.dart';

class MyRouteInformationParser extends RouteInformationParser<NavigationState> {
  @override
  Future<NavigationState> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final location = routeInformation.location;

    Logger.info('Parse location: $location', 'navigation');

    if (location == null) {
      return NavigationState(Routes.main);
    }

    final uri = Uri.parse(location);

    if (uri.pathSegments.length == 1 && uri.pathSegments[0] == 'new') {
      return NavigationState(Routes.edit);
    }

    return NavigationState(Routes.main);
  }

  @override
  RouteInformation? restoreRouteInformation(NavigationState configuration) {
    if (configuration.name == Routes.edit) {
      return const RouteInformation(location: '/new');
    }

    return const RouteInformation(location: '/');
  }
}
