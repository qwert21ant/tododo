import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tododo/core/navigation.dart';
import 'package:tododo/core/themes.dart';
import 'package:tododo/core/widgets.dart';
import 'package:tododo/core/tasks_repo.dart';

import 'package:tododo/model/task.dart';

import 'package:tododo/utils/s.dart';

import 'widgets/text_edit.dart';
import 'widgets/importance_tile.dart';
import 'widgets/date_tile.dart';

import 'blocs/edit_page_bloc.dart';

class EditPage extends StatelessWidget {
  final int? taskIndex;

  const EditPage({super.key, this.taskIndex});

  void _goBack() => NavMan.pop();

  @override
  Widget build(BuildContext context) {
    final bloc = EditPageBloc(
      taskIndex != null
          ? TasksRepository.of(context).state.tasks[taskIndex!]
          : TaskData(text: ''),
    );

    return BlocProvider<EditPageBloc>(
      create: (BuildContext context) => bloc,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              leading: MyIconButton(
                icon: Icons.close,
                iconColor: AppTheme.labelPrimary,
                backgroundColor: AppTheme.backPrimary,
                onPressed: () => _goBack(),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    if (taskIndex == null) {
                      await TasksRepository.of(context).addTask(bloc.state);
                    } else {
                      await TasksRepository.of(context)
                          .changeTask(taskIndex!, bloc.state);
                    }
                    _goBack();
                  },
                  child: MyText(S.of(context)['save'], color: AppTheme.blue),
                ),
                const SizedBox(width: 16)
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              sliver: SliverList.list(
                children: [
                  const SizedBox(height: 8),
                  TextEdit(initialValue: bloc.state.text),
                  const SizedBox(height: 16),
                  const ImportanceTile(),
                  const Divider(),
                  const DateTile(),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const Divider(),
                  ListTile(
                    enabled: taskIndex != null,
                    horizontalTitleGap: 0,
                    leading: SizedBox(
                      width: 48,
                      //height: 48,
                      child: Icon(
                        Icons.delete,
                        color: taskIndex == null
                            ? AppTheme.labelDisable
                            : AppTheme.red,
                      ),
                    ),
                    title: MyText(
                      S.of(context)['delete'],
                      color: taskIndex == null
                          ? AppTheme.labelDisable
                          : AppTheme.red,
                    ),
                    onTap: () async {
                      await TasksRepository.of(context).removeTask(taskIndex!);
                      _goBack();
                    },
                  ),
                  const SizedBox(height: 32)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
