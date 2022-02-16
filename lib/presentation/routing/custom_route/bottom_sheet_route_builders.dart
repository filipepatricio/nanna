import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/presentation/page/main/dashboard_page.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:flutter/cupertino.dart' show CupertinoTheme;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

const double kPreviousPageVisibleOffset = 10;
const Radius _kDefaultTopRadius = Radius.circular(12);
BoxShadow _kDefaultBoxShadow = BoxShadow(blurRadius: 10, color: AppColors.shadowDarkColor, spreadRadius: 5);
const SystemUiOverlayStyle lightNavBarStyle = SystemUiOverlayStyle(
  // The first three were extracted from SystemOverlay.light
  statusBarIconBrightness: Brightness.light,
  statusBarBrightness: Brightness.dark,
  systemNavigationBarColor: AppColors.background,
  systemNavigationBarDividerColor: AppColors.background,
  systemNavigationBarIconBrightness: Brightness.dark,
);

class _CupertinoBottomSheetContainer extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final Radius topRadius;
  final BoxShadow? shadow;

  const _CupertinoBottomSheetContainer({
    required this.child,
    required this.topRadius,
    this.backgroundColor,
    this.shadow,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final topSafeAreaPadding = MediaQuery.of(context).padding.top;
    final topPadding = kPreviousPageVisibleOffset + topSafeAreaPadding;
    final _shadow = shadow ?? _kDefaultBoxShadow;
    final _backgroundColor = backgroundColor ?? CupertinoTheme.of(context).scaffoldBackgroundColor;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: lightNavBarStyle,
      child: Padding(
        padding: EdgeInsets.only(top: topPadding),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: topRadius),
          child: Container(
            decoration: BoxDecoration(color: _backgroundColor, boxShadow: [_shadow]),
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
  final scaffold = CupertinoScaffold.of(context) ?? CupertinoScaffold.of(dashboardPageKey.currentContext!);
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
    modalBarrierColor: AppColors.shadowDarkColor,
    topRadius: topRadius ?? _kDefaultTopRadius,
    animationCurve: Curves.easeInOutCubic,
    duration: const Duration(milliseconds: 500),
    previousRouteAnimationCurve: null,
    settings: page,
  );
}

Route<T> modalFullScreenBottomSheetPageRouteBuilder<T>(BuildContext context, Widget child, CustomPage page) {
  return ModalBottomSheetRoute<T>(
    builder: (context) => child,
    expanded: true,
    barrierLabel: '',
    modalBarrierColor: AppColors.shadowDarkColor,
    animationCurve: Curves.easeInOutCubic,
    duration: const Duration(milliseconds: 500),
    settings: page,
  );
}
