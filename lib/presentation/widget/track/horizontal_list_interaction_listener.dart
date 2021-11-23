import 'package:flutter/material.dart';

typedef InteractionCallback = void Function(int lastVisibleItemIndex);

class HorizontalListInteractionListener extends StatelessWidget {
  final Widget child;
  final InteractionCallback callback;
  final int itemsCount;

  const HorizontalListInteractionListener({
    required this.child,
    required this.callback,
    required this.itemsCount,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollEndNotification>(
      onNotification: (end) {
        final max = end.metrics.maxScrollExtent;
        final viewport = end.metrics.viewportDimension;
        final itemWidth = (max + viewport) / itemsCount;
        final current = end.metrics.pixels;
        final lastVisibleItemIndex = ((current + viewport) / itemWidth).round();

        callback(lastVisibleItemIndex);

        return false;
      },
      child: child,
    );
  }
}
