import 'package:tododo/model/task.dart';

abstract interface class TaskStorage {
  Future<void> init();

  Future<List<TaskData>> getTasks();

  Future<void> setTasks(List<TaskData> tasks);

  Future<void> addTask(TaskData task);

  Future<void> updateTask(TaskData task);

  Future<void> deleteTask(String id);
}

abstract interface class RevisionTaskStorage extends TaskStorage {
  int get revision;

  set revision(int newRevision);
}
