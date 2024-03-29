import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tododo/presentation/theme/app_theme.dart';
import 'package:tododo/presentation/widgets.dart';

import 'package:tododo/utils/utils.dart';
import 'package:tododo/utils/s.dart';

import 'package:tododo/model/task.dart';

import '../blocs/edit_page_bloc.dart';

class DateTile extends StatelessWidget {
  const DateTile({super.key});

  Future<DateTime?> _inputDate(
    BuildContext context,
    DateTime? selectedDate,
  ) async {
    return await showDatePicker(
      locale: S.of(context).locale,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 360)),
      lastDate: DateTime.now().add(const Duration(days: 3600)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditPageBloc, TaskData>(
      builder: (context, state) {
        final bloc = context.read<EditPageBloc>();

        return ListTile(
          onTap: () async {
            final newDate = await _inputDate(context, state.date);

            if (newDate != null) bloc.updateDate(newDate);
          },
          title: MyText(S.of(context)['doTill']),
          subtitle: MyText(
            formatDate(state.date),
            fontSize: 14,
            color: context.appTheme.blue,
          ),
          trailing: Switch(
            activeColor: context.appTheme.blue,
            inactiveThumbColor: context.appTheme.backElevated,
            inactiveTrackColor: context.appTheme.overlaySupport,
            value: state.date != null,
            onChanged: (bool value) async {
              if (value) {
                if (state.date != null) return;
                final newDate = await _inputDate(context, state.date);

                if (newDate != null) bloc.updateDate(newDate);
              } else {
                bloc.updateDate(null);
              }
            },
          ),
        );
      },
    );
  }
}
