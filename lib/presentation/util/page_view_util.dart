import 'dart:math';

import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:flutter/material.dart';

double calculateLastPageShownFactor(ScrollController controller, double listItemsHeight) {
  final listItemsCount = (controller.position.maxScrollExtent / listItemsHeight).round();
  final position = controller.position.pixels + AppDimens.appBarHeight;
  final topicCardsListHeight = (listItemsCount - 1) * listItemsHeight;

  if (position > topicCardsListHeight) {
    final actual = (topicCardsListHeight - position).abs();
    final factor = actual / listItemsHeight;
    return min(factor, 1.0);
  } else {
    return 0.0;
  }
}

void hideKeyboard() {
  FocusManager.instance.primaryFocus?.unfocus();
}

class NoScrollGlow extends NotificationListener<OverscrollIndicatorNotification> {
  NoScrollGlow({required Widget child})
      : super(
          onNotification: (overscroll) {
            overscroll.disallowIndicator();
            return false;
          },
          child: child,
        );
}
