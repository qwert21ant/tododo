import 'package:flutter_test/flutter_test.dart';

import 'package:tododo/data/app_storage/app_storage_impl.dart';

import 'package:tododo/model/app_config.dart';
import 'package:tododo/model/task.dart';

import 'mocks/config_storage_mock.dart';
import 'mocks/revision_task_storage_mock.dart';

import 'utils/tasks.dart';
import 'utils/utils.dart';

void main() async {
  late RevisionTaskStorageMock localStorageMock;
  late RevisionTaskStorageMock netStorageMock;
  late List<RevisionTaskStorageMock> taskMocks;

  late ConfigStorageMock cfgStorageMock;
  late AppStorageImpl storage;

  Future<void> mySetUp({
    List<TaskData> localTasks = const [],
    int localRevision = 0,
    List<TaskData> netTasks = const [],
    int netRevision = 0,
    bool netThrowOnInit = false,
    bool netThrowInMethods = false,
    Duration? netDelay,
    bool wasOnline = false,
  }) async {
    localStorageMock = RevisionTaskStorageMock(localTasks, localRevision);
    netStorageMock = RevisionTaskStorageMock(
      netTasks,
      netRevision,
      netThrowOnInit,
      netThrowInMethods,
      netDelay,
    );
    cfgStorageMock = ConfigStorageMock(
      AppConfig(
        localRevision: localRevision,
        wasOnline: wasOnline,
      ),
    );

    storage = AppStorageImpl(
      localStorage: localStorageMock,
      netStorage: netStorageMock,
      cfgStorage: cfgStorageMock,
    );

    taskMocks = [localStorageMock, netStorageMock];

    await storage.init();
  }

  group('Basic methods', () {
    setUp(() {
      localStorageMock = RevisionTaskStorageMock([], 0);
      netStorageMock = RevisionTaskStorageMock([], 0);
      cfgStorageMock = ConfigStorageMock(AppConfig());

      storage = AppStorageImpl(
        localStorage: localStorageMock,
        netStorage: netStorageMock,
        cfgStorage: cfgStorageMock,
      );

      taskMocks = [localStorageMock, netStorageMock];
    });

    test('Init', () async {
      expectAll([localStorageMock, netStorageMock, cfgStorageMock], (mock) {
        expect(mock.isInit, false);
      });

      await storage.init();

      expectAll([localStorageMock, netStorageMock, cfgStorageMock], (mock) {
        expect(mock.isInit, true);
      });
    });

    test('Set tasks', () async {
      await storage.init();

      await storage.setTasks(tasks);

      expectAll(taskMocks, (mock) {
        expectSameTasks(mock.tasks, tasks);
      });
    });

    test('Add task', () async {
      await storage.init();

      for (final task in tasks) {
        await storage.addTask(task);
      }

      expectAll(taskMocks, (mock) {
        expectSameTasks(mock.tasks, tasks);
      });
    });

    test('Update task', () async {
      await storage.init();

      await storage.addTask(taskA);

      await storage.updateTask(taskB);

      expectAll(taskMocks, (mock) {
        expect(mock.tasks, hasLength(1));
        expect(mock.tasks[0], equalTask(taskB));
      });
    });

    test('Delete task', () async {
      await storage.init();

      for (final task in tasks) {
        await storage.addTask(task);
      }

      await storage.deleteTask(tasks[0].id);

      expectAll(taskMocks, (mock) {
        expect(mock.tasks, hasLength(tasks.length - 1));
        expect(mock.tasks, anyElement(isNot(equalTask(tasks[0]))));
        for (int i = 1; i < tasks.length; i++) {
          expect(mock.tasks, anyElement(equalTask(tasks[i])));
        }
      });
    });
  });

  group('Get tasks with sync', () {
    test('Net is newest (wasn\'t online)', () async {
      final localTasks = [tasks[0]];
      final netTasks = [tasks[0], tasks[1]];

      await mySetUp(
        localTasks: localTasks,
        localRevision: 1,
        netTasks: netTasks,
        netRevision: 2,
      );

      await storage.getTasks();

      expectAll(taskMocks, (mock) {
        expectSameTasks(mock.tasks, localTasks);
      });
    });

    test('Net is newest (was online)', () async {
      final localTasks = [tasks[0]];
      final netTasks = [tasks[0], tasks[1]];

      await mySetUp(
        localTasks: localTasks,
        localRevision: 1,
        netTasks: netTasks,
        netRevision: 2,
        wasOnline: true,
      );

      await storage.getTasks();

      expectAll(taskMocks, (mock) {
        expectSameTasks(mock.tasks, netTasks);
      });
    });

    test('Local is newest (wasn\'t online)', () async {
      final localTasks = [tasks[0]];
      final netTasks = [tasks[0], tasks[1]];

      await mySetUp(
        localTasks: localTasks,
        localRevision: 2,
        netTasks: netTasks,
        netRevision: 1,
      );

      await storage.getTasks();

      expectAll(taskMocks, (mock) {
        expectSameTasks(mock.tasks, localTasks);
      });
    });

    test('Local is newest (was online)', () async {
      final localTasks = [tasks[0]];
      final netTasks = [tasks[0], tasks[1]];

      await mySetUp(
        localTasks: localTasks,
        localRevision: 2,
        netTasks: netTasks,
        netRevision: 1,
        wasOnline: true,
      );

      await storage.getTasks();

      expectAll(taskMocks, (mock) {
        expectSameTasks(mock.tasks, localTasks);
      });
    });
  });

  group('Net troubles', () {
    test('Net errors', () async {
      await mySetUp(
        localTasks: tasks,
        netTasks: tasks,
      );

      await storage.setTasks(tasks);

      netStorageMock.throwInMethods = true;

      await storage.addTask(taskA);
      await storage.addTask(taskB);

      expectFindTask(localStorageMock.tasks, taskA);
      expectFindTask(localStorageMock.tasks, taskB);
      expectNotFindTask(netStorageMock.tasks, taskA);
      expectNotFindTask(netStorageMock.tasks, taskB);
    });

    test('Big net delay', () async {
      await mySetUp(
        localTasks: tasks,
        netTasks: tasks,
      );

      await storage.getTasks();

      netStorageMock.delay = const Duration(seconds: 1);

      storage.addTask(taskA);
      storage.addTask(taskB);
      await Future.delayed(const Duration(milliseconds: 200));

      expectFindTask(localStorageMock.tasks, taskA);
      expectFindTask(localStorageMock.tasks, taskB);
      expectNotFindTask(netStorageMock.tasks, taskA);
      expectNotFindTask(netStorageMock.tasks, taskB);

      await Future.delayed(const Duration(seconds: 1));

      expectFindTask(localStorageMock.tasks, taskA);
      expectFindTask(localStorageMock.tasks, taskB);
      expectFindTask(netStorageMock.tasks, taskA);
      expectNotFindTask(netStorageMock.tasks, taskB);

      await Future.delayed(const Duration(seconds: 1));

      expectFindTask(localStorageMock.tasks, taskA);
      expectFindTask(localStorageMock.tasks, taskB);
      expectFindTask(netStorageMock.tasks, taskA);
      expectFindTask(netStorageMock.tasks, taskB);
    });
  });

  group('Config persistence', () {
    test('Local revision persistence', () async {
      mySetUp(
        localTasks: tasks,
        netTasks: tasks,
      );

      await storage.addTask(taskA);
      expect(cfgStorageMock.config.localRevision, 1);

      await storage.updateTask(tasks[0].copyWith(text: 'new text'));
      expect(cfgStorageMock.config.localRevision, 2);

      await storage.deleteTask(tasks[2].id);
      expect(cfgStorageMock.config.localRevision, 3);
    });

    test('Last online status persistence (net errors)', () async {
      mySetUp(localTasks: tasks, netTasks: tasks, wasOnline: true);

      netStorageMock.throwInMethods = true;

      await storage.addTask(taskA);

      await Future.delayed(const Duration(milliseconds: 100));

      expect(cfgStorageMock.config.wasOnline, false);
    });

    test('Last online status persistence (big net delay)', () async {
      mySetUp(localTasks: tasks, netTasks: tasks, wasOnline: true);

      netStorageMock.delay = const Duration(seconds: 1);

      await storage.addTask(taskA);

      await Future.delayed(const Duration(milliseconds: 100));

      expect(cfgStorageMock.config.wasOnline, false);

      await Future.delayed(const Duration(milliseconds: 1200));

      expect(cfgStorageMock.config.wasOnline, true);
    });
  });
}
