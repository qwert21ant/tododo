import 'package:tododo/model/task.dart';

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
