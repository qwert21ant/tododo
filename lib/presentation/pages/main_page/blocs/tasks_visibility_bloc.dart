import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tododo/utils/logger.dart';

class TasksVisibilityBloc extends Cubit<bool> {
  TasksVisibilityBloc([bool initState = false]) : super(initState);

  void switchVisibility() {
    Logger.info('Change visibility: ${!state ? 'on' : 'off'}', 'state');

    emit(!state);
  }
}
