import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

import 'package:get_it/get_it.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:tododo/data/remote_configs.dart';

import 'package:tododo/firebase_options.dart';

import 'package:tododo/domain/tasks_repo.dart';

import 'package:tododo/presentation/theme/app_theme.dart';
import 'package:tododo/utils/logger.dart';

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
    super.key,
  })  : _taskRepo = taskRepo,
        _routerDelegate = routerDelegate {
    GetIt.I.registerSingleton<NavMan>(NavMan(_routerDelegate));
    GetIt.I.registerSingleton<RemoteConfigs>(RemoteConfigs());
  }

  Future<void> _init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FlutterError.onError = (details) {
      Logger.error('${details.exception}', 'error');

      FirebaseCrashlytics.instance.recordFlutterError(details);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      Logger.error('$error', 'error');

      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);

      return true;
    };

    await GetIt.I<RemoteConfigs>().init();

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
