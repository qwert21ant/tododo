import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:get_it/get_it.dart';

import 'package:tododo/domain/tasks_repo.dart';

import 'package:tododo/presentation/theme/app_theme.dart';
import 'package:tododo/presentation/widgets.dart';

import 'package:tododo/presentation/navigation/navigation_manager.dart';

import 'package:tododo/model/task.dart';

import 'package:tododo/utils/s.dart';

import 'widgets/text_edit.dart';
import 'widgets/importance_tile.dart';
import 'widgets/date_tile.dart';

import 'blocs/edit_page_bloc.dart';

class EditPage extends StatelessWidget {
  final int? taskIndex;

  const EditPage({super.key, this.taskIndex});

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
        backgroundColor: context.appTheme.backPrimary,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              foregroundColor: Colors.white,
              backgroundColor: context.appTheme.backPrimary,
              pinned: true,
              leading: MyIconButton(
                icon: Icons.close,
                iconColor: context.appTheme.labelPrimary,
                backgroundColor: context.appTheme.backPrimary,
                onPressed: () {
                  GetIt.I<NavMan>().openMainPage();
                },
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    if (taskIndex == null) {
                      await TasksRepository.of(context).addTask(bloc.state);
                    } else {
                      await TasksRepository.of(context).updateTask(
                        taskIndex!,
                        text: bloc.state.text,
                        importance: bloc.state.importance,
                        nullDate: bloc.state.date == null,
                        date: bloc.state.date,
                      );
                    }

                    GetIt.I<NavMan>().openMainPage();
                  },
                  child: MyText(
                    S.of(context)['save'],
                    color: context.appTheme.blue,
                  ),
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
                  Divider(color: context.appTheme.separatorSupport),
                  const DateTile(),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Divider(color: context.appTheme.separatorSupport),
                  ListTile(
                    enabled: taskIndex != null,
                    horizontalTitleGap: 0,
                    leading: SizedBox(
                      width: 48,
                      //height: 48,
                      child: Icon(
                        Icons.delete,
                        color: taskIndex == null
                            ? context.appTheme.labelDisable
                            : context.appTheme.red,
                      ),
                    ),
                    title: MyText(
                      S.of(context)['delete'],
                      color: taskIndex == null
                          ? context.appTheme.labelDisable
                          : context.appTheme.red,
                    ),
                    onTap: () async {
                      await TasksRepository.of(context).removeTask(taskIndex!);

                      GetIt.I<NavMan>().openMainPage();
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
