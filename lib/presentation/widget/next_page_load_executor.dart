import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class NextPageLoadExecutor extends HookWidget {
  const NextPageLoadExecutor({
    required this.scrollController,
    required this.onNextPageLoad,
    required this.enabled,
    required this.child,
    Key? key,
  }) : super(key: key);

  final ScrollController scrollController;
  final VoidCallback onNextPageLoad;
  final bool enabled;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    useEffect(
      () {
        final listener = enabled
            ? () {
                final position = scrollController.position;

                if (position.maxScrollExtent - position.pixels < (screenHeight / 2)) {
                  onNextPageLoad();
                }
              }
            : () {};
        scrollController.addListener(listener);
        return () => scrollController.removeListener(listener);
      },
      [scrollController, enabled],
    );

    return child;
  }
}
