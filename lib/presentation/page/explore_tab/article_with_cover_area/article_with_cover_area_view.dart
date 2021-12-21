import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_event.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content_area.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/explore_tab/article_with_cover_area/article_list_item.dart';
import 'package:better_informed_mobile/presentation/page/media/media_item_page_data.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/widget/cloudinary_progressive_image.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/publisher_logo.dart';
import 'package:better_informed_mobile/presentation/widget/read_more_label.dart';
import 'package:better_informed_mobile/presentation/widget/share/article_button/share_article_button.dart';
import 'package:better_informed_mobile/presentation/widget/track/general_event_tracker/general_event_tracker.dart';
import 'package:better_informed_mobile/presentation/widget/track/horizontal_list_interaction_listener.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

const _mainArticleHeight = 366.0;
const _mainArticleCoverBottomMargin = 100.0;

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
          const SizedBox(height: AppDimens.xxl),
          Container(
            padding: const EdgeInsets.only(left: AppDimens.l, right: AppDimens.sl),
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
                IconButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: () => AutoRouter.of(context).push(
                    ArticleSeeAllPageRoute(
                      areaId: area.id,
                      title: area.title,
                      entries: [area.featuredArticle] + area.articles,
                    ),
                  ),
                  icon: SvgPicture.asset(
                    AppVectorGraphics.fullArrowRight,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimens.l),
          Container(
            padding: const EdgeInsets.only(left: AppDimens.l),
            height: _mainArticleHeight,
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
                height: listItemHeight,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                  itemBuilder: (context, index) => ArticleListItem(
                    article: area.articles[index],
                    themeColor: themeColor,
                    cardColor: AppColors.white,
                  ),
                  separatorBuilder: (context, index) => const SizedBox(width: AppDimens.s),
                  itemCount: area.articles.length,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDimens.xxl),
        ],
      ),
    );
  }
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
        MediaItemPageRoute(
          pageData: MediaItemPageData.singleItem(
            article: entry,
          ),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) => Stack(
          children: [
            Container(
              height: _mainArticleHeight,
              child: imageId != null
                  ? CloudinaryProgressiveImage(
                      cloudinaryTransformation: cloudinaryProvider
                          .withPublicIdAsPlatform(imageId)
                          .transform()
                          .withLogicalSize(constraints.maxWidth, constraints.maxHeight, context)
                          .autoGravity(),
                      height: constraints.maxHeight,
                      width: constraints.maxWidth,
                    )
                  : Container(),
            ),
            Positioned.fill(
              child: Container(
                color: AppColors.black.withOpacity(0.4),
              ),
            ),
            Positioned(
              top: AppDimens.zero,
              left: AppDimens.zero,
              bottom: _mainArticleCoverBottomMargin,
              right: constraints.maxWidth * 0.45,
              child: _MainArticleCover(
                entry: entry,
                themeColor: themeColor,
              ),
            ),
            Positioned(
              top: AppDimens.l,
              right: AppDimens.l,
              child: ShareArticleButton(
                article: entry,
              ),
            ),
            const Positioned(
              bottom: AppDimens.l,
              right: AppDimens.l,
              child: ReadMoreLabel(
                foregroundColor: AppColors.white,
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

  const _MainArticleCover({
    required this.entry,
    required this.themeColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeToRead = entry.timeToRead;

    return Container(
      padding: const EdgeInsets.all(AppDimens.m),
      color: AppColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PublisherLogo.light(publisher: entry.publisher),
          InformedMarkdownBody(
            markdown: entry.title,
            baseTextStyle: AppTypography.h3bold,
            maxLines: 4,
          ),
          const Spacer(),
          if (timeToRead != null)
            Text(
              LocaleKeys.article_readMinutes.tr(
                args: [timeToRead.toString()],
              ),
              style: AppTypography.metadata1Regular,
            ),
        ],
      ),
    );
  }
}
