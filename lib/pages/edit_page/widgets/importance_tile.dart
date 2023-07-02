import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tododo/core/themes.dart';
import 'package:tododo/core/widgets.dart';

import 'package:tododo/utils/s.dart';

import 'package:tododo/blocs/edit_page_bloc.dart';

import 'package:tododo/model/task.dart';

class ImportanceTile extends StatelessWidget {
  const ImportanceTile({super.key});

  List<Widget> _itemBuilder(BuildContext context, bool isSub) {
    final color = isSub ? AppTheme.labelTertiary : null;
    final fontSize = isSub ? 14.0 : null;

    return [
      MyText(S.of(context)['none'], color: color, fontSize: fontSize),
      MyText(S.of(context)['low'], color: color, fontSize: fontSize),
      MyText(
        '!! ${S.of(context)['high']}',
        color: color ?? AppTheme.red,
        fontSize: fontSize,
      ),
    ];
  }

  List<Widget> _selectedItemBuilder(BuildContext context) {
    final items = _itemBuilder(context, true);

    return [
      for (int i = 0; i < items.length; i++)
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [MyText(S.of(context)['importance']), items[i]],
        )
    ];
  }

  List<DropdownMenuItem<TaskImportance>> _menuItemBuilder(
    BuildContext context,
  ) {
    final items = _itemBuilder(context, false);

    return [
      for (int i = 0; i < items.length; i++)
        DropdownMenuItem(value: TaskImportance.values[i], child: items[i])
    ];
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<EditPageBloc>();

    return BlocBuilder<EditPageBloc, TaskData>(
      builder: (context, state) {
        return Align(
          alignment: Alignment.centerLeft,
          child: ButtonTheme(
            alignedDropdown: true,
            textTheme: ButtonTextTheme.normal,
            child: DropdownButton<TaskImportance>(
              value: state.importance,
              selectedItemBuilder: _selectedItemBuilder,
              items: _menuItemBuilder(context),
              onChanged: (importance) {
                bloc.updateImportance(importance!);
              },
              underline: Container(height: 0),
              icon: const Icon(null),
              itemHeight: 60,
            ),
          ),
        );
      },
    );
  }
}
