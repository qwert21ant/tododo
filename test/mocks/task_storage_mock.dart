import 'package:tododo/data/task_storage/task_storage.dart';

import 'package:tododo/model/task.dart';

import 'initializable_mock.dart';

class TaskStorageMock with InitializableMock implements TaskStorage {
  TaskStorageMock(
    this.tasks, [
    bool throwOnInit_ = false,
    this.throwInMethods = false,
    this.delay,
  ]) {
    throwOnInit = throwOnInit_;
  }

  List<TaskData> tasks;
  bool throwInMethods;
  Duration? delay;

  @override
  Future<void> addTask(TaskData task) async {
    if (delay != null) await Future.delayed(delay!);
    if (throwInMethods) throw Exception('Some method error');

    tasks.add(task.copy());
  }

  @override
  Future<void> deleteTask(String id) async {
    if (delay != null) await Future.delayed(delay!);
    if (throwInMethods) throw Exception('Some method error');

    final pos = tasks.indexWhere((item) => item.id == id);

    if (pos == -1) {
      throw Exception('Not found');
    }

    tasks.removeAt(pos);
  }

  @override
  Future<List<TaskData>> getTasks() async {
    if (delay != null) await Future.delayed(delay!);
    if (throwInMethods) throw Exception('Some method error');

    return tasks;
  }

  @override
  Future<void> setTasks(List<TaskData> tasks) async {
    if (delay != null) await Future.delayed(delay!);
    if (throwInMethods) throw Exception('Some method error');

    this.tasks = [for (final task in tasks) task.copy()];
  }

  @override
  Future<void> updateTask(TaskData task) async {
    if (delay != null) await Future.delayed(delay!);
    if (throwInMethods) throw Exception('Some method error');

    final pos = tasks.indexWhere((item) => item.id == task.id);

    if (pos == -1) {
      throw Exception('Not found');
    }

    tasks[pos] = task.copy();
  }
}
