import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:get_it/get_it.dart';

import 'package:tododo/domain/tasks_repo.dart';
import 'package:tododo/presentation/pages/main_page/main_page.dart';

import 'package:tododo/presentation/themes.dart';

import 'package:tododo/utils/s.dart';

import 'navigation/router_delegate.dart';
import 'navigation/route_information_parser.dart';
import 'navigation/navigation_manager.dart';

class App extends StatelessWidget {
  final TasksRepository _taskRepo;

  final RouterDelegate<Object> _routerDelegate;
  final _routeInformationParser = MyRouteInformationParser();

  App({
    required TasksRepository taskRepo,
    required RouterDelegate<Object> routerDelegate,
    super.key,
  })  : _taskRepo = taskRepo,
        _routerDelegate = routerDelegate {
    GetIt.I.registerSingleton<NavMan>(NavMan(_routerDelegate));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TasksRepository>(
      create: (context) => _taskRepo..init(),
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
