import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DismissibleBackground extends StatelessWidget {
  final double dismissProgress;
  final Color color;
  final bool isReversed;
  final Widget child;
  final double initOffset;

  const DismissibleBackground({
    super.key,
    required this.dismissProgress,
    required this.color,
    this.isReversed = false,
    required this.initOffset,
    required this.child,
  });

  double _getOffset(BuildContext context) =>
      dismissProgress * -(MediaQuery.of(context).size.width - 16) + initOffset;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Viewport(
        axisDirection: isReversed ? AxisDirection.left : AxisDirection.right,
        slivers: [
          SliverToBoxAdapter(
            child: Container(alignment: Alignment.centerLeft, child: child),
          )
        ],
        offset: ViewportOffset.fixed(_getOffset(context)),
      ),
    );
  }
}
