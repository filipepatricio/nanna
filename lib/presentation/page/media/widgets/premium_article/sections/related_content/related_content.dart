import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/categories/data/category_item.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/article_cover.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/topic_cover.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RelatedContent extends HookWidget {
  const RelatedContent({
    required this.relatedContentItems,
    required this.snackbarController,
    this.topicId,
    this.briefId,
    this.onItemTap,
    Key? key,
  }) : super(key: key);

  final List<CategoryItem> relatedContentItems;
  final SnackbarController snackbarController;
  final String? briefId;
  final String? topicId;
  final Function(CategoryItem)? onItemTap;

  @override
  Widget build(BuildContext context) {
    final tileWidth = useMemoized(
      () => MediaQuery.of(context).size.width * AppDimens.exploreTopicCarouselSmallCoverWidthFactor,
      [MediaQuery.of(context).size],
    );
    final tileHeight = useMemoized(
      () => tileWidth * AppDimens.exploreArticleCarouselSmallCoverAspectRatio,
      [MediaQuery.of(context).size],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.m),
            child: Text(
              LocaleKeys.article_relatedContent_similarStories.tr(),
              style: AppTypography.h1Medium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.m),
            child: Text(
              LocaleKeys.article_relatedContent_relatedReads.tr(),
              style: AppTypography.h4Regular,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: AppDimens.m),
            child: SizedBox(
              height: tileHeight,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.m),
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return relatedContentItems[index].mapOrNull(
                        article: (data) =>
                            data.article.mapOrNull(
                              article: (article) => _Article(
                                onItemTap: () => onItemTap?.call(data),
                                article: article,
                                briefId: briefId,
                                topicId: topicId,
                                width: tileWidth,
                                snackbarController: snackbarController,
                              ),
                            ) ??
                            const SizedBox.shrink(),
                        topic: (topic) => _Topic(
                          onItemTap: () => onItemTap?.call(topic),
                          topic: topic.topicPreview,
                          width: tileWidth,
                          briefId: briefId,
                          snackbarController: snackbarController,
                        ),
                      ) ??
                      const SizedBox.shrink();
                },
                itemCount: relatedContentItems.length,
                separatorBuilder: (_, __) => const SizedBox(width: AppDimens.m),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Article extends StatelessWidget {
  const _Article({
    required this.article,
    required this.width,
    required this.onItemTap,
    required this.snackbarController,
    this.briefId,
    this.topicId,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;
  final String? briefId;
  final String? topicId;
  final double width;
  final VoidCallback onItemTap;
  final SnackbarController snackbarController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ArticleCover.exploreCarousel(
        article: article,
        snackbarController: snackbarController,
        onTap: () {
          onItemTap();
          context.navigateToArticle(
            article: article,
            briefId: briefId,
            topicId: topicId,
          );
        },
      ),
    );
  }
}

class _Topic extends StatelessWidget {
  const _Topic({
    required this.topic,
    required this.width,
    required this.onItemTap,
    required this.snackbarController,
    this.briefId,
    Key? key,
  }) : super(key: key);

  final TopicPreview topic;
  final String? briefId;
  final double width;
  final VoidCallback onItemTap;
  final SnackbarController snackbarController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TopicCover.exploreSmall(
        topic: topic,
        onTap: () {
          onItemTap();
          context.navigateToTopic(
            topic: topic,
            briefId: briefId,
          );
        },
        snackbarController: snackbarController,
      ),
    );
  }
}

extension on BuildContext {
  void navigateToArticle({
    required MediaItemArticle article,
    String? briefId,
    String? topicId,
  }) {
    router.popAndPush(
      MediaItemPageRoute(
        article: article,
        briefId: briefId,
        topicId: topicId,
      ),
    );
  }

  void navigateToTopic({
    required TopicPreview topic,
    String? briefId,
  }) {
    router.popAndPush(
      TopicPage(
        topicSlug: topic.slug,
        briefId: briefId,
      ),
    );
  }
}
