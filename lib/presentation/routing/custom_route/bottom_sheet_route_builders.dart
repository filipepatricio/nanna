import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/presentation/page/tab_bar/tab_bar_page.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:flutter/cupertino.dart' show CupertinoTheme;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

const double kPreviousPageVisibleOffset = 10;
const Radius _kDefaultTopRadius = Radius.circular(12);
const BoxShadow _kDefaultBoxShadow = BoxShadow(blurRadius: 10, color: AppColors.black40, spreadRadius: 5);
const SystemUiOverlayStyle lightNavBarStyle = SystemUiOverlayStyle(
  // The first three were extracted from SystemOverlay.light
  statusBarIconBrightness: Brightness.light,
  statusBarBrightness: Brightness.dark,
  systemNavigationBarColor: AppColors.background,
  systemNavigationBarDividerColor: AppColors.background,
  systemNavigationBarIconBrightness: Brightness.dark,
);

class _CupertinoBottomSheetContainer extends StatelessWidget {
  const _CupertinoBottomSheetContainer({
    required this.child,
    required this.topRadius,
    this.backgroundColor,
    this.shadow,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final Color? backgroundColor;
  final Radius topRadius;
  final BoxShadow? shadow;

  @override
  Widget build(BuildContext context) {
    final topSafeAreaPadding = MediaQuery.of(context).padding.top;
    final topPadding = kPreviousPageVisibleOffset + topSafeAreaPadding;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: lightNavBarStyle,
      child: Padding(
        padding: EdgeInsets.only(top: topPadding),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: topRadius),
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor ?? CupertinoTheme.of(context).scaffoldBackgroundColor,
              boxShadow: [shadow ?? _kDefaultBoxShadow],
            ),
            width: double.infinity,
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

Route<T> cupertinoBottomSheetPageRouteBuilder<T>(BuildContext context, Widget child, CustomPage page) {
  final scaffold = CupertinoScaffold.of(context) ?? CupertinoScaffold.of(tabBarPageKey.currentContext!);
  final topRadius = scaffold?.topRadius;

  return CupertinoModalBottomSheetRoute<T>(
    builder: (context) => child,
    secondAnimationController: scaffold?.animation,
    containerBuilder: (context, _, child) => _CupertinoBottomSheetContainer(
      topRadius: topRadius ?? _kDefaultTopRadius,
      child: child,
    ),
    expanded: false,
    barrierLabel: '',
    modalBarrierColor: AppColors.black40,
    topRadius: topRadius ?? _kDefaultTopRadius,
    animationCurve: Curves.easeInOutCubic,
    duration: const Duration(milliseconds: 500),
    previousRouteAnimationCurve: null,
    closeProgressThreshold: 0.85,
    settings: page,
  );
}

Route<T> modalFullScreenBottomSheetPageRouteBuilder<T>(BuildContext context, Widget child, CustomPage page) {
  return ModalBottomSheetRoute<T>(
    builder: (context) => child,
    expanded: true,
    barrierLabel: '',
    modalBarrierColor: AppColors.black40,
    animationCurve: Curves.easeInOut,
    duration: const Duration(milliseconds: 350),
    settings: page,
  );
}
