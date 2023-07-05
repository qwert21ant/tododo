import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:integration_test/integration_test.dart';

import 'package:tododo/model/task.dart';

import 'package:tododo/presentation/navigation/navigation_state.dart';
import 'package:tododo/presentation/navigation/router_delegate.dart';

import '../test/mocks/task_storage_mock.dart';

import 'package:tododo/domain/tasks_repo.dart';

import 'test_main.dart' as test_app;

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // rootBundle не работает внутри тестов,
  // а здесь работает, и сохраняет файлы в кеш
  await rootBundle.loadString('l10n/ru.json');
  await rootBundle.loadString('l10n/en.json');

  late TaskStorageMock mock;
  late TasksRepository repo;

  late MyRouterDelegate router;

  setUp(() {
    mock = TaskStorageMock([]);
    repo = TasksRepository(storage: mock);

    router = MyRouterDelegate();
  });

  tearDown(() {
    router.dispose();
  });

  testWidgets('Add new task test', (WidgetTester tester) async {
    test_app.myRunApp(repo, router);

    await tester.pumpAndSettle();

    expect(router.currentConfiguration.name, Routes.main);
    expect(find.text('Мои дела'), findsWidgets);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(router.currentConfiguration.name, Routes.edit);
    expect(router.currentConfiguration.taskIndex, null);

    expect(find.text('СОХРАНИТЬ'), findsWidgets);

    const newText = 'Какой-то текст';
    const newImportance = TaskImportance.low;

    await tester.enterText(find.byType(TextField), newText);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Важность'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Низкий'));
    await tester.pumpAndSettle();

    await Future.delayed(const Duration(milliseconds: 500));

    await tester.tap(find.text('СОХРАНИТЬ'));
    await tester.pumpAndSettle();

    await Future.delayed(const Duration(milliseconds: 500));

    expect(router.currentConfiguration.name, Routes.main);
    expect(find.text('Мои дела', findRichText: true), findsWidgets);
    expect(find.byIcon(Icons.arrow_downward), findsWidgets);

    expect(mock.tasks, hasLength(1));
    expect(mock.tasks[0].text, newText);
    expect(mock.tasks[0].importance, newImportance);
  });
}
