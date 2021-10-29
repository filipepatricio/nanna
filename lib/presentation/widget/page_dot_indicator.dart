import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _dotSpacing = AppDimens.m;

const _dotMaxSize = 10.0;
const _dotMinSize = 8.0;

const _dotMaxAlpha = 1.0;
const _dotMinAlpha = 0.1;

class PageDotIndicator extends HookWidget {
  final PageController controller;
  final int pageCount;

  const PageDotIndicator({
    required this.controller,
    required this.pageCount,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentPageState = useState(0.0);

    useEffect(
      () {
        final onPageChanged = () {
          currentPageState.value = controller.page ?? 0.0;
        };
        controller.addListener(onPageChanged);
        return () => controller.removeListener(onPageChanged);
      },
      [controller],
    );

    final inBetweenProgress = useMemoized(
      () => _calculateInBetweenProgress(currentPageState.value),
      [currentPageState.value],
    );

    final leftDotIndex = currentPageState.value.floor();
    final leftDotProgress = 1 - inBetweenProgress;

    final rightDotIndex = currentPageState.value.ceil();
    final rightDotProgress = inBetweenProgress;

    Widget content;

    if (leftDotIndex == rightDotIndex) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: _generateDotsWithSingleActive(leftDotIndex),
      );
    } else {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: _generateDots(
          leftDotIndex,
          rightDotIndex,
          leftDotProgress,
          rightDotProgress,
        ),
      );
    }

    return Container(
      height: _dotMaxSize,
      child: content,
    );
  }

  List<Widget> _generateDotsWithSingleActive(int position) {
    return List.generate(pageCount, (index) => _Dot(progress: index == position ? 1.0 : 0.0))
        .expand(
          (element) => [
            element,
            const SizedBox(width: _dotSpacing),
          ],
        )
        .toList(growable: false);
  }

  List<Widget> _generateDots(
    int leftPosition,
    int rightPosition,
    double leftProgress,
    double rightProgress,
  ) {
    return List.generate(pageCount, (index) {
      if (index == leftPosition) {
        return _Dot(progress: leftProgress);
      } else if (index == rightPosition) {
        return _Dot(progress: rightProgress);
      } else {
        return const _Dot(progress: 0.0);
      }
    })
        .expand(
          (element) => [
            element,
            const SizedBox(width: _dotSpacing),
          ],
        )
        .toList(growable: false);
  }

  double _calculateInBetweenProgress(double currentPage) => currentPage - currentPage.floor();
}

class _Dot extends StatelessWidget {
  final double progress;

  const _Dot({
    required this.progress,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = _dotMinSize + (_dotMaxSize - _dotMinSize) * progress;
    final alpha = _dotMinAlpha + (_dotMaxAlpha - _dotMinAlpha) * progress;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.darkGreyBackground.withOpacity(alpha),
      ),
    );
  }
}