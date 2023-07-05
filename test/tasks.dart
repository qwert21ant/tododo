import 'package:tododo/model/task.dart';

final taskToUpdate = TaskData(
  id: 'test_id',
  text: 'A',
  date: DateTime(1, 1, 1),
  updatedBy: 'test_app',
);

const newTaskText = 'B';
const newTaskImportance = TaskImportance.low;
final newTaskDate = DateTime(2, 2, 2);

final List<TaskData> tasks = [
  TaskData(text: 'A', isDone: true),
  TaskData(text: 'B', importance: TaskImportance.low),
  TaskData(text: 'C', date: DateTime(1111, 11, 11)),
  TaskData(text: 'D', importance: TaskImportance.high, isDone: true),
  TaskData(text: 'E', isDone: true),
  TaskData(text: 'F', date: DateTime(2222, 22, 22)),
  TaskData(text: 'G', isDone: true),
  TaskData(text: 'H'),
  TaskData(text: 'I', importance: TaskImportance.low, isDone: true),
  TaskData(text: 'J'),
  TaskData(text: 'K', isDone: true),
  TaskData(text: 'L', importance: TaskImportance.low),
  TaskData(text: 'M'),
  TaskData(text: 'N', isDone: true),
];
