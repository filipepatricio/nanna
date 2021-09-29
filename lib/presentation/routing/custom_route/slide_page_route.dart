import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

final _slideTween = Tween(begin: const Offset(0, 0.2), end: Offset.zero).chain(CurveTween(curve: Curves.easeIn));
final _scaleTween = Tween(begin: 0.8, end: 1.0).chain(CurveTween(curve: Curves.linear));
final _fadeTween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeOut));

Route<T> slidePageRouteBuilder<T>(BuildContext context, Widget child, CustomPage page) =>
    SlideTopPageRoute<T>(builder: (context) => child, settings: page);

class SlideTopPageRoute<T> extends PageRoute<T> {
  final WidgetBuilder builder;

  SlideTopPageRoute({
    required this.builder,
    required RouteSettings settings,
    bool fullscreenDialog = false,
  }) : super(settings: settings, fullscreenDialog: fullscreenDialog);

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
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
    return _TopSlidePageTransition(
      routeAnimation: animation,
      child: child,
    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class _TopSlidePageTransition extends StatelessWidget {
  final Animation<Offset> _transition;
  final Animation<double> _scale;
  final Animation<double> _fade;
  final Widget child;

  _TopSlidePageTransition({
    required Animation<double> routeAnimation,
    required this.child,
    Key? key,
  })  : _transition = _slideTween.animate(routeAnimation),
        _scale = _scaleTween.animate(routeAnimation),
        _fade = _fadeTween.animate(routeAnimation),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        child: SlideTransition(
          position: _transition,
          child: child,
        ),
      ),
    );
  }
}
