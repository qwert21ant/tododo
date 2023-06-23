import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:tododo/core/themes.dart';
import 'package:tododo/core/widgets.dart';
import 'package:tododo/core/task_man.dart';

class MyAppBar extends StatefulWidget {
  final double collapsedHeight;
  final double expandedHeight;
  final void Function(bool) onChange;

  const MyAppBar({
    super.key,
    required this.collapsedHeight,
    required this.expandedHeight,
    required this.onChange,
  });

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  late bool visibility;

  @override
  void initState() {
    super.initState();

    visibility = false;
  }

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _MyDelegate(
        collapsedHeight: widget.collapsedHeight,
        expandedHeight: widget.expandedHeight,
        iconButton: MyIconButton(
          icon: visibility ? Icons.visibility_off : Icons.visibility,
          iconColor: AppTheme.blue,
          backgroundColor: AppTheme.backPrimary,
          onPressed: () {
            setState(() {
              visibility = !visibility;
              widget.onChange(visibility);
            });
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
          color: AppTheme.backPrimary,
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
                          'Мои дела',
                          style: AppTheme.titleLarge
                              .copyWith(fontSize: interp(32, 20), height: 1.6),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Opacity(
                          opacity: (1.0 - perc * 2).clamp(0.0, 1.0),
                          child: ValueListenableBuilder<int>(
                            valueListenable: TaskMan.doneCount,
                            builder: (context, value, _) => MyText(
                              'Выполнено — $value',
                              fontSize: interp(16, 10),
                              color: AppTheme.labelTertiary,
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
