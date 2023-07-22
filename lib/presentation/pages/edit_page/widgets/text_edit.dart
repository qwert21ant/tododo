import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tododo/presentation/theme/app_theme.dart';

import 'package:tododo/utils/s.dart';

import '../blocs/edit_page_bloc.dart';

class TextEdit extends StatefulWidget {
  final String? initialValue;

  const TextEdit({super.key, this.initialValue});

  @override
  State<TextEdit> createState() => _TextEditState();
}

class _TextEditState extends State<TextEdit> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    controller.text = widget.initialValue ?? '';
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<EditPageBloc>();

    return Container(
      decoration: BoxDecoration(
        color: context.appTheme.backSecondary,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.12),
            offset: Offset(0, 2),
            blurRadius: 2,
          ),
          BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.06), blurRadius: 2)
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      constraints: const BoxConstraints(minHeight: 104),
      child: TextField(
        controller: controller,
        onChanged: (String text) {
          bloc.updateText(text);
        },
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: S.of(context)['whatToDo'],
          hintStyle: context.appTheme.textBody.copyWith(
            color: context.appTheme.labelTertiary,
          ),
        ),
        style: context.appTheme.textBody.copyWith(
          height: 1.125,
          color: context.appTheme.labelPrimary,
        ),
      ),
    );
  }
}
