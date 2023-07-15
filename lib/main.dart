import 'package:flutter/material.dart';

import 'data/app_storage/app_storage_impl.dart';
import 'data/config_storage/config_storage_impl.dart';
import 'data/task_storage/local_storage_impl.dart';
import 'data/task_storage/network_storage_impl.dart';

import 'domain/tasks_repo.dart';

import 'presentation/navigation/router_delegate.dart';
import 'presentation/app.dart';

void main() {
  runApp(
    App(
      taskRepo: TasksRepository(
        storage: AppStorageImpl(
          localStorage: LocalStorageImpl(),
          netStorage: NetStorageImpl(),
          cfgStorage: ConfigStorageImpl(),
        ),
      ),
      routerDelegate: MyRouterDelegate(),
    ),
  );
}
