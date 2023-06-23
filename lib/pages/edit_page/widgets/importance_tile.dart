import 'package:flutter/material.dart';

import 'package:tododo/core/themes.dart';
import 'package:tododo/core/widgets.dart';

import 'package:tododo/utils/s.dart';

class ImportanceTile extends StatefulWidget {
  final int selectedImportance;
  final void Function(int) onChange;

  const ImportanceTile({
    super.key,
    required this.selectedImportance,
    required this.onChange,
  });

  @override
  State<ImportanceTile> createState() => _ImportanceTileState();
}

class _ImportanceTileState extends State<ImportanceTile> {
  late int selectedImportance;

  @override
  void initState() {
    super.initState();

    selectedImportance = widget.selectedImportance;
  }

  Widget _getItem(BuildContext context, int ind, [bool isSub = false]) {
    final color = isSub ? AppTheme.labelTertiary : null;
    final fontSize = isSub ? 14.0 : null;

    if (ind == 0) {
      return MyText(S.of(context)['none'], color: color, fontSize: fontSize);
    }
    if (ind == 1) {
      return MyText(S.of(context)['low'], color: color, fontSize: fontSize);
    }
    if (ind == 2) {
      return MyText(
        '!! ${S.of(context)['high']}',
        color: color ?? AppTheme.red,
        fontSize: fontSize,
      );
    }

    throw Error();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ButtonTheme(
        alignedDropdown: true,
        textTheme: ButtonTextTheme.normal,
        child: DropdownButton(
          value: selectedImportance,
          selectedItemBuilder: (context) => [
            for (int i = 0; i < 3; i++)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(S.of(context)['importance']),
                  _getItem(context, i, true),
                ],
              ),
          ],
          items: [
            for (int i = 0; i < 3; i++)
              DropdownMenuItem(value: i, child: _getItem(context, i))
          ],
          onChanged: (selected) {
            setState(() {
              selectedImportance = selected!;
              widget.onChange(selectedImportance);
            });
          },
          underline: Container(height: 0),
          icon: const Icon(null),
          itemHeight: 60,
        ),
      ),
    );
  }
}
