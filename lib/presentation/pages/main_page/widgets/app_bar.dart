import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tododo/domain/tasks_repo.dart';
import 'package:tododo/domain/tasks_state.dart';

import 'package:tododo/presentation/theme/app_theme.dart';
import 'package:tododo/presentation/widgets.dart';

import 'package:tododo/utils/s.dart';

import '../blocs/tasks_visibility_bloc.dart';

class MyAppBar extends StatelessWidget {
  final double collapsedHeight;
  final double expandedHeight;

  const MyAppBar({
    super.key,
    required this.collapsedHeight,
    required this.expandedHeight,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _MyDelegate(
        collapsedHeight: collapsedHeight,
        expandedHeight: expandedHeight,
        iconButton: BlocBuilder<TasksVisibilityBloc, bool>(
          builder: (context, state) {
            return MyIconButton(
              icon: state ? Icons.visibility_off : Icons.visibility,
              iconColor: context.appTheme.blue,
              backgroundColor: context.appTheme.backPrimary,
              onPressed: () {
                final bloc = context.read<TasksVisibilityBloc>();

                bloc.switchVisibility();
              },
            );
          },
        ),
      ),
    );
  }
}

class _MyDelegate extends SliverPersistentHeaderDelegate {
  final double collapsedHeight;
  final double expandedHeight;

  final Widget iconButton;

  _MyDelegate({
    required this.collapsedHeight,
    required this.expandedHeight,
    required this.iconButton,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    // 0 - expanded
    // 1 - collapsed
    final double perc =
        (shrinkOffset / (expandedHeight - collapsedHeight)).clamp(0.0, 1.0);

    double interp(double a, double b) => lerpDouble(a, b, perc)!;

    return Stack(
      children: [
        AnimatedContainer(
          decoration: BoxDecoration(
            boxShadow: perc == 1.0
                ? const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.2),
                      offset: Offset(0, 1),
                      blurRadius: 10,
                    ),
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.12),
                      offset: Offset(0, 4),
                      blurRadius: 5,
                    ),
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.14),
                      offset: Offset(0, 2),
                      blurRadius: 4,
                    )
                  ]
                : null,
          ),
          duration: Duration(milliseconds: perc == 1.0 ? 300 : 50),
        ),
        Container(
          color: context.appTheme.backPrimary,
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  alignment: Alignment.bottomLeft,
                  padding: EdgeInsets.only(left: interp(64, 16)),
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: interp(30, 14)),
                        child: Text(
                          S.of(context)['myTasks'],
                          style: context.appTheme.textTitleLarge.copyWith(
                            fontSize: interp(32, 20),
                            height: 1.6,
                            color: context.appTheme.labelPrimary,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Opacity(
                          opacity: (1.0 - perc * 2).clamp(0.0, 1.0),
                          child: BlocSelector<TasksRepository, TasksState, int>(
                            selector: (state) => state.doneCount,
                            builder: (context, value) => MyText(
                              '${S.of(context)['done']} — $value',
                              fontSize: interp(16, 10),
                              color: context.appTheme.labelTertiary,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: collapsedHeight,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.only(right: 16),
                      child: iconButton,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => collapsedHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
