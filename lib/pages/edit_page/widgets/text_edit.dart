import 'package:flutter/material.dart';

import 'package:tododo/core/themes.dart';

import 'package:tododo/utils/s.dart';

class TextEdit extends StatefulWidget {
  final String? text;
  final void Function(String) onChange;

  const TextEdit({super.key, this.text, required this.onChange});

  @override
  State<TextEdit> createState() => _TextEditState();
}

class _TextEditState extends State<TextEdit> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.text != null) controller.text = widget.text!;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backSecondary,
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
        onChanged: widget.onChange,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: S.of(context)['whatToDo'],
        ),
        style: AppTheme.body.copyWith(height: 1.125),
      ),
    );
  }
}
