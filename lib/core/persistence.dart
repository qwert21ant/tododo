import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import 'package:tododo/model/task.dart';

class StorageMan {
  static const dbName = 'tasks.db';
  static late final Database _db;
  static final _store = StoreRef<String, Map<String, Object?>>.main();

  static init() async {
    final appDir = await getApplicationDocumentsDirectory();
    await appDir.create(recursive: true);

    _db = await databaseFactoryIo.openDatabase('${appDir.path}/$dbName');
  }

  static Future<List<TaskData>> getTasks() async {
    final data = await _store.find(_db);
    return data.map((item) => TaskData.fromJson(item.value)).toList();
  }

  static Future<void> setTasks(List<TaskData> tasks) async {
    await _store.delete(_db);

    for (final task in tasks) {
      await _store.record(task.id).add(_db, task.toJson());
    }
  }

  static Future<TaskData> getTask(String id) async {
    final data = await _store.record(id).get(_db);

    if (data == null) throw Exception('Not found');

    return TaskData.fromJson(data);
  }

  static Future<void> addTask(TaskData task) async {
    await _store.record(task.id).add(_db, task.toJson());
  }

  static Future<void> updateTask(TaskData task) async {
    await _store.record(task.id).update(_db, task.toJson());
  }

  static Future<void> deleteTask(String id) async {
    await _store.record(id).delete(_db);
  }
}
