import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RelaxView extends StatelessWidget {
  final ValueNotifier<double> lastPageAnimationProgressState;

  const RelaxView({
    required this.lastPageAnimationProgressState,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimens.xxxl),
      child: AnimatedBuilder(
        animation: lastPageAnimationProgressState,
        builder: (context, child) {
          final animation = AlwaysStoppedAnimation(Offset(0.25 - 0.25 * lastPageAnimationProgressState.value, 0));

          return Opacity(
            opacity: lastPageAnimationProgressState.value,
            child: SlideTransition(
              position: animation,
              child: child,
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppDimens.m),
            Center(
              child: SvgPicture.asset(AppVectorGraphics.sun),
            ),
            const SizedBox(height: AppDimens.m),
            const Text(
              'You’re all informed now.',
              style: AppTypography.h3Bold,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimens.xl),
            const Text(
              'The term bulldog refers to an early edition of a newspaper, usually, the first of the day. Bulldog editions were typically printed and sold to distributors the night before, to be sold first thing in the morning.',
              style: AppTypography.b3Regular,
            ),
          ],
        ),
      ),
    );
  }
}
