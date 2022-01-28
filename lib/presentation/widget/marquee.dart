import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Marquee extends HookWidget {
  final Widget child;
  final Axis direction;
  final Duration animationDuration, pauseDuration, backDuration;
  final Function? onDone;

  const Marquee({
    required this.child,
    Key? key,
    this.onDone,
    this.direction = Axis.horizontal,
    this.animationDuration = const Duration(milliseconds: 6000),
    this.backDuration = const Duration(milliseconds: 800),
    this.pauseDuration = const Duration(milliseconds: 800),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController(initialScrollOffset: -50.0);

    useEffect(() {
      if (!kIsTest) {
        WidgetsBinding.instance?.addPostFrameCallback((_) => scroll(scrollController));
      }
    }, [scrollController]);

    return SingleChildScrollView(
      scrollDirection: direction,
      controller: scrollController,
      child: child,
    );
  }

  Future<void> scroll(ScrollController scrollController) async {
    while (scrollController.hasClients) {
      await Future.delayed(pauseDuration);
      if (scrollController.hasClients) {
        await scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: animationDuration,
          curve: Curves.ease,
        );
      }
      await Future.delayed(pauseDuration);
      if (scrollController.hasClients) {
        await scrollController.animateTo(
          0.0,
          duration: backDuration,
          curve: Curves.easeOut,
        );
      }
      onDone?.call();
    }
  }
}
