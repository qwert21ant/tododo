import 'package:flutter/material.dart';

import 'package:tododo/core/navigation.dart';

class LoadPage extends StatefulWidget {
  const LoadPage({super.key});

  @override
  State<LoadPage> createState() => _LoadPageState();
}

class _LoadPageState extends State<LoadPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 4), NavMan.openMainPage);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Text('Loading'),
        ),
      ),
    );
  }
}
