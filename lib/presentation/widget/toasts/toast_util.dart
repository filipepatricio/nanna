import 'package:flutter/cupertino.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import 'info_toast.dart';

void showToast(BuildContext context, String text) {
  showToastWidget(
    InfoToast(text: text),
    context: context,
    animation: StyledToastAnimation.slideFromTop,
    reverseAnimation: StyledToastAnimation.slideToTop,
    animDuration: const Duration(milliseconds: 500),
    position: const StyledToastPosition(align: Alignment(0.0, -1.2), offset: 0),
    isIgnoring: false,
    dismissOtherToast: true,
    duration: const Duration(seconds: 10),
    curve: Curves.easeOutCubic,
    reverseCurve: Curves.easeOutCubic,
  );
}
