import 'package:better_informed_mobile/domain/daily_brief/data/headline.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RelaxView extends HookWidget {
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            //TODO: Show image from api, and remove MockedComputerMan
            // if (goodbyeHeadline.icon != null) ...[
            //   Image.network(
            //     cloudinaryProvider
            //         .withPublicId(goodbyeHeadline.icon)
            //         .transform()
            //         .width(DimensionUtil.getPhysicalPixelsAsInt(168.0, context))
            //         .fit()
            //         .generateNotNull(),
            //   ),
            // ],
            Image.asset(AppRasterGraphics.mockedComputerMan),
            const SizedBox(height: AppDimens.l),
            Padding(
              padding: const EdgeInsets.only(left: AppDimens.c),
              child: InformedMarkdownBody(
                markdown: goodbyeHeadline.headline,
                baseTextStyle: AppTypography.h1Medium,
                highlightColor: AppColors.limeGreen,
                textAlignment: TextAlign.end,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
