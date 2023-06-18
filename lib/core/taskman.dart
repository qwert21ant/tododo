import 'package:flutter/foundation.dart';

import '../utils/logger.dart';

enum TaskImportance { none, low, high }

class TaskData {
  static int _lastId = 0;

  int id;
  String text;
  bool isDone;
  TaskImportance importance;
  DateTime? date;

  TaskData(
    this.text, {
    this.isDone = false,
    this.importance = TaskImportance.none,
    this.date,
  }) : id = _lastId++;

  @override
  String toString() {
    return '${text.length > 30 ? text.substring(0, 30) : text} [${isDone ? 'done' : 'not done'}]';
  }
}

final class TaskMan {
  static final List<TaskData> tasks = [];

  static final ValueNotifier<int> doneCount = ValueNotifier<int>(0);

  static void addTask(TaskData task) {
    Logger.logic('add new task: $task');

    if (task.isDone) doneCount.value++;
    tasks.add(task);
  }

  // except isDone
  static void changeTask(int index, TaskData task) {
    Logger.logic('change task #$index: $task');

    tasks[index].text = task.text;
    tasks[index].importance = task.importance;
    tasks[index].date = task.date;
  }

  static void switchDone(int index) {
    Logger.logic('switch isDone state #$index');

    if (tasks[index].isDone) {
      doneCount.value--;
    } else {
      doneCount.value++;
    }
    tasks[index].isDone = !tasks[index].isDone;
  }

  static void removeTask(int index) {
    Logger.logic('remove task #$index: ${tasks[index]}');

    if (tasks[index].isDone) doneCount.value--;
    tasks.removeAt(index);
  }

  static void demo() {
    tasks.clear();

    tasks.addAll([
      TaskData('Купить что-то', isDone: true),
      TaskData('Купить что-то', isDone: true),
      TaskData('Купить что-то'),
      TaskData('Купить что-то, где-то, зачем-то, но зачем не очень понятно'),
      TaskData(
        'Купить что-то, где-то, зачем-то, но зачем не очень понятно, но точно чтобы показать как обрезается текст',
      ),
      TaskData('Купить что-то', importance: TaskImportance.high),
      TaskData('Купить что-то', importance: TaskImportance.low),
      TaskData('Купить что-то', date: DateTime.now()),
      TaskData('Купить что-то', isDone: true),
      TaskData(
        '''Фьючерсный контракт — это договор между покупателем и продавцом о покупке/продаже какого-то актива в будущем. Стороны заранее оговаривают, через какой срок и по какой цене состоится сделка.
          Например, сейчас одна акция «Лукойла» стоит около 5700 рублей. Фьючерс на акции «Лукойла» — это, например, договор между покупателем и продавцом о том, что покупатель купит акции «Лукойла» у продавца по цене 5700 рублей через 3 месяца. При этом не важно, какая цена будет у акций через 3 месяца: цена сделки между покупателем и продавцом все равно останется 5700 рублей. Если реальная цена акции через три месяца не останется прежней, одна из сторон в любом случае понесет убытки.''',
      ),
    ]);

    doneCount.value = 3;
  }

  static void demo2() {
    tasks.clear();

    tasks.addAll([
      for (int i = 0; i < 10; i++) TaskData(i.toString(), isDone: i % 2 == 0)
    ]);

    doneCount.value = 5;
  }
}
