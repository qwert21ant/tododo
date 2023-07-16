import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

import 'package:get_it/get_it.dart';

import 'package:tododo/services/firebase_services.dart';

import 'package:tododo/domain/tasks_repo.dart';

import 'package:tododo/presentation/theme/app_theme.dart';

import 'package:tododo/utils/s.dart';

import 'navigation/route_information_parser.dart';
import 'navigation/navigation_manager.dart';

class App extends StatelessWidget {
  final TasksRepository _taskRepo;

  final RouterDelegate<Object> _routerDelegate;
  final _routeInformationParser = MyRouteInformationParser();

  App({
    required TasksRepository taskRepo,
    required RouterDelegate<Object> routerDelegate,
    bool enableFirebaseServices = true,
    super.key,
  })  : _taskRepo = taskRepo,
        _routerDelegate = routerDelegate {
    GetIt.I.registerSingleton<NavMan>(NavMan(_routerDelegate));
    GetIt.I.registerSingleton<FirebaseServices>(
      FirebaseServices(enableFirebaseServices),
    );
  }

  Future<void> _init() async {
    await GetIt.I<FirebaseServices>().init();

    await _taskRepo.init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TasksRepository>(
      create: (context) {
        _init();
        return _taskRepo;
      },
      child: FlavorBanner(
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          supportedLocales: S.supportedLocales,
          localizationsDelegates: S.localizationDelegates,
          title: 'ToDoDo',
          theme: ThemeData(extensions: const [AppTheme.light]),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            extensions: const [AppTheme.dark],
          ),
          scrollBehavior:
              const MaterialScrollBehavior().copyWith(scrollbars: false),
          routerDelegate: _routerDelegate,
          routeInformationParser: _routeInformationParser,
        ),
      ),
    );
  }
}
