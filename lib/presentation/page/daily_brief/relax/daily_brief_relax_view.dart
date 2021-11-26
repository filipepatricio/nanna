import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/headline.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/util/dimension_util.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

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
    final cloudinaryProvider = useCloudinaryProvider();

    return ValueListenableBuilder<double>(
      valueListenable: lastPageAnimationProgressState,
      builder: (context, value, child) {
        final animation = AlwaysStoppedAnimation(Offset(-1 - (value > 0.5 ? (value - (1 + value)) : 0), 0));

        return Opacity(
          opacity: value > 0.5 ? (value - (1 - value)) : 0,
          child: SlideTransition(
            position: animation,
            child: child,
          ),
        );
      },
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (goodbyeHeadline.icon != null)
              Image.network(
                cloudinaryProvider
                    .withPublicIdAsPng(goodbyeHeadline.icon!)
                    .transform()
                    .width(DimensionUtil.getPhysicalPixelsAsInt(168.0, context))
                    .fit()
                    .generateNotNull(),
              )
            else
              SvgPicture.asset(AppVectorGraphics.relaxCoffee),
            const SizedBox(height: AppDimens.l),
            InformedMarkdownBody(
              markdown: goodbyeHeadline.headline,
              baseTextStyle: AppTypography.h1,
              highlightColor: AppColors.limeGreen,
              textAlignment: TextAlign.end,
            ),
            if (goodbyeHeadline.message != null) ...[
              const SizedBox(height: AppDimens.ml),
              RichText(
                textAlign: TextAlign.end,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: goodbyeHeadline.message,
                      style: AppTypography.b1Regular,
                    ),
                    TextSpan(
                      text: '\n${LocaleKeys.dailyBrief_goToExplore.tr()}',
                      style: AppTypography.b1Regular.copyWith(decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()..onTap = () => _goToExplore(context),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _goToExplore(BuildContext context) {
    AutoRouter.of(context).navigate(const ExploreTabGroupRouter(children: [ExplorePageRoute()]));
  }
}
