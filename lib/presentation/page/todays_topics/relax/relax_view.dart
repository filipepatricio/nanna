import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/headline.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/util/dimension_util.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

class RelaxView extends HookWidget {
  final Headline goodbyeHeadline;

  const RelaxView({
    required this.goodbyeHeadline,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cloudinaryProvider = useCloudinaryProvider();

    return Container(
      margin: const EdgeInsets.only(
        left: AppDimens.l,
        right: AppDimens.l,
        bottom: AppDimens.xxl,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimens.m),
        color: AppColors.darkLinen,
      ),
      height: AppDimens.todaysTopicCardStackHeight(context),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(flex: 1),
          if (goodbyeHeadline.icon != null && !kIsTest)
            CachedNetworkImage(
              imageUrl: cloudinaryProvider
                  .withPublicIdAsPng(goodbyeHeadline.icon!)
                  .transform()
                  .width(DimensionUtil.getPhysicalPixelsAsInt(168.0, context))
                  .fit()
                  .generateNotNull(),
            )
          else
            SvgPicture.asset(AppVectorGraphics.relaxCoffee),
          const SizedBox(height: AppDimens.l),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.m),
            child: InformedMarkdownBody(
              markdown: goodbyeHeadline.headline,
              baseTextStyle: AppTypography.h2Medium,
              highlightColor: AppColors.limeGreen,
              textAlignment: TextAlign.center,
            ),
          ),
          const Spacer(flex: 1),
          if (goodbyeHeadline.message != null) ...[
            const SizedBox(height: AppDimens.ml),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: goodbyeHeadline.message,
                    style: AppTypography.b2Medium,
                  ),
                  const TextSpan(text: ' '),
                  TextSpan(
                    text: LocaleKeys.todaysTopics_goToExplore.tr(),
                    style: AppTypography.b2Bold.copyWith(decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()..onTap = () => _goToExplore(context),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppDimens.l),
        ],
      ),
    );
  }

  void _goToExplore(BuildContext context) {
    context.navigateTo(const ExploreTabGroupRouter(children: [ExplorePageRoute()]));
  }
}
