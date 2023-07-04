import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tododo/core/tasks_repo.dart';
import 'package:tododo/core/themes.dart';

import 'package:tododo/utils/s.dart';

import 'navigation/router_delegate.dart';
import 'navigation/route_information_parser.dart';

class App extends StatelessWidget {
  final _routerDelegate = MyRouterDelegate();
  final _routeInformationParser = MyRouteInformationParser();

  App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TasksRepository>(
      create: (context) => TasksRepository()..init(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        supportedLocales: S.supportedLocales,
        localizationsDelegates: S.localizationDelegates,
        title: 'ToDoDo',
        theme: lightTheme,
        scrollBehavior:
            const MaterialScrollBehavior().copyWith(scrollbars: false),
        routerDelegate: _routerDelegate,
        routeInformationParser: _routeInformationParser,
      ),
    );
  }
}
