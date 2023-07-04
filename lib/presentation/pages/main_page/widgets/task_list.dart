import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:get_it/get_it.dart';

import 'package:tododo/core/themes.dart';
import 'package:tododo/core/tasks_repo.dart';
import 'package:tododo/core/widgets.dart';

import 'package:tododo/utils/s.dart';

import 'package:tododo/presentation/navigation/navigation_manager.dart';

import 'sliver_container.dart';
import 'list_item.dart';

import '../blocs/tasks_visibility_bloc.dart';

class TaskList extends StatelessWidget {
  const TaskList({super.key});

  List<Widget> _itemBuilder(BuildContext context, List<int> tasks) {
    final List<Widget> list;

    if (tasks.isNotEmpty) {
      list = [
        ListItem(tasks[0], clipTop: true),
        for (int i = 1; i < tasks.length; i++) ListItem(tasks[i]),
        ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
          child: MyListTile(
            title: MyText(S.of(context)['new'], color: AppTheme.labelTertiary),
            onTap: () {
              GetIt.I<NavMan>().openEditPage();
            },
          ),
        )
      ];
    } else {
      list = [
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          child: MyListTile(
            title: MyText(S.of(context)['new'], color: AppTheme.labelTertiary),
            onTap: () {
              GetIt.I<NavMan>().openEditPage();
            },
          ),
        )
      ];
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return SliverContainer(
      decoration: const BoxDecoration(
        color: AppTheme.backSecondary,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 2),
            color: Color.fromRGBO(0, 0, 0, 0.12),
            blurRadius: 2,
          ),
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.06),
            blurRadius: 2,
          )
        ],
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Builder(
        builder: (context) {
          context.watch<TasksRepository>();
          final visibility = context.watch<TasksVisibilityBloc>().state;

          return SliverList.list(
            children: _itemBuilder(
              context,
              visibility
                  ? TasksRepository.of(context).state.tasksIndexes
                  : TasksRepository.of(context).state.undoneTasksIndexes,
            ),
          );
        },
      ),
    );
  }
}
