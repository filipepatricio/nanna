import 'dart:math';

import 'package:flutter/material.dart';

double calculateLastPageShownFactor(PageController controller, double viewportFraction) {
  final realViewportSize = controller.position.viewportDimension * viewportFraction;
  final viewportCount = (controller.position.maxScrollExtent / realViewportSize).round();
  final position = controller.position.pixels;

  final size = (viewportCount - 1) * realViewportSize;
  if (position > size) {
    final actual = (size - position).abs();
    final factor = actual / realViewportSize;
    return min(factor, 1.0);
  } else {
    return 0.0;
  }
}

void hideKeyboard(){
  FocusManager.instance.primaryFocus?.unfocus();
}

class NoScrollGlow extends NotificationListener<OverscrollIndicatorNotification> {
  NoScrollGlow({required Widget child})
      : super(
          onNotification: (overscroll) {
            overscroll.disallowGlow();
            return false;
          },
          child: child,
        );
}
