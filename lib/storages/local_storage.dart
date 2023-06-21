import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import 'package:tododo/model/task.dart';

import 'storage.dart';

final class LocalStorage implements Storage {
  static const dbName = 'tasks.db';

  static final LocalStorage _instance = LocalStorage._();

  LocalStorage._();

  factory LocalStorage() => _instance;

  late final Database _db;
  final _store = StoreRef<String, Map<String, Object?>>.main();

  late int _revision;

  @override
  get revision => _revision;

  final Finder _tasksFinder = Finder(
    filter: Filter.not(Filter.byKey('revision')),
  );

  Future<void> setRevision(int revision) async {
    await _store.record('revision').update(_db, {'revision': revision});
  }

  Future<void> incRevision() async {
    _revision++;
    await setRevision(_revision);
  }

  Future<void> init() async {
    final appDir = await getApplicationDocumentsDirectory();
    await appDir.create(recursive: true);

    _db = await databaseFactoryIo.openDatabase('${appDir.path}/$dbName');

    final data = await _store.record('revision').get(_db);

    if (data == null) {
      _revision = 0;
      await _store.record('revision').add(_db, {'revision': 0});
    } else {
      _revision = data['revision'] as int;
    }
  }

  @override
  Future<List<TaskData>> getTasks() async {
    final data = await _store.find(_db, finder: _tasksFinder);
    return data.map((item) => TaskData.fromJson(item.value)).toList();
  }

  @override
  Future<void> setTasks(List<TaskData> tasks) async {
    await _store.delete(_db);

    for (final task in tasks) {
      await _store.record(task.id).add(_db, task.toJson());
    }

    _revision++;
    await _store.record('revision').add(_db, {'revision': _revision});
  }

  @override
  Future<TaskData> getTask(String id) async {
    final data = await _store.record(id).get(_db);

    if (data == null) throw Exception('Not found');

    return TaskData.fromJson(data);
  }

  @override
  Future<void> addTask(TaskData task) async {
    await _store.record(task.id).add(_db, task.toJson());
    await incRevision();
  }

  @override
  Future<void> updateTask(TaskData task) async {
    await _store.record(task.id).update(_db, task.toJson());
    await incRevision();
  }

  @override
  Future<void> deleteTask(String id) async {
    await _store.record(id).delete(_db);
    await incRevision();
  }
}
