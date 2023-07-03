import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationProvider {
  void Function() openMainPage;
  void Function([int?]) openEditPage;
  void Function() pop;

  NavigationProvider(this.openMainPage, this.openEditPage, this.pop);

  static NavigationProvider of(BuildContext context) {
    return context.read<NavigationProvider>();
  }
}
