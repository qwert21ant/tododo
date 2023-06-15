import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:tododo/core/navigation.dart';
import 'package:tododo/core/taskman.dart';
import 'package:tododo/core/themes.dart';
import 'package:tododo/core/widgets.dart';

import 'package:tododo/utils/logger.dart';
import 'appbar.dart';
import 'listitem.dart';
import 'sliver_container.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late bool visibility;

  @override
  initState() {
    super.initState();

    visibility = false;
  }

  void _openEditPage([int? taskIndex]) {
    NavMan.openEditPage(taskIndex).then((_) => _onChange());
  }

  void _onChange() => setState(() {});

  void _onChangeVisibility(bool newVisibility) {
    Logger.state('change visibility: ${newVisibility ? 'on' : 'off'}');

    setState(() {
      visibility = newVisibility;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> list;

    final List<dynamic> tasks = [];
    if (visibility) {
      for (int i = 0; i < TaskMan.tasks.length; i++) {
        tasks.add([i, TaskMan.tasks[i]]);
      }
    } else {
      for (int i = 0; i < TaskMan.tasks.length; i++) {
        if (TaskMan.tasks[i].isDone) continue;
        tasks.add([i, TaskMan.tasks[i]]);
      }
    }

    if (tasks.isNotEmpty) {
      list = [
        ListItem(
          TaskMan.uniqueValue++,
          tasks[0][0],
          clipTop: true,
          onChange: _onChange,
          openEditPage: _openEditPage,
          visibility: visibility,
        ),
        for (int i = 1; i < tasks.length; i++)
          ListItem(
            TaskMan.uniqueValue++,
            tasks[i][0],
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
            //color: AppTheme.backSecondary,
            title: const MyText('Новое', color: AppTheme.labelTertiary),
            onTap: _openEditPage,
          ),
        )
      ];
    } else {
      list = [
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          child: MyListTile(
            //color: AppTheme.backSecondary,
            title: const MyText('Новое', color: AppTheme.labelTertiary),
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
