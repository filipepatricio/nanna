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

enum RelaxViewType { dailyBrief, article }

class RelaxView extends StatelessWidget {
  const RelaxView._({
    required this.type,
    this.headline,
    this.briefId,
    Key? key,
  }) : super(key: key);

  factory RelaxView.dailyBrief({
    required Headline headline,
  }) =>
      RelaxView._(
        type: RelaxViewType.dailyBrief,
        headline: headline,
      );

  factory RelaxView.article(
    String? briefId,
  ) =>
      RelaxView._(
        type: RelaxViewType.article,
        briefId: briefId,
      );

  final RelaxViewType type;
  final Headline? headline;
  final String? briefId;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimens.m),
        color: () {
          switch (type) {
            case RelaxViewType.dailyBrief:
              return AppColors.darkLinen;
            case RelaxViewType.article:
              return AppColors.linen;
          }
        }(),
      ),
      height: AppDimens.briefEntryCardStackHeight,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(flex: 1),
          () {
            switch (type) {
              case RelaxViewType.dailyBrief:
                return _DailyBriefContent(headline!);
              case RelaxViewType.article:
                return const _ArticleContent();
            }
          }(),
          const Spacer(flex: 1),
          () {
            switch (type) {
              case RelaxViewType.dailyBrief:
                return _DailyBriefFooter(headline!.message);
              case RelaxViewType.article:
                return _ArticleFooter(briefId);
            }
          }(),
          const SizedBox(height: AppDimens.l),
        ],
      ),
    );
  }
}

class _DailyBriefContent extends HookWidget {
  const _DailyBriefContent(this.headline, {Key? key}) : super(key: key);

  final Headline headline;

  @override
  Widget build(BuildContext context) {
    const headlineIconWidth = 168.0;
    final cloudinaryProvider = useCloudinaryProvider();

    return Padding(
      padding: const EdgeInsets.all(AppDimens.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (headline.icon != null && !kIsTest)
            CachedNetworkImage(
              imageUrl: cloudinaryProvider
                  .withPublicId(headline.icon!)
                  .transform()
                  .width(DimensionUtil.getPhysicalPixelsAsInt(headlineIconWidth, context))
                  .fit()
                  .generateNotNull(headline.icon!, imageType: ImageType.png),
            )
          else
            SvgPicture.asset(AppVectorGraphics.relaxCoffee),
          const SizedBox(height: AppDimens.m),
          InformedMarkdownBody(
            markdown: headline.headline,
            baseTextStyle: AppTypography.h2Medium,
            highlightColor: AppColors.limeGreen,
            textAlignment: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _DailyBriefFooter extends StatelessWidget {
  const _DailyBriefFooter(this.message, {Key? key}) : super(key: key);

  final String? message;

  @override
  Widget build(BuildContext context) {
    return message?.isNotEmpty ?? false
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: message,
                      style: AppTypography.b2Medium,
                    ),
                    const TextSpan(text: ' '),
                    TextSpan(
                      text: LocaleKeys.dailyBrief_goToExplore.tr(),
                      style: AppTypography.b2Bold.copyWith(decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()..onTap = context.goToExplore,
                    ),
                  ],
                ),
              ),
            ],
          )
        : const SizedBox.shrink();
  }
}

class _ArticleContent extends StatelessWidget {
  const _ArticleContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimens.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(AppVectorGraphics.bigSearch),
          const SizedBox(height: AppDimens.m),
          InformedMarkdownBody(
            markdown: "_${LocaleKeys.article_relatedContent_cantGetEnough.tr()}_",
            baseTextStyle: AppTypography.h2Medium,
            highlightColor: AppColors.limeGreen,
            textAlignment: TextAlign.center,
          ),
          Text(
            LocaleKeys.article_relatedContent_thereAreManyMore.tr(),
            style: AppTypography.h2Medium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ArticleFooter extends StatelessWidget {
  const _ArticleFooter(
    this.briefId, {
    Key? key,
  }) : super(key: key);

  final String? briefId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: context.goToExplore,
      child: Text(
        (briefId != null ? LocaleKeys.article_relatedContent_goToExplore : LocaleKeys.article_goBackToExplore).tr(),
        style: AppTypography.b2Bold.copyWith(decoration: TextDecoration.underline),
        textAlign: TextAlign.center,
      ),
    );
  }
}

extension on BuildContext {
  void goToExplore() {
    navigateTo(
      const TabBarPageRoute(
        children: [
          ExploreTabGroupRouter(
            children: [
              ExplorePageRoute(),
            ],
          )
        ],
      ),
    );
  }
}
