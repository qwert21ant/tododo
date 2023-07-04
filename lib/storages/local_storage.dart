import 'package:path_provider/path_provider.dart';

import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import 'package:tododo/model/task.dart';

import 'storage.dart';

final class LocalStorage implements Storage {
  static const dbName = 'tasks.db';

  LocalStorage();

  late final Database _db;
  final _store = StoreRef<String, Map<String, Object?>>.main();

  late int _revision;

  bool _wasOnline = false;
  bool get wasOnline => _wasOnline;

  @override
  int get revision => _revision;

  Map<String, Object> get _config =>
      {'revision': _revision, 'wasOnline': _wasOnline};

  final Finder _tasksFinder = Finder(
    filter: Filter.not(Filter.byKey('config')),
  );

  Future<void> _updateConfig() async {
    await _store.record('config').update(_db, _config);
  }

  Future<void> setRevision(int revision) async {
    _revision = revision;
    await _updateConfig();
  }

  Future<void> incRevision() async {
    await setRevision(_revision + 1);
  }

  Future<void> setOnlineStatus(bool status) async {
    _wasOnline = status;
    _updateConfig();
  }

  Future<void> init() async {
    final appDir = await getApplicationDocumentsDirectory();
    await appDir.create(recursive: true);

    _db = await databaseFactoryIo.openDatabase('${appDir.path}/$dbName');

    final data = await _store.record('config').get(_db);

    if (data == null) {
      _revision = 0;
      _wasOnline = false;
      await _store.record('config').add(_db, _config);
    } else {
      _revision = data['revision'] as int;
      _wasOnline = data['wasOnline'] as bool;
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
    await _store.record('config').add(_db, _config);
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
    // await incRevision();
  }

  @override
  Future<void> updateTask(TaskData task) async {
    await _store.record(task.id).update(_db, task.toJson());
    // await incRevision();
  }

  @override
  Future<void> deleteTask(String id) async {
    await _store.record(id).delete(_db);
    // await incRevision();
  }
}
