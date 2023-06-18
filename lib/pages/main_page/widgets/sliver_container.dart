import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// 🔥🔥🔥
class SliverContainer extends SingleChildRenderObjectWidget {
  const SliverContainer({super.key, required this.decoration, super.child});

  final Decoration decoration;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return SliverContainerRender(decoration: decoration);
  }
}

class SliverContainerRender extends RenderProxySliver {
  SliverContainerRender({required Decoration decoration})
      : _decoration = decoration;

  BoxPainter? _painter;

  Decoration get decoration => _decoration;
  Decoration _decoration;

  set decoration(Decoration value) {
    if (value == _decoration) {
      return;
    }
    _painter?.dispose();
    _painter = null;
    _decoration = value;
    markNeedsPaint();
  }

  @override
  void detach() {
    _painter?.dispose();
    _painter = null;
    super.detach();

    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _painter ??= _decoration.createBoxPainter(markNeedsPaint);

    // bool isTopOverflow = constraints.scrollOffset > 0;
    bool isBottomOverflow = geometry!.scrollExtent >
        constraints.scrollOffset + geometry!.paintExtent;

    bool isBottomHalfOverflow = geometry!.scrollExtent >
        constraints.scrollOffset + geometry!.paintExtent + 16;

    final double paintHeight;

    if (!isBottomHalfOverflow) {
      paintHeight = geometry!.scrollExtent - constraints.scrollOffset;
    } else {
      paintHeight = geometry!.paintExtent + (isBottomOverflow ? 16 : 0);
    }

    _painter!.paint(
      context.canvas,
      offset,
      ImageConfiguration(
        size: Size(constraints.crossAxisExtent, paintHeight),
      ),
    );

    super.paint(context, offset);
  }
}
