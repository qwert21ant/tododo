import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tododo/core/navigation.dart';
import 'package:tododo/core/tasks_repo.dart';
import 'package:tododo/core/themes.dart';
import 'package:tododo/core/widgets.dart';

import 'package:tododo/utils/s.dart';

class LoadPage extends StatelessWidget {
  const LoadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<TasksRepository, TasksState>(
          listener: (context, state) {
            if (state.isInitialized && !state.hasInitError) {
              NavMan.openMainPage();
            }
          },
          builder: (context, state) {
            if (!state.isInitialized) {
              return const Center(
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (state.hasInitError) {
              return Center(
                child: FittedBox(
                  child: Column(
                    children: [
                      const Icon(
                        Icons.warning_amber,
                        color: AppTheme.red,
                        size: 40,
                      ),
                      MyText(S.of(context)['initError'])
                    ],
                  ),
                ),
              );
            } else {
              return const Center(
                child: Icon(
                  Icons.check_circle_outline,
                  color: AppTheme.green,
                  size: 40,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
