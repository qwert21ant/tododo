import 'package:tododo/model/task.dart';

abstract interface class Storage {
  get revision;

  Future<List<TaskData>> getTasks();

  Future<void> setTasks(List<TaskData> tasks);

  Future<TaskData> getTask(String id);

  Future<void> addTask(TaskData task);

  Future<void> updateTask(TaskData task);

  Future<void> deleteTask(String id);
}
