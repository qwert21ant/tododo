import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tododo/core/tasks_repo.dart';
import 'package:tododo/core/themes.dart';
import 'package:tododo/core/widgets.dart';
import 'package:tododo/core/navigation.dart';

import 'package:tododo/model/task.dart';
import 'package:tododo/pages/main_page/blocs/tasks_visibility_bloc.dart';

import 'package:tododo/utils/utils.dart';

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

  void _showInfo() {
    NavMan.openEditPage(widget.taskIndex);
  }

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

    final title = Text.rich(
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      TextSpan(
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
          TasksRepository.of(context).switchDone(widget.taskIndex);

          return !context.read<TasksVisibilityBloc>().state;
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
        onTap: _showInfo,
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

            // if (!task.isDone && !widget.visibility) {
            //   widget.onChange();
            // }

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
