import 'package:intl/intl.dart';

import 'package:tododo/model/task.dart';

String formatDate(DateTime? date) =>
    date != null ? DateFormat('d MMMM y', 'ru').format(date) : '';

TaskImportance importanceFromString(String impStr) {
  if (impStr == 'basic') return TaskImportance.none;
  if (impStr == 'low') return TaskImportance.low;
  if (impStr == 'important') return TaskImportance.high;

  throw ArgumentError('Incorrect importance string: $impStr');
}

String importanceToString(TaskImportance imp) =>
    ['basic', 'low', 'important'][imp.index];

DateTime dateFromTimestamp(int timestamp) =>
    DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

int dateToTimestamp(DateTime date) => date.millisecondsSinceEpoch ~/ 1000;
