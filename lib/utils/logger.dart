import 'dart:developer' as dev;

enum Level { info, warning, error }

abstract class Logger {
  static void _log(String text, String group, [Level level = Level.info]) =>
      dev.log('${['⚪', '🟡', '🔴'][level.index]} $text', name: 'my.$group');

  static void info(String text, String group) => _log(text, group);

  static void warn(String text, String group) =>
      _log(text, group, Level.warning);

  static void error(String text, String group) =>
      _log(text, group, Level.error);
}
