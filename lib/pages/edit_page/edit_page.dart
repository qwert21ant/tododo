import 'package:flutter/material.dart';

import 'package:tododo/core/navigation.dart';
import 'package:tododo/core/themes.dart';
import 'package:tododo/core/widgets.dart';
import 'package:tododo/core/taskman.dart';

import 'textedit.dart';
import 'importancetile.dart';
import 'datetile.dart';

class EditPage extends StatefulWidget {
  final int? taskIndex;

  const EditPage({super.key, this.taskIndex});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late TaskData task;

  void _onDateChange(DateTime? newDate) {
    task.date = newDate;
  }

  void _onImportanceChange(int newImp) {
    task.importance = TaskImportance.values[newImp];
  }

  void _onTextChange(String newText) {
    task.text = newText;
  }

  @override
  void initState() {
    super.initState();

    task = widget.taskIndex != null
        ? TaskMan.tasks[widget.taskIndex!]
        : TaskData('');
  }

  int _getImportanceIndex() {
    if (widget.taskIndex == null) return 0;

    final imp = TaskMan.tasks[widget.taskIndex!].importance;
    if (imp == TaskImportance.low) return 1;
    if (imp == TaskImportance.high) return 2;
    return 0;
  }

  void _goBack() => NavMan.pop();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                onPressed: () {
                  if (widget.taskIndex == null) {
                    TaskMan.addTask(task);
                  } else {
                    TaskMan.changeTask(widget.taskIndex!, task);
                  }
                  _goBack();
                },
                child: const MyText('СОХРАНИТЬ', color: AppTheme.blue),
              ),
              const SizedBox(width: 16)
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            sliver: SliverList.list(
              children: [
                const SizedBox(height: 8),
                TextEdit(
                  text: widget.taskIndex != null
                      ? TaskMan.tasks[widget.taskIndex!].text
                      : null,
                  onChange: _onTextChange,
                ),
                const SizedBox(height: 16),
                ImportanceTile(
                  selectedImportance: _getImportanceIndex(),
                  onChange: _onImportanceChange,
                ),
                const Divider(),
                DateTile(
                  selectedDate: widget.taskIndex != null
                      ? TaskMan.tasks[widget.taskIndex!].date
                      : null,
                  onChange: _onDateChange,
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const Divider(),
                ListTile(
                  enabled: widget.taskIndex != null,
                  horizontalTitleGap: 0,
                  leading: SizedBox(
                    width: 48,
                    //height: 48,
                    child: Icon(
                      Icons.delete,
                      color: widget.taskIndex == null
                          ? AppTheme.labelDisable
                          : AppTheme.red,
                    ),
                  ),
                  title: MyText(
                    'Удалить',
                    color: widget.taskIndex == null
                        ? AppTheme.labelDisable
                        : AppTheme.red,
                  ),
                  onTap: () {
                    TaskMan.removeTask(widget.taskIndex!);
                    _goBack();
                  },
                ),
                const SizedBox(height: 32)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
