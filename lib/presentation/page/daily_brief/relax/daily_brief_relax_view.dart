import 'package:better_informed_mobile/domain/daily_brief/data/headline.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RelaxView extends StatelessWidget {
  final ValueNotifier<double> lastPageAnimationProgressState;
  final Headline goodbyeHeadline;

  const RelaxView({
    required this.lastPageAnimationProgressState,
    required this.goodbyeHeadline,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimens.xxxl),
      child: ValueListenableBuilder<double>(
        valueListenable: lastPageAnimationProgressState,
        builder: (context, value, child) {
          final animation = AlwaysStoppedAnimation(Offset(0.25 - 0.25 * value, 0));

          return Opacity(
            opacity: value,
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
            Text(
              goodbyeHeadline.headline,
              style: AppTypography.h3Bold,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimens.xl),
            Text(
              goodbyeHeadline.message,
              style: AppTypography.b3Regular,
            ),
          ],
        ),
      ),
    );
  }
}
