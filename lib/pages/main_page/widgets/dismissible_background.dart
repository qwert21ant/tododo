import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DismissibleBackground extends StatefulWidget {
  final Stream<double> progressStream;
  final Color color;
  final bool isReversed;
  final Widget child;
  final double initOffset;

  const DismissibleBackground({
    super.key,
    required this.progressStream,
    required this.color,
    this.isReversed = false,
    required this.initOffset,
    required this.child,
  });

  @override
  State<DismissibleBackground> createState() => _DismissibleBackgroundState();
}

class _DismissibleBackgroundState extends State<DismissibleBackground> {
  late double dismissProgress;
  late final StreamSubscription streamSubscription;

  @override
  void initState() {
    super.initState();

    dismissProgress = 1;
    streamSubscription = widget.progressStream.listen((value) {
      setState(() {
        dismissProgress = value;
      });
    });
  }

  @override
  void dispose() {
    streamSubscription.cancel();

    super.dispose();
  }

  double _getOffset(BuildContext context) =>
      dismissProgress * -(MediaQuery.of(context).size.width - 16) +
      widget.initOffset;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.color,
      child: Viewport(
        axisDirection:
            widget.isReversed ? AxisDirection.left : AxisDirection.right,
        slivers: [
          SliverToBoxAdapter(
            child:
                Container(alignment: Alignment.centerLeft, child: widget.child),
          )
        ],
        offset: ViewportOffset.fixed(_getOffset(context)),
      ),
    );
  }
}
