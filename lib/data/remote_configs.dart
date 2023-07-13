import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigs {
  RemoteConfigs();

  static const String importanceFigmaColorField = 'importance_figma_color';

  Future<void> init() async {
    await FirebaseRemoteConfig.instance.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(minutes: 2),
      ),
    );

    await FirebaseRemoteConfig.instance.setDefaults({
      importanceFigmaColorField: true,
    });

    await FirebaseRemoteConfig.instance.fetchAndActivate();
  }

  bool get importanceFigmaColor {
    bool x = FirebaseRemoteConfig.instance.getBool(importanceFigmaColorField);
    print('value: $x');

    return x;
  }
}
