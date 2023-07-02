import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tododo/core/tasks_repo.dart';
import 'package:tododo/core/navigation.dart';
import 'package:tododo/core/themes.dart';

import 'package:tododo/utils/logger.dart';
import 'package:tododo/utils/s.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TasksRepository>(
      create: (context) => TasksRepository()..init(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        supportedLocales: S.supportedLocales,
        localizationsDelegates: S.localizationDelegates,
        title: 'ToDoDo',
        theme: lightTheme,
        scrollBehavior:
            const MaterialScrollBehavior().copyWith(scrollbars: false),
        navigatorKey: NavMan.key,
        routes: Routes.routes,
        initialRoute: Routes.load,
        navigatorObservers: [NavigatorLogger()],
      ),
    );
  }
}
