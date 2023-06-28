import 'package:flutter/material.dart';

import 'core/navigation.dart';
import 'core/task_man.dart';
import 'core/themes.dart';

import 'utils/logger.dart';
import 'utils/s.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}
