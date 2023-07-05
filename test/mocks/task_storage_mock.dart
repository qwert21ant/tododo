import 'package:tododo/data/task_storage/task_storage.dart';

import 'package:tododo/model/task.dart';

class TaskStorageMock implements TaskStorage {
  TaskStorageMock(this.tasks, {bool? throwOnInit})
      : _throwOnInit = throwOnInit ?? false;

  final bool _throwOnInit;

  List<TaskData> tasks;
  bool isInit = false;

  @override
  Future<void> addTask(TaskData task) async {
    tasks.add(task.copy());
  }

  @override
  Future<void> deleteTask(String id) async {
    final pos = tasks.indexWhere((item) => item.id == id);

    if (pos == -1) {
      throw Exception('Not found');
    }

    tasks.removeAt(pos);
  }

  @override
  Future<List<TaskData>> getTasks() async => tasks;

  @override
  Future<void> init() async {
    isInit = true;

    if (_throwOnInit) throw Exception('Init error');
  }

  @override
  Future<void> setTasks(List<TaskData> tasks) async {
    this.tasks = [for (final task in tasks) task.copy()];
  }

  @override
  Future<void> updateTask(TaskData task) async {
    final pos = tasks.indexWhere((item) => item.id == task.id);

    if (pos == -1) {
      throw Exception('Not found');
    }

    tasks[pos] = task.copy();
  }
}
