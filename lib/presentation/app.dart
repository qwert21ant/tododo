import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:get_it/get_it.dart';

import 'package:tododo/domain/tasks_repo.dart';

import 'package:tododo/presentation/themes.dart';

import 'package:tododo/data/app_storage/app_storage_impl.dart';
import 'package:tododo/data/config_storage/config_storage_impl.dart';
import 'package:tododo/data/task_storage/local_storage_impl.dart';
import 'package:tododo/data/task_storage/network_storage_impl.dart';

import 'package:tododo/utils/s.dart';

import 'navigation/router_delegate.dart';
import 'navigation/route_information_parser.dart';
import 'navigation/navigation_manager.dart';

class App extends StatelessWidget {
  final _routerDelegate = MyRouterDelegate();
  final _routeInformationParser = MyRouteInformationParser();
  final _taskRepo = TasksRepository(
    storage: AppStorageImpl(
      localStorage: LocalStorageImpl(),
      netStorage: NetStorageImpl(),
      cfgStorage: ConfigStorageImpl(),
    ),
  );

  App({super.key}) {
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
