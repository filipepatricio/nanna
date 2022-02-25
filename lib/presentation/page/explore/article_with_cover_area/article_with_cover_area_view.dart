import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_event.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content_area.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/explore/article_with_cover_area/article_list_item.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/widget/cloudinary_progressive_image.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/link_label.dart';
import 'package:better_informed_mobile/presentation/widget/publisher_logo.dart';
import 'package:better_informed_mobile/presentation/widget/see_all_arrow.dart';
import 'package:better_informed_mobile/presentation/widget/track/general_event_tracker/general_event_tracker.dart';
import 'package:better_informed_mobile/presentation/widget/track/horizontal_list_interaction_listener.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ArticleWithCoverAreaView extends HookWidget {
  final ExploreContentAreaArticleWithFeature area;

  const ArticleWithCoverAreaView({
    required this.area,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final eventController = useEventTrackController();
    final themeColor = Color(area.backgroundColor);

    return Container(
      color: themeColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppDimens.l),
          GestureDetector(
            onTap: () => _navigateToSeeAll(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
              child: Row(
                children: [
                  Expanded(
                    child: InformedMarkdownBody(
                      markdown: area.title,
                      baseTextStyle: AppTypography.h2Jakarta,
                      highlightColor: AppColors.transparent,
                      maxLines: 2,
                    ),
                  ),
                  SeeAllArrow(onTap: () => _navigateToSeeAll(context)),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDimens.l),
          Container(
            padding: const EdgeInsets.only(left: AppDimens.l),
            height: AppDimens.exploreAreaFeaturedArticleHeight,
            child: _MainArticle(
              entry: area.featuredArticle,
              themeColor: themeColor,
            ),
          ),
          const SizedBox(height: AppDimens.l),
          GeneralEventTracker(
            controller: eventController,
            child: HorizontalListInteractionListener(
              itemsCount: area.articles.length,
              callback: (int lastVisibleItemIndex) {
                eventController.track(
                  AnalyticsEvent.exploreAreaCarouselBrowsed(
                    area.id,
                    lastVisibleItemIndex,
                  ),
                );
              },
              child: SizedBox(
                height: AppDimens.exploreAreaArticleListItemHeight,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                  itemBuilder: (context, index) => index == area.articles.length
                      ? SeeAllArticlesListItem(
                          onTap: () => _navigateToSeeAll(context),
                        )
                      : ArticleListItem(
                          article: area.articles[index],
                          themeColor: themeColor,
                          cardColor: AppColors.white,
                        ),
                  separatorBuilder: (context, index) => const SizedBox(width: AppDimens.s),
                  itemCount: area.articles.length + 1,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDimens.xl),
        ],
      ),
    );
  }

  void _navigateToSeeAll(BuildContext context) => AutoRouter.of(context).push(
        ArticleSeeAllPageRoute(
          areaId: area.id,
          title: area.title,
          entries: [area.featuredArticle] + area.articles,
        ),
      );
}

class _MainArticle extends HookWidget {
  final MediaItemArticle entry;
  final Color themeColor;

  const _MainArticle({
    required this.entry,
    required this.themeColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cloudinaryProvider = useCloudinaryProvider();
    final imageId = entry.image?.publicId;

    return GestureDetector(
      onTap: () => AutoRouter.of(context).push(
        MediaItemPageRoute(article: entry),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) => Stack(
          children: [
            Container(
              height: AppDimens.exploreAreaFeaturedArticleHeight,
              foregroundDecoration: BoxDecoration(
                color: imageId != null ? AppColors.black.withOpacity(0.4) : AppColors.background,
              ),
              child: imageId != null
                  ? CloudinaryProgressiveImage(
                      cloudinaryTransformation: cloudinaryProvider
                          .withPublicIdAsPlatform(imageId)
                          .transform()
                          .withLogicalSize(constraints.maxWidth, constraints.maxHeight, context)
                          .autoGravity(),
                      height: constraints.maxHeight,
                      width: constraints.maxWidth,
                      testImage: AppRasterGraphics.testArticleHeroImage,
                    )
                  : Container(),
            ),
            Positioned.fill(
              child: _MainArticleCover(
                entry: entry,
                themeColor: themeColor,
                hasImage: imageId != null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MainArticleCover extends StatelessWidget {
  final MediaItemArticle entry;
  final Color themeColor;
  final bool hasImage;

  const _MainArticleCover({
    required this.entry,
    required this.themeColor,
    required this.hasImage,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeToRead = entry.timeToRead;
    final foregroundColor = hasImage ? AppColors.white : AppColors.textPrimary;

    return Container(
      padding: const EdgeInsets.fromLTRB(AppDimens.l, AppDimens.xl, AppDimens.l, AppDimens.l),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (hasImage)
            PublisherLogo.light(publisher: entry.publisher)
          else
            PublisherLogo.dark(publisher: entry.publisher),
          const SizedBox(height: AppDimens.m),
          InformedMarkdownBody(
            markdown: entry.title,
            baseTextStyle: AppTypography.h1Bold.copyWith(color: foregroundColor),
          ),
          const SizedBox(height: AppDimens.m),
          LinkLabel(
            labelText: LocaleKeys.article_readMore.tr(),
            foregroundColor: foregroundColor,
            onTap: () => AutoRouter.of(context).push(
              MediaItemPageRoute(article: entry),
            ),
          ),
          const Spacer(),
          if (timeToRead != null)
            Text(
              LocaleKeys.article_readMinutes.tr(args: [timeToRead.toString()]),
              style: AppTypography.metadata1Regular.copyWith(color: foregroundColor),
            ),
        ],
      ),
    );
  }
}
