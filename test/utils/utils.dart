import 'package:flutter_test/flutter_test.dart';

import 'package:tododo/model/task.dart';

Matcher equalTask(TaskData task) {
  return predicate<TaskData>((item) => item.isEqual(task));
}
