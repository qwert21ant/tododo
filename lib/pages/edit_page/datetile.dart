import 'package:flutter/material.dart';

import 'package:tododo/core/themes.dart';
import 'package:tododo/core/widgets.dart';

import 'package:tododo/utils/utils.dart';

class DateTile extends StatefulWidget {
  final DateTime? selectedDate;
  final void Function(DateTime?) onChange;

  const DateTile({super.key, this.selectedDate, required this.onChange});

  @override
  State<DateTile> createState() => _DateTileState();
}

class _DateTileState extends State<DateTile> {
  late DateTime? selectedDate;

  @override
  void initState() {
    super.initState();

    selectedDate = widget.selectedDate;
  }

  void _updateDate(DateTime? newDate) => setState(() {
        selectedDate = newDate;
        widget.onChange(selectedDate);
      });

  void _inputDate() => showDatePicker(
        locale: const Locale('ru'),
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        context: context,
        initialDate: selectedDate ?? DateTime.now(),
        firstDate: DateTime.now().subtract(const Duration(days: 360)),
        lastDate: DateTime.now().add(const Duration(days: 3600)),
      ).then(
        (newDate) {
          if (newDate != null) _updateDate(newDate);
        },
      );

  void _onTap() {
    _inputDate();
  }

  void _onSwitch(bool value) {
    if (value) {
      if (selectedDate == null) _inputDate();
    } else {
      _updateDate(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: _onTap,
      title: const MyText('Сделать до'),
      subtitle:
          MyText(formatDate(selectedDate), fontSize: 14, color: AppTheme.blue),
      trailing: Switch(
        value: selectedDate != null,
        onChanged: _onSwitch,
      ),
    );
  }
}
