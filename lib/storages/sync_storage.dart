import 'package:tododo/model/task.dart';

import 'package:tododo/utils/logger.dart';

import 'storage.dart';
import 'local_storage.dart';
import 'network_storage.dart';

// TODO: add stream for net queries
// Добавить чёт типа стрима для net запросов
// т.к. если часто тыкать то запросы кидаются не по порядку
// или просто revision не успевает обновляться

final class SyncStorage implements Storage {
  static final SyncStorage _instance = SyncStorage._();

  SyncStorage._();

  factory SyncStorage() => _instance;

  final LocalStorage _localStorage = LocalStorage();
  final NetStorage _netStorage = NetStorage();

  late int _revision;

  @override
  int get revision => _revision;

  Future<void> init() async {
    await _localStorage.init();
  }

  Future<void> _pushTasks() async {
    if (_netStorage.revision == _localStorage.revision) return;

    Logger.info('Push tasks', 'storage');

    // Костыль?
    // если ни разу не получали revision
    // то по умолчанию он равен -1, и тогда будем получать 400
    if (_netStorage.revision == -1) {
      // TODO: NetStorage.revision = -1
      try {
        await _netStorage.getTasks();
      } catch (_) {
        Logger.warn('Failed to push tasks', 'storage');
        return;
      }
    }

    final localTasks = await _localStorage.getTasks();
    try {
      await _netStorage.setTasks(localTasks);
      await _localStorage.setRevision(_netStorage.revision);
    } catch (_) {
      Logger.warn('Failed to push tasks', 'storage');
    }
  }

  Future<T> _doOper<T>(
    Future<T> Function() netOper,
    Future<T> Function() localOper,
  ) async {
    bool netSuccess = false;
    T? netResult;

    try {
      netResult = await netOper();
      netSuccess = true;
    } on NetException catch (e) {
      if (e.isUnsync) {
        await _pushTasks();

        try {
          netResult = await netOper();
          netSuccess = true;
        } catch (_) {}
      }
    } catch (_) {}

    T localResult = await localOper();

    if (!netSuccess) {
      Logger.warn('Failed to perform operation with sync', 'storage');
    } else {
      // нужно ли?
      _pushTasks(); // TODO: Maybe excess _pushTasks()
    }

    return netResult ?? localResult;
  }

  @override
  Future<List<TaskData>> getTasks() async {
    Logger.info('Get tasks', 'storage');

    final List<TaskData> netTasks;
    try {
      netTasks = await _netStorage.getTasks();
    } catch (_) {
      Logger.warn('Failed to get tasks from net', 'storage');
      return await _localStorage.getTasks();
    }

    if (_netStorage.revision == _localStorage.revision) return netTasks;

    Logger.info('Unsynchronized data', 'storage');
    Logger.info(
      'Revision before sync: net ${_netStorage.revision} <-> local ${_localStorage.revision}',
      'storage.sync',
    );

    final List<TaskData> result;

    final localTasks = await _localStorage.getTasks();

    if (_netStorage.revision < _localStorage.revision) {
      Logger.info('Sync: storage -> net', 'storage.sync');
      try {
        await _netStorage.setTasks(localTasks);
        result = localTasks;
      } catch (_) {
        Logger.warn('Failed to sync', 'storage.sync');
        return localTasks;
      }
    } else {
      Logger.info('Sync: net -> storage', 'storage.sync');
      await _localStorage.setTasks(netTasks);
      result = netTasks;
    }

    await _localStorage.setRevision(_netStorage.revision);

    Logger.info(
      'Revision after sync: net ${_netStorage.revision} <-> local ${_localStorage.revision}',
      'storage.sync',
    );

    return result;
  }

  @override
  Future<void> setTasks(List<TaskData> tasks) async {
    Logger.info('Set tasks, count: ${tasks.length}', 'storage');
    await _doOper(
      () => _netStorage.setTasks(tasks),
      () => _localStorage.setTasks(tasks),
    );
  }

  @override
  Future<TaskData> getTask(String id) async {
    Logger.info('Get task: $id', 'storage');
    return await _netStorage.getTask(id); // no sync for now
  }

  @override
  Future<void> addTask(TaskData task) async {
    Logger.info('Add task: ${task.id}', 'storage');
    await _doOper(
      () => _netStorage.addTask(task),
      () => _localStorage.addTask(task),
    );
  }

  @override
  Future<void> updateTask(TaskData task) async {
    Logger.info('Update task: ${task.id}', 'storage');
    await _doOper(
      () => _netStorage.updateTask(task),
      () => _localStorage.updateTask(task),
    );
  }

  @override
  Future<void> deleteTask(String id) async {
    Logger.info('Delete task: $id', 'storage');
    await _doOper(
      () => _netStorage.deleteTask(id),
      () => _localStorage.deleteTask(id),
    );
  }
}
