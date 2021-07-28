import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

Route<T> fadePageRouteBuilder<T>(BuildContext context, Widget child, CustomPage page) =>
    FadePageRoute<T>(builder: (context) => child, settings: page);

class FadePageRoute<T> extends PageRoute<T> {
  FadePageRoute({
    required this.builder,
    required RouteSettings settings,
    this.maintainState = true,
    bool fullscreenDialog = false,
  }) : super(settings: settings, fullscreenDialog: fullscreenDialog);

  ModalBottomSheetRoute? _nextModalRoute;
  final WidgetBuilder builder;

  @override
  final bool maintainState;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 400);

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  void didChangeNext(Route? nextRoute) {
    if (nextRoute is ModalBottomSheetRoute) {
      _nextModalRoute = nextRoute;
    }

    super.didChangeNext(nextRoute);
  }

  @override
  bool didPop(T? result) {
    _nextModalRoute = null;
    return super.didPop(result);
  }

  @override
  bool canTransitionFrom(TransitionRoute<dynamic> previousRoute) {
    return previousRoute is FadePageRoute;
  }

  @override
  bool canTransitionTo(TransitionRoute<dynamic> nextRoute) {
    // Don't perform outgoing animation if the next route is a fullscreen dialog.
    return nextRoute is FadePageRoute && !nextRoute.fullscreenDialog;
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final result = builder(context);
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: result,
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final nextRoute = _nextModalRoute;
    if (nextRoute != null) {
      if (!secondaryAnimation.isDismissed) {
        final defaultTransition = _FadeInPageTransition(routeAnimation: animation, child: child);
        return nextRoute.getPreviousRouteTransition(context, secondaryAnimation, defaultTransition);
      } else {
        _nextModalRoute = null;
      }
    }

    return _FadeInPageTransition(routeAnimation: animation, child: child);
  }

  @override
  String get debugLabel => '${super.debugLabel}(${settings.name})';
}

class _FadeInPageTransition extends StatelessWidget {
  _FadeInPageTransition({
    required Animation<double> routeAnimation,
    required this.child,
    Key? key,
  })  : _opacityAnimation = routeAnimation.drive(_easeInTween),
        super(key: key);

  // Fractional offset from 1/4 screen below the top to fully on screen.
  static final Tween<Offset> _bottomUpTween = Tween<Offset>(
    begin: const Offset(0.0, 0.25),
    end: Offset.zero,
  );
  static final Animatable<double> _easeInTween = CurveTween(curve: Curves.easeIn);

  final Animation<double> _opacityAnimation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: child,
    );
  }
}
