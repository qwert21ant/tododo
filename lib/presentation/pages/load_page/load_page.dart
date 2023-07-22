import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:get_it/get_it.dart';

import 'package:tododo/domain/tasks_repo.dart';
import 'package:tododo/domain/tasks_state.dart';

import 'package:tododo/presentation/theme/app_theme.dart';
import 'package:tododo/presentation/widgets.dart';

import 'package:tododo/presentation/navigation/navigation_manager.dart';
import 'package:tododo/presentation/navigation/navigation_state.dart';

import 'package:tododo/utils/s.dart';

class LoadPage extends StatelessWidget {
  final NavigationState nextPage;

  const LoadPage({required this.nextPage, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appTheme.backPrimary,
      body: SafeArea(
        child: BlocConsumer<TasksRepository, TasksState>(
          listener: (context, state) {
            if (state.isInitialized && !state.hasInitError) {
              GetIt.I<NavMan>().openPage(nextPage);
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
                      Icon(
                        Icons.warning_amber,
                        color: context.appTheme.red,
                        size: 40,
                      ),
                      MyText(S.of(context)['initError'])
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                child: Icon(
                  Icons.check,
                  color: context.appTheme.green,
                  size: 50,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
