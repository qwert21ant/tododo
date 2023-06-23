import 'dart:async';

import 'package:flutter/material.dart';

import 'package:tododo/core/task_man.dart';
import 'package:tododo/core/themes.dart';
import 'package:tododo/core/widgets.dart';

import 'package:tododo/model/task.dart';

import 'package:tododo/utils/utils.dart';

import 'dismissible_background.dart';

class ListItem extends StatefulWidget {
  final int taskIndex;
  final bool clipTop;
  final bool visibility;
  final void Function() onChange;
  final void Function(int) openEditPage;

  const ListItem(
    this.taskIndex, {
    this.clipTop = false,
    required this.onChange,
    required this.openEditPage,
    required this.visibility,
    super.key,
  });

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  late StreamController<double> streamController;

  TaskData get _task => TaskMan.tasks[widget.taskIndex];

  void _switchDone() {
    setState(() {
      TaskMan.switchDone(widget.taskIndex);
    });
  }

  void _removeTask() {
    TaskMan.removeTask(widget.taskIndex);
    widget.onChange();
  }

  void _showInfo() {
    widget.openEditPage(widget.taskIndex);
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
    InlineSpan? iconSpan;

    if (_task.isDone) {
      iconSpan = null;
    } else if (_task.importance == TaskImportance.low) {
      iconSpan = const WidgetSpan(
        child: Icon(Icons.arrow_downward, color: AppTheme.gray, size: 20),
      );
    } else if (_task.importance == TaskImportance.high) {
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
            text: _task.text,
            style: AppTheme.body.copyWith(
              color: _task.isDone ? AppTheme.labelTertiary : null,
              decoration: _task.isDone ? TextDecoration.lineThrough : null,
            ),
          ),
        ],
      ),
    );

    final subtitle = _task.date != null
        ? MyText(
            formatDate(_task.date),
            fontSize: 14,
            color: AppTheme.labelTertiary,
          )
        : null;

    Widget item = Dismissible(
      key: ValueKey(_task.id),
      onUpdate: (details) {
        streamController.add(details.progress);
      },
      confirmDismiss: (dir) async {
        if (dir == DismissDirection.startToEnd) {
          _switchDone();

          return !widget.visibility;
        }

        return true;
      },
      onDismissed: (dir) {
        if (dir == DismissDirection.endToStart) {
          _removeTask();
        } else {
          widget.onChange();
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

            return _task.importance == TaskImportance.high
                ? AppTheme.red
                : AppTheme.labelTertiary;
          }),
          value: _task.isDone,
          onChanged: (value) {
            if (value == null) return;

            if (!_task.isDone && !widget.visibility) {
              widget.onChange();
            }
            _switchDone();
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
