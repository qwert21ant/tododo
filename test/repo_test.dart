import 'package:flutter_test/flutter_test.dart';

import 'package:tododo/domain/tasks_repo.dart';
import 'package:tododo/model/task.dart';

import 'mocks/task_storage_mock.dart';

import 'utils/tasks.dart';
import 'utils/utils.dart';

void main() {
  late TaskStorageMock mock;
  late TasksRepository repo;

  setUp(() async {
    mock = TaskStorageMock([]);
    repo = TasksRepository(storage: mock);

    await repo.init();
  });

  group('Basic methods', () {
    test('Init', () async {
      mock = TaskStorageMock([]);
      repo = TasksRepository(storage: mock);

      expect(mock.isInit, false);

      repo.init();

      expect(mock.isInit, true);
    });

    test('Add task', () async {
      for (final task in tasks) {
        await repo.addTask(task);
      }

      expect(mock.tasks, hasLength(tasks.length));
      for (final task in tasks) {
        expect(
          mock.tasks,
          anyElement(predicate<TaskData>((item) => item.isEqual(task))),
        );
      }
    });

    test('Update task', () async {
      await repo.addTask(taskA);

      await Future.delayed(const Duration(milliseconds: 100));

      await repo.updateTask(
        0,
        text: taskB.text,
        importance: taskB.importance,
        date: taskB.date,
      );

      expect(mock.tasks, hasLength(1));

      final chTask = mock.tasks[0];

      expect(chTask.id, taskA.id);
      expect(chTask.text, taskB.text);
      expect(chTask.importance, taskB.importance);
      expect(chTask.date, taskB.date);
      expect(chTask.changedAt, isNot(taskA.changedAt));
      expect(chTask.updatedBy, isNot(taskA.updatedBy));
    });

    test('Remove task', () async {
      for (final task in tasks) {
        await repo.addTask(task);
      }

      await repo.removeTask(0);

      expect(mock.tasks, hasLength(tasks.length - 1));

      expect(mock.tasks, anyElement(isNot(equalTask(tasks[0]))));

      for (int i = 1; i < tasks.length; i++) {
        expect(mock.tasks, anyElement(equalTask(tasks[i])));
      }
    });
  });

  group('Cubit', () {
    test('Emit on init', () async {
      mock = TaskStorageMock([]);
      repo = TasksRepository(storage: mock);

      expect(repo.state.isInitialized, false);

      await repo.init();

      final stateAfter = repo.state;

      expect(stateAfter.isInitialized, true);
      expect(stateAfter.hasInitError, false);
      expect(stateAfter.tasks, hasLength(0));
      expect(stateAfter.doneCount, 0);
    });

    test('Emit on init with error', () async {
      mock = TaskStorageMock([], true);
      repo = TasksRepository(storage: mock);

      expect(repo.state.isInitialized, false);

      await repo.init();

      final stateAfter = repo.state;

      expect(stateAfter.isInitialized, true);
      expect(stateAfter.hasInitError, true);
      expect(stateAfter.tasks, hasLength(0));
      expect(stateAfter.doneCount, 0);
    });

    test('Init with initial tasks', () async {
      mock = TaskStorageMock(tasks);
      repo = TasksRepository(storage: mock);

      await repo.init();

      final stateAfter = repo.state;

      expect(stateAfter.tasks, hasLength(tasks.length));
      for (final task in tasks) {
        expect(
          mock.tasks,
          anyElement(predicate<TaskData>((item) => item.isEqual(task))),
        );
      }
    });

    test('Emit on add task', () async {
      final newTask = tasks[0];
      await repo.addTask(newTask);

      final stateAfter = repo.state;

      expect(stateAfter.tasks, hasLength(1));
      expect(stateAfter.tasks, anyElement(equalTask(tasks[0])));

      expect(stateAfter.isInitialized, true);
      expect(stateAfter.hasInitError, false);
    });

    test('Emit on update task', () async {
      await repo.addTask(taskA);

      await repo.updateTask(
        0,
        text: taskB.text,
        importance: taskB.importance,
        date: taskB.date,
      );

      final stateAfter = repo.state;

      expect(stateAfter.tasks, hasLength(1));

      final chTask = stateAfter.tasks[0];

      expect(chTask.id, taskA.id);
      expect(chTask.text, taskB.text);
      expect(chTask.importance, taskB.importance);
      expect(chTask.date, taskB.date);
      expect(chTask.changedAt, isNot(taskA.changedAt));
      expect(chTask.updatedBy, isNot(taskA.updatedBy));

      expect(stateAfter.isInitialized, true);
      expect(stateAfter.hasInitError, false);
    });

    test('Emit on remove task', () async {
      for (final task in tasks) {
        await repo.addTask(task);
      }

      await repo.removeTask(0);

      final stateAfter = repo.state;

      expect(stateAfter.tasks, hasLength(tasks.length - 1));

      expect(stateAfter.tasks, anyElement(isNot(equalTask(tasks[0]))));

      for (int i = 1; i < tasks.length; i++) {
        expect(stateAfter.tasks, anyElement(equalTask(tasks[i])));
      }

      expect(stateAfter.isInitialized, true);
      expect(stateAfter.hasInitError, false);
    });

    test('Done count', () async {
      for (final task in tasks) {
        await repo.addTask(task);
      }

      final nDoneCount =
          tasks.fold(0, (prev, task) => prev + (task.isDone ? 1 : 0));

      expect(repo.state.doneCount, nDoneCount);

      await repo.addTask(TaskData(text: 'A', isDone: true));

      expect(repo.state.doneCount, nDoneCount + 1);
    });
  });
}
