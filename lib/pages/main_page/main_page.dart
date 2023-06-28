import 'package:flutter/material.dart';

import 'package:tododo/core/navigation.dart';
import 'package:tododo/core/task_man.dart';
import 'package:tododo/core/themes.dart';
import 'package:tododo/core/widgets.dart';

import 'package:tododo/utils/logger.dart';
import 'package:tododo/utils/s.dart';

import 'widgets/app_bar.dart';
import 'widgets/list_item.dart';
import 'widgets/sliver_container.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late bool visibility;

  @override
  void initState() {
    super.initState();

    visibility = false;
  }

  Future<void> _openEditPage([int? taskIndex]) async {
    await NavMan.openEditPage(taskIndex);
    _onChange();
  }

  void _onChange() => setState(() {});

  void _onChangeVisibility(bool newVisibility) {
    Logger.info('Change visibility: ${newVisibility ? 'on' : 'off'}', 'state');

    setState(() {
      visibility = newVisibility;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> list;

    final List<int> tasks = TaskMan.tasks
        .asMap()
        .entries
        .where((e) => visibility || !e.value.isDone)
        .map((e) => e.key)
        .toList();

    if (tasks.isNotEmpty) {
      list = [
        ListItem(
          tasks[0],
          clipTop: true,
          onChange: _onChange,
          openEditPage: _openEditPage,
          visibility: visibility,
        ),
        for (int i = 1; i < tasks.length; i++)
          ListItem(
            tasks[i],
            onChange: _onChange,
            openEditPage: _openEditPage,
            visibility: visibility,
          ),
        ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
          child: MyListTile(
            title: MyText(S.of(context)['new'], color: AppTheme.labelTertiary),
            onTap: _openEditPage,
          ),
        )
      ];
    } else {
      list = [
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          child: MyListTile(
            title: MyText(S.of(context)['new'], color: AppTheme.labelTertiary),
            onTap: _openEditPage,
          ),
        )
      ];
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.blue,
        onPressed: _openEditPage,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            MyAppBar(
              collapsedHeight: 60,
              expandedHeight: 130,
              onChange: _onChangeVisibility,
            ),
            SliverPadding(
              padding: const EdgeInsets.all(8),
              sliver: SliverContainer(
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
                child: SliverList.list(children: list),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16))
          ],
        ),
      ),
    );
  }
}
