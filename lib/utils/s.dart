import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

import 'logger.dart';

class S {
  static const supportedLocales = [Locale('ru'), Locale('en')];
  static final localizationDelegates = [
    GlobalWidgetsLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    MyLocalizationDelegate()
  ];

  static S of(BuildContext context) => Localizations.of<S>(context, S)!;

  final Locale _locale;

  Locale get locale => _locale;

  final Map<String, String> _data;

  S._(Locale locale, Map<String, String> data)
      : _locale = locale,
        _data = data;

  String operator [](String key) {
    if (_data[key] == null) {
      Logger.warn('String $key not found', 's');
    }
    return _data[key] ?? 'no string';
  }
}

class MyLocalizationDelegate extends LocalizationsDelegate<S> {
  @override
  bool isSupported(Locale locale) {
    return S.supportedLocales.contains(locale);
  }

  @override
  Future<S> load(Locale locale) async {
    final data =
        await rootBundle.loadString('l10n/${locale.languageCode}.json');

    final Map<String, dynamic> map = jsonDecode(data);

    return S._(
      locale,
      map.map<String, String>(
        (key, value) => MapEntry(key, value as String),
      ),
    );
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate old) => false;
}
