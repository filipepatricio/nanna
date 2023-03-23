import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _fadeViewHeight = 48.0;

class BottomListFadeView extends HookWidget {
  const BottomListFadeView({
    required this.scrollController,
    required this.child,
    super.key,
  });

  final ScrollController scrollController;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final visibilityFactor = useMemoized(() => ValueNotifier(0.0));

    useEffect(
      () {
        void scrollListener() {
          if (!scrollController.hasClients) return;
          final pixels = scrollController.position.pixels;
          final maxExtent = scrollController.position.maxScrollExtent;
          final pixelsToEnd = maxExtent - pixels;

          if (maxExtent > 0 && pixelsToEnd < _fadeViewHeight) {
            final factor = pixelsToEnd / _fadeViewHeight;
            visibilityFactor.value = factor;
          } else if (maxExtent > 0) {
            visibilityFactor.value = 1.0;
          } else {
            visibilityFactor.value = 0.0;
          }
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollListener();
        });

        scrollController.addListener(scrollListener);
        return () => scrollController.removeListener(scrollListener);
      },
      [scrollController, child],
    );

    return Stack(
      children: [
        child,
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ValueListenableBuilder(
            valueListenable: visibilityFactor,
            builder: (context, value, child) {
              final height = _fadeViewHeight * value;
              return SizedBox(
                height: height,
                child: child,
              );
            },
            child: ConstrainedBox(
              constraints: const BoxConstraints.expand(),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.of(context).shadowDividerColors[1].withOpacity(0.0),
                      AppColors.of(context).shadowDividerColors[1],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
