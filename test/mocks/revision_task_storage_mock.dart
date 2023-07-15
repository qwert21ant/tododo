import 'package:tododo/data/task_storage/task_storage.dart';
import 'package:tododo/model/task.dart';

import 'task_storage_mock.dart';

class RevisionTaskStorageMock extends TaskStorageMock
    implements RevisionTaskStorage {
  @override
  int revision;

  RevisionTaskStorageMock(
    super.tasks,
    this.revision, [
    super.throwOnInit_,
    super.throwInMethods,
    super.delay,
  ]);

  @override
  Future<void> addTask(TaskData task) async {
    await super.addTask(task);
    revision++;
  }

  @override
  Future<void> deleteTask(String id) async {
    await super.deleteTask(id);
    revision++;
  }

  @override
  Future<void> setTasks(List<TaskData> tasks) async {
    await super.setTasks(tasks);
    revision++;
  }

  @override
  Future<void> updateTask(TaskData task) async {
    await super.updateTask(task);
    revision++;
  }
}
