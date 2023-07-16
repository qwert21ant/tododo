import 'package:flutter/material.dart';

import 'package:flutter_flavor/flutter_flavor.dart';

import 'data/app_storage/app_storage_impl.dart';
import 'data/config_storage/config_storage_impl.dart';
import 'data/task_storage/local_storage_impl.dart';
import 'data/task_storage/network_storage_impl.dart';

import 'domain/tasks_repo.dart';

import 'presentation/navigation/router_delegate.dart';
import 'presentation/app.dart';

import 'utils/logger.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  String flavor = const String.fromEnvironment('FLAVOR');
  if (flavor == 'DEV') {
    Logger.info('DEV flavor', 'info');
    FlavorConfig(
      name: 'DEV',
      color: Colors.red,
      location: BannerLocation.topEnd,
    );
  }

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
      enableFirebaseServices: true,
    ),
  );
}
