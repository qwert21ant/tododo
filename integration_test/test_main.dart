import 'package:flutter/material.dart';

import 'package:tododo/domain/tasks_repo.dart';

import 'package:tododo/presentation/app.dart';

void myRunApp(TasksRepository repo, RouterDelegate<Object> routerDelegate) {
  runApp(
    App(
      taskRepo: repo,
      routerDelegate: routerDelegate,
      enableFirebaseServices: false,
    ),
  );
}
