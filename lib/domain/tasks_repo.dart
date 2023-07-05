import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tododo/model/task.dart';

import 'package:tododo/data/task_storage/task_storage.dart';

import 'package:tododo/utils/utils.dart';
import 'package:tododo/utils/logger.dart';

import 'tasks_state.dart';

class TasksRepository extends Cubit<TasksState> {
  TasksRepository({required TaskStorage storage})
      : _storage = storage,
        super(
          TasksState(
            tasks: [],
            isInitialized: false,
            hasInitError: false,
          ),
        );

  final TaskStorage _storage;

  static TasksRepository of(BuildContext context) {
    return context.read<TasksRepository>();
  }

  final List<TaskData> _tasks = [];

  void _updateTasks(List<TaskData> newTasks) {
    _tasks.clear();
    _tasks.addAll(newTasks);

    _tasks.sort(
      (a, b) => dateToTimestamp(a.createdAt) - dateToTimestamp(b.createdAt),
    );
  }

  Future<void> init() async {
    if (state.isInitialized) return;

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
    _tasks.add(task.copy());

    await _storage.addTask(task);

    emit(state.copyWith(tasks: _tasks));
  }

  Future<void> updateTask(
    int index, {
    String? text,
    TaskImportance? importance,
    bool? nullDate,
    DateTime? date,
  }) async {
    if (text != null) {
      _tasks[index].text = text;
    }
    if (importance != null) {
      _tasks[index].importance = importance;
    }
    if (nullDate != null && nullDate) {
      _tasks[index].date = null;
    } else if (date != null) {
      _tasks[index].date = date;
    }

    _tasks[index].changedAt = DateTime.now();
    _tasks[index].updatedBy = Platform.isAndroid ? 'android' : 'not android';

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
