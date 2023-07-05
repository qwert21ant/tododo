import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:get_it/get_it.dart';

import 'package:tododo/domain/tasks_repo.dart';

import 'package:tododo/presentation/themes.dart';
import 'package:tododo/presentation/widgets.dart';

import 'package:tododo/model/task.dart';

import 'package:tododo/presentation/navigation/navigation_manager.dart';

import 'package:tododo/utils/utils.dart';

import '../blocs/tasks_visibility_bloc.dart';

import 'dismissible_background.dart';

class ListItem extends StatefulWidget {
  final int taskIndex;
  final bool clipTop;

  const ListItem(
    this.taskIndex, {
    this.clipTop = false,
    super.key,
  });

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  late StreamController<double> streamController;

  @override
  void initState() {
    super.initState();

    streamController = StreamController.broadcast();
  }

  @override
  void dispose() {
    streamController.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final task = TasksRepository.of(context).state.tasks[widget.taskIndex];

    InlineSpan? iconSpan;

    if (task.isDone) {
      iconSpan = null;
    } else if (task.importance == TaskImportance.low) {
      iconSpan = const WidgetSpan(
        child: Icon(Icons.arrow_downward, color: AppTheme.gray, size: 20),
      );
    } else if (task.importance == TaskImportance.high) {
      iconSpan = TextSpan(
        text: ' !! ',
        style: AppTheme.body.copyWith(
          color: AppTheme.red,
          fontSize: 20,
          height: 1,
          fontWeight: FontWeight.w700,
        ),
      );
    } else {
      iconSpan = null;
    }

    final title = RichText(
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          if (iconSpan != null) iconSpan,
          TextSpan(
            text: task.text,
            style: AppTheme.body.copyWith(
              color: task.isDone ? AppTheme.labelTertiary : null,
              decoration: task.isDone ? TextDecoration.lineThrough : null,
            ),
          ),
        ],
      ),
    );

    final subtitle = task.date != null
        ? MyText(
            formatDate(task.date),
            fontSize: 14,
            color: AppTheme.labelTertiary,
          )
        : null;

    Widget item = Dismissible(
      key: ValueKey(task.id),
      onUpdate: (details) {
        streamController.add(details.progress);
      },
      confirmDismiss: (dir) async {
        if (dir == DismissDirection.startToEnd) {
          final visibility = context.read<TasksVisibilityBloc>().state;
          if (visibility) {
            TasksRepository.of(context).switchDone(widget.taskIndex);
          }

          return !visibility;
        }

        return true;
      },
      onDismissed: (dir) {
        if (dir == DismissDirection.endToStart) {
          TasksRepository.of(context).removeTask(widget.taskIndex);
        } else {
          TasksRepository.of(context).switchDone(widget.taskIndex);
        }
      },
      background: DismissibleBackground(
        progressStream: streamController.stream,
        color: AppTheme.green,
        initOffset: 24 + 28,
        child: const Icon(
          Icons.check,
          color: AppTheme.white,
        ),
      ),
      secondaryBackground: DismissibleBackground(
        progressStream: streamController.stream,
        color: AppTheme.red,
        isReversed: true,
        initOffset: 24 + 28,
        child: const Icon(
          Icons.delete,
          color: AppTheme.white,
        ),
      ),
      child: MyListTile(
        onTap: () {
          GetIt.I<NavMan>().openEditPage(widget.taskIndex);
        },
        leading: Checkbox(
          fillColor: MaterialStateColor.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return AppTheme.green;
            }

            return task.importance == TaskImportance.high
                ? AppTheme.red
                : AppTheme.labelTertiary;
          }),
          value: task.isDone,
          onChanged: (value) {
            if (value == null) return;

            setState(() {
              TasksRepository.of(context).switchDone(widget.taskIndex);
            });
          },
        ),
        title: title,
        subtitle: subtitle,
        trailing: const Icon(Icons.info_outline, color: AppTheme.labelTertiary),
      ),
    );

    if (widget.clipTop) {
      return ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        child: item,
      );
    } else {
      return ClipRect(child: item);
    }
  }
}
