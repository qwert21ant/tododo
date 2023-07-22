import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'package:tododo/services/remote_configs.dart';

import 'package:tododo/utils/logger.dart';

import 'firebase_options.dart';

class FirebaseServices {
  FirebaseServices([bool enabled = true])
      : _enabled = enabled,
        configs = RemoteConfigs(enabled);

  bool _enabled;
  late final RemoteConfigs configs;

  Future<void> init() async {
    try {
      if (_enabled) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
    } catch (e) {
      Logger.warn('Firebase App init failure', 'services');
      _enabled = false;
    }

    FlutterError.onError = (details) {
      Logger.error('${details.exception}', 'error');

      if (_enabled) {
        FirebaseCrashlytics.instance.recordFlutterError(details);
      }
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      Logger.error('$error', 'error');

      if (_enabled) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      }

      return true;
    };

    await configs.init();
  }

  Future<void> logEvent(String name, [Map<String, dynamic>? param]) async {
    if (_enabled) {
      await FirebaseAnalytics.instance.logEvent(name: name, parameters: param);
    }
  }
}
