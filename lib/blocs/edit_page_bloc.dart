import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tododo/model/task.dart';

class EditPageBloc extends Cubit<TaskData> {
  EditPageBloc([TaskData? initTask]) : super(initTask ?? TaskData(text: ''));

  void updateText(String text) {
    emit(state.copyWith(text: text));
  }

  void updateImportance(TaskImportance importance) {
    emit(state.copyWith(importance: importance));
  }

  void updateDate(DateTime? date) {
    emit(state.copyWith(nullDate: date == null, date: date));
  }
}
