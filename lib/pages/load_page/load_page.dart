import 'package:flutter/material.dart';

import 'package:tododo/core/navigation.dart';
import 'package:tododo/core/task_man.dart';
import 'package:tododo/core/themes.dart';
import 'package:tododo/core/widgets.dart';

import 'package:tododo/utils/logger.dart';
import 'package:tododo/utils/s.dart';

class LoadPage extends StatefulWidget {
  const LoadPage({super.key});

  @override
  State<LoadPage> createState() => _LoadPageState();
}

class _LoadPageState extends State<LoadPage> {
  String? _error;

  Future<void> _initApp() async {
    try {
      await TaskMan.init();
      NavMan.openMainPage();
    } catch (e) {
      Logger.error(e.toString(), 'init');

      setState(() {
        _error = e.toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _initApp();
  }

  @override
  Widget build(BuildContext context) {
    final content = _error == null
        ? const CircularProgressIndicator()
        : FittedBox(
            child: Column(
              children: [
                const Icon(
                  Icons.warning_amber,
                  color: AppTheme.red,
                  size: 40,
                ),
                MyText(S.of(context)['initError'])
              ],
            ),
          );

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Center(child: content),
        ),
      ),
    );
  }
}
