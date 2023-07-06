import 'package:tododo/data/config_storage/config_storage.dart';

import 'package:tododo/model/app_config.dart';

import 'initializable_mock.dart';

class ConfigStorageMock with InitializableMock implements ConfigStorage {
  ConfigStorageMock(AppConfig config, [bool throwOnInit_ = false])
      : _config = config {
    throwOnInit = throwOnInit_;
  }

  AppConfig _config;

  @override
  AppConfig get config => _config;

  set config(AppConfig newCfg) {
    _config = newCfg;
  }

  @override
  Future<void> updateConfig(AppConfig newConfig) async {
    _config = newConfig;
  }
}
