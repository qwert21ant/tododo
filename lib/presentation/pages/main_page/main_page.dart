import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:get_it/get_it.dart';

import 'package:tododo/presentation/themes.dart';

import 'package:tododo/presentation/navigation/navigation_manager.dart';

import 'widgets/app_bar.dart';
import 'widgets/task_list.dart';

import 'blocs/tasks_visibility_bloc.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = TasksVisibilityBloc();

    return BlocProvider<TasksVisibilityBloc>(
      create: (context) => bloc,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppTheme.blue,
          onPressed: () {
            GetIt.I<NavMan>().openEditPage();
          },
          child: const Icon(Icons.add),
        ),
        body: const SafeArea(
          child: CustomScrollView(
            slivers: [
              MyAppBar(
                collapsedHeight: 60,
                expandedHeight: 130,
              ),
              SliverPadding(
                padding: EdgeInsets.all(8),
                sliver: TaskList(),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 16))
            ],
          ),
        ),
      ),
    );
  }
}
