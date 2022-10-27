import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/widget/toasts/info_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

void showInfoToast({
  required BuildContext context,
  required String text,
  VoidCallback? onDismiss,
}) {
  showToastWidget(
    InfoToast(text: text),
    context: context,
    animation: StyledToastAnimation.slideFromTop,
    reverseAnimation: StyledToastAnimation.slideToTop,
    animDuration: const Duration(milliseconds: 500),
    position: const StyledToastPosition(align: Alignment.topCenter, offset: AppDimens.xxl),
    isIgnoring: false,
    dismissOtherToast: true,
    duration: const Duration(seconds: 10),
    curve: Curves.easeOutCubic,
    reverseCurve: Curves.easeOutCubic,
    onDismiss: onDismiss,
  );
}
