import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

Route<T> modalFullScreenBottomSheetPageRouteBuilder<T>(BuildContext context, Widget child, CustomPage page) {
  return ModalBottomSheetRoute<T>(
    builder: (context) => child,
    expanded: true,
    barrierLabel: '',
    modalBarrierColor: AppColors.overlay,
    animationCurve: Curves.easeInOut,
    duration: const Duration(milliseconds: 350),
    settings: page,
  );
}

Route<T> modalBottomSheetPageRouteBuilder<T>(BuildContext context, Widget child, CustomPage page) {
  return ModalBottomSheetRoute<T>(
    builder: (context) => child,
    expanded: false,
    barrierLabel: '',
    modalBarrierColor: AppColors.overlay,
    animationCurve: Curves.easeInOut,
    duration: const Duration(milliseconds: 350),
    settings: page,
  );
}
