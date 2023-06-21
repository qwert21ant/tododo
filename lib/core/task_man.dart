import 'package:flutter/foundation.dart';

import 'package:tododo/model/task.dart';
import 'package:tododo/utils/logger.dart';

import 'package:tododo/storages/network_storage.dart';
import 'package:tododo/storages/local_storage.dart';

final class TaskMan {
  static final List<TaskData> tasks = [];
  static final ValueNotifier<int> doneCount = ValueNotifier<int>(0);

  static final NetStorage _netStorage = NetStorage();
  static final LocalStorage _localStorage = LocalStorage();

  static void _updateTasks(List<TaskData> newTasks) {
    tasks.clear();
    tasks.addAll(newTasks);

    doneCount.value =
        tasks.fold(0, (count, task) => count + (task.isDone ? 1 : 0));
  }

  static Future<void> init() async {
    await _localStorage.init();
  }

  static Future<void> load() async {
    final List<TaskData> netTasks;

    try {
      netTasks = await _netStorage.getTasks();
      Logger.data('Successfully load from net');

      Logger.data(
        'revisions: net ${_netStorage.revision} <-> local ${_localStorage.revision}',
      );

      if (_netStorage.revision != _localStorage.revision) {
        Logger.data('Unsynchronized data');

        final storageTasks = await _localStorage.getTasks();

        if (_netStorage.revision < _localStorage.revision) {
          Logger.data('Sync: storage -> net');
          await _netStorage.setTasks(storageTasks);
          _updateTasks(storageTasks);
        } else {
          Logger.data('Sync: net -> storage');
          await _localStorage.setTasks(netTasks);
          _updateTasks(netTasks);
        }

        await _localStorage.setRevision(_netStorage.revision);
      } else {
        _updateTasks(netTasks);
      }
    } on NetException catch (_) {
      Logger.data('Unable to load from net, load from storage');
      _updateTasks(await _localStorage.getTasks());
    }
  }

  static void addTask(TaskData task) {
    Logger.data('add new task: ${task.id}');

    if (task.isDone) doneCount.value++;

    tasks.add(task);
    _netStorage.addTask(task);
  }

  // except isDone
  static void changeTask(int index, TaskData task) {
    Logger.data('change task ${task.id}');

    tasks[index].text = task.text;
    tasks[index].importance = task.importance;
    tasks[index].date = task.date;

    _netStorage.updateTask(tasks[index]);
  }

  static void switchDone(int index) {
    Logger.data('switch isDone state: ${tasks[index].id}');

    if (tasks[index].isDone) {
      doneCount.value--;
    } else {
      doneCount.value++;
    }
    tasks[index].isDone = !tasks[index].isDone;

    _netStorage.updateTask(tasks[index]);
  }

  static void removeTask(int index) {
    Logger.data('remove task ${tasks[index].id}');

    _netStorage.deleteTask(tasks[index].id);

    if (tasks[index].isDone) doneCount.value--;
    tasks.removeAt(index);
  }

  static void demo() {
    tasks.clear();

    tasks.addAll([
      TaskData(text: 'Купить что-то', isDone: true),
      TaskData(text: 'Купить что-то', isDone: true),
      TaskData(text: 'Купить что-то'),
      TaskData(
        text: 'Купить что-то, где-то, зачем-то, но зачем не очень понятно',
      ),
      TaskData(
        text:
            'Купить что-то, где-то, зачем-то, но зачем не очень понятно, но точно чтобы показать как обрезается текст',
      ),
      TaskData(text: 'Купить что-то', importance: TaskImportance.high),
      TaskData(text: 'Купить что-то', importance: TaskImportance.low),
      TaskData(text: 'Купить что-то', date: DateTime.now()),
      TaskData(text: 'Купить что-то', isDone: true),
      TaskData(
        text:
            '''Фьючерсный контракт — это договор между покупателем и продавцом о покупке/продаже какого-то актива в будущем. Стороны заранее оговаривают, через какой срок и по какой цене состоится сделка.
          Например, сейчас одна акция «Лукойла» стоит около 5700 рублей. Фьючерс на акции «Лукойла» — это, например, договор между покупателем и продавцом о том, что покупатель купит акции «Лукойла» у продавца по цене 5700 рублей через 3 месяца. При этом не важно, какая цена будет у акций через 3 месяца: цена сделки между покупателем и продавцом все равно останется 5700 рублей. Если реальная цена акции через три месяца не останется прежней, одна из сторон в любом случае понесет убытки.''',
      ),
    ]);

    doneCount.value = 3;
  }

  static void demo2() {
    tasks.clear();

    tasks.addAll([
      for (int i = 0; i < 10; i++)
        TaskData(text: i.toString(), isDone: i % 2 == 0)
    ]);

    doneCount.value = 5;
  }
}
