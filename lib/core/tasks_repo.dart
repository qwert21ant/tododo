import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tododo/model/task.dart';

import 'package:tododo/storages/sync_storage.dart';

import 'package:tododo/utils/utils.dart';
import 'package:tododo/utils/logger.dart';

class TasksState {
  final List<TaskData> tasks;
  final int doneCount;
  final bool isInitialized;
  final bool hasInitError;

  TasksState({
    required this.tasks,
    required this.isInitialized,
    required this.hasInitError,
  }) : doneCount =
            tasks.fold<int>(0, (count, task) => count + (task.isDone ? 1 : 0));

  TasksState copyWith({
    List<TaskData>? tasks,
    bool? isInitialized,
    bool? hasInitError,
  }) =>
      TasksState(
        tasks: tasks ?? this.tasks,
        isInitialized: isInitialized ?? this.isInitialized,
        hasInitError: hasInitError ?? this.hasInitError,
      );

  List<int> get tasksIndexes => [for (int i = 0; i < tasks.length; i++) i];

  List<int> get undoneTasksIndexes => [
        for (int i = 0; i < tasks.length; i++)
          if (!tasks[i].isDone) i
      ];
}

class TasksRepository extends Cubit<TasksState> {
  TasksRepository()
      : super(
          TasksState(
            tasks: [],
            isInitialized: false,
            hasInitError: false,
          ),
        );

  static TasksRepository of(BuildContext context) {
    return context.read<TasksRepository>();
  }

  // StreamController<Future<void>> _eventController;

  final List<TaskData> _tasks = [];

  final SyncStorage _storage = SyncStorage();

  // void _addEvent(Future<void> event) {
  //   _eventController.add(event);
  // }

  void _updateTasks(List<TaskData> newTasks) {
    _tasks.clear();
    _tasks.addAll(newTasks);

    _tasks.sort(
      (a, b) => dateToTimestamp(a.createdAt) - dateToTimestamp(b.createdAt),
    );
  }

  Future<void> init() async {
    try {
      await _storage.init();

      _updateTasks(await _storage.getTasks());

      emit(state.copyWith(tasks: _tasks, isInitialized: true));
    } catch (e) {
      Logger.error(e.toString(), 'init');

      emit(
        state.copyWith(tasks: _tasks, isInitialized: true, hasInitError: true),
      );
    }
  }

  Future<void> addTask(TaskData task) async {
    _tasks.add(task);

    await _storage.addTask(task);

    emit(state.copyWith(tasks: _tasks));
  }

  // TODO: replace task param
  Future<void> changeTask(int index, TaskData task) async {
    _tasks[index].text = task.text;
    _tasks[index].importance = task.importance;
    _tasks[index].date = task.date;
    _tasks[index].changedAt = DateTime.now();

    await _storage.updateTask(_tasks[index]);

    emit(state.copyWith(tasks: _tasks));
  }

  Future<void> switchDone(int index) async {
    _tasks[index].isDone = !_tasks[index].isDone;
    _tasks[index].changedAt = DateTime.now();

    await _storage.updateTask(_tasks[index]);

    emit(state.copyWith(tasks: _tasks));
  }

  Future<void> removeTask(int index) async {
    await _storage.deleteTask(_tasks[index].id);

    _tasks.removeAt(index);

    emit(state.copyWith(tasks: _tasks));
  }

  Future<void> demo() async {
    _tasks.clear();

    _tasks.addAll([
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

    _storage.setTasks(_tasks);

    emit(state.copyWith(tasks: _tasks));
  }

  Future<void> demo2() async {
    _tasks.clear();

    _tasks.addAll([
      for (int i = 0; i < 10; i++)
        TaskData(text: i.toString(), isDone: i % 2 == 0)
    ]);

    _storage.setTasks(_tasks);

    emit(state.copyWith(tasks: _tasks));
  }
}
