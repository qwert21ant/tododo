import 'package:path_provider/path_provider.dart';

import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import 'package:tododo/model/task.dart';

import 'task_storage.dart';

final class LocalStorageImpl implements RevisionTaskStorage {
  static const dbName = 'tasks.db';

  LocalStorageImpl();

  late final Database _db;
  final _store = StoreRef<String, Map<String, Object?>>.main();

  late int _revision;

  @override
  int get revision => _revision;

  @override
  set revision(int newRevision) {
    _revision = newRevision;
  }

  @override
  Future<void> init() async {
    final appDir = await getApplicationDocumentsDirectory();
    await appDir.create(recursive: true);

    _db = await databaseFactoryIo.openDatabase('${appDir.path}/$dbName');

    await _store.record('config').delete(_db);
  }

  @override
  Future<List<TaskData>> getTasks() async {
    final data = await _store.find(_db);
    return data.map((item) => TaskData.fromJson(item.value)).toList();
  }

  @override
  Future<void> setTasks(List<TaskData> tasks) async {
    await _store.delete(_db);

    for (final task in tasks) {
      await _store.record(task.id).add(_db, task.toJson());
    }

    _revision++;
  }

  @override
  Future<void> addTask(TaskData task) async {
    await _store.record(task.id).add(_db, task.toJson());
    _revision++;
  }

  @override
  Future<void> updateTask(TaskData task) async {
    await _store.record(task.id).update(_db, task.toJson());
    _revision++;
  }

  @override
  Future<void> deleteTask(String id) async {
    await _store.record(id).delete(_db);
    _revision++;
  }
}
