import 'package:flutter_test/flutter_test.dart';

import 'package:tododo/model/task.dart';

Matcher equalTask(TaskData task) {
  return predicate<TaskData>((item) => item.isEqual(task));
}

void expectAll<T>(List<T> mocks, void Function(T mock) func) {
  for (final mock in mocks) {
    func(mock);
  }
}

void expectFindTask(List<TaskData> tasks, TaskData task) {
  expect(tasks, anyElement(equalTask(task)));
}

void expectNotFindTask(List<TaskData> tasks, TaskData task) {
  expect(tasks, isNot(anyElement(equalTask(task))));
}

void expectSameTasks(List<TaskData> actual, List<TaskData> matcher) {
  expect(actual, hasLength(matcher.length));
  for (final task in actual) {
    expect(matcher, anyElement(equalTask(task)));
  }
}
