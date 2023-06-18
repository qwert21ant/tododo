import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/navigation.dart';
import 'core/themes.dart';
import 'core/task_man.dart';

import 'utils/logger.dart';

void main() {
  TaskMan.demo();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: const [Locale('en'), Locale('ru')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      title: 'ToDoDo',
      theme: lightTheme,
      scrollBehavior:
          const MaterialScrollBehavior().copyWith(scrollbars: false),
      navigatorKey: NavMan.key,
      routes: Routes.routes,
      initialRoute: Routes.home,
      navigatorObservers: [NavigatorLogger()],
    );
  }
}
