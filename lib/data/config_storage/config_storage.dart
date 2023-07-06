import 'package:tododo/model/app_config.dart';

abstract interface class ConfigStorage {
  AppConfig get config;

  Future<void> init();

  Future<void> updateConfig(AppConfig newConfig);
}
