import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:tododo/utils/logger.dart';

class RemoteConfigs {
  RemoteConfigs([bool enabled = true]) : _enabled = enabled;

  bool _enabled;

  static const String _importanceFigmaColorField = 'importance_figma_color';

  Future<void> init() async {
    if (!_enabled) return;

    try {
      await FirebaseRemoteConfig.instance.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(minutes: 2),
        ),
      );

      await FirebaseRemoteConfig.instance.setDefaults({
        _importanceFigmaColorField: true,
      });

      await FirebaseRemoteConfig.instance.fetchAndActivate();
    } catch (e) {
      Logger.warn('Firebase Remote Config init failure', 'services');
      _enabled = false;
    }
  }

  bool get importanceFigmaColor => _enabled
      ? FirebaseRemoteConfig.instance.getBool(_importanceFigmaColorField)
      : true;
}
