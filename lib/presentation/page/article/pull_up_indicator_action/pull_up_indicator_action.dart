import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

typedef IndicatorBuilder = Widget Function(BuildContext context, double factor);
typedef TriggerFunction = void Function(Completer completer);

class SliverPullUpIndicatorAction extends HookWidget {
  final IndicatorBuilder builder;
  final double fullExtentHeight;
  final double triggerExtent;
  final TriggerFunction triggerFunction;

  const SliverPullUpIndicatorAction({
    required this.builder,
    required this.triggerFunction,
    this.fullExtentHeight = 100.0,
    this.triggerExtent = 120.0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final keepExtent = useState(false);

    return _PullUpIndicatorActionSliverObject(
      fullExtentHeight: fullExtentHeight,
      keepExtent: keepExtent.value,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxHeight > triggerExtent && !keepExtent.value) {
            WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
              keepExtent.value = true;

              final completer = Completer();
              completer.future.then((value) {
                keepExtent.value = false;
              });
              triggerFunction(completer);
            });
          }

          final factor = min(constraints.maxHeight / fullExtentHeight, 1.0);

          return OverflowBox(
            alignment: Alignment.topCenter,
            maxHeight: fullExtentHeight,
            child: builder(context, factor),
          );
        },
      ),
    );
  }
}

class _PullUpIndicatorActionSliverObject extends SingleChildRenderObjectWidget {
  final double fullExtentHeight;
  final bool keepExtent;

  const _PullUpIndicatorActionSliverObject({
    required this.fullExtentHeight,
    required this.keepExtent,
    required Widget child,
    Key? key,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderPullUpIndicatorActionSliver(
      fullExtentHeight: fullExtentHeight,
      keepExtent: keepExtent,
    );
  }

  @override
  void updateRenderObject(BuildContext context, covariant _RenderPullUpIndicatorActionSliver renderObject) {
    renderObject
      ..fullExtentHeight = fullExtentHeight
      ..keepExtent = keepExtent;
  }
}

class _RenderPullUpIndicatorActionSliver extends RenderSliver with RenderObjectWithChildMixin<RenderBox> {
  _RenderPullUpIndicatorActionSliver({
    required double fullExtentHeight,
    required bool keepExtent,
    RenderBox? child,
  })  : _fullExtentHeight = fullExtentHeight,
        _keepExtent = keepExtent {
    this.child = child;
  }

  double _fullExtentHeight;

  set fullExtentHeight(double value) {
    if (value != _fullExtentHeight) {
      _fullExtentHeight = value;
      markNeedsLayout();
    }
  }

  bool _keepExtent;

  set keepExtent(bool value) {
    if (value != _keepExtent) {
      _keepExtent = value;
      markNeedsLayout();
    }
  }

  @override
  void performLayout() {
    final overscrollExtent = constraints.remainingPaintExtent > 0.0 ? constraints.remainingPaintExtent : 0.0;
    final layoutExtent = _keepExtent ? _fullExtentHeight : 0.0;
    final active = constraints.remainingPaintExtent > 0.0 || layoutExtent > 0.0;

    child!.layout(
      constraints.asBoxConstraints(
        maxExtent: layoutExtent + overscrollExtent,
      ),
      parentUsesSize: true,
    );

    if (active) {
      geometry = SliverGeometry(
        scrollExtent: layoutExtent,
        paintOrigin: -constraints.scrollOffset,
        paintExtent: min(overscrollExtent, _fullExtentHeight),
        maxPaintExtent: _fullExtentHeight,
      );
    } else {
      geometry = SliverGeometry.zero;
    }
  }

  @override
  void paint(PaintingContext paintContext, Offset offset) {
    if (constraints.remainingPaintExtent > 0.0 || (child?.size.height ?? 0.0) > 0.0) {
      paintContext.paintChild(child!, offset);
    }
  }
}
