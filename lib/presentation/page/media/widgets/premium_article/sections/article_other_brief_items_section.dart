import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry_item.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/cover_opacity.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/article_cover.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/topic_cover.dart';
import 'package:flutter/material.dart';

typedef ItemTapCallback = Function(BriefEntryItem);

class ArticleMoreFromSection extends StatelessWidget {
  const ArticleMoreFromSection({
    required this.articleId,
    required this.items,
    required this.onItemTap,
    this.briefId,
    this.topicId,
    this.topicTitle,
    Key? key,
  }) : super(key: key);

  final String articleId;
  final List<BriefEntryItem> items;
  final String? briefId;
  final String? topicId;
  final String? topicTitle;
  final ItemTapCallback onItemTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(height: 0),
        Padding(
          padding: const EdgeInsets.all(AppDimens.l),
          child: Text(
            topicTitle != null
                ? LocaleKeys.article_moreFromTopic.tr(args: [topicTitle!])
                : LocaleKeys.article_otherBriefs.tr(),
            style: AppTypography.h1ExtraBold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
          child: items
              .map(
                (briefEntryItem) =>
                    briefEntryItem.mapOrNull(
                      article: (briefItemArticle) => briefItemArticle.article.mapOrNull(
                        article: (mediaItemArticle) => _Article(
                          article: mediaItemArticle,
                          briefId: briefId,
                          topicId: topicId,
                          onItemTap: () => onItemTap(briefEntryItem),
                        ),
                      ),
                      topicPreview: (briefItemTopic) => _Topic(
                        topic: briefItemTopic.topicPreview,
                        briefId: briefId,
                        onItemTap: () => onItemTap(briefEntryItem),
                      ),
                    ) ??
                    const SizedBox.shrink(),
              )
              .reduce(
                (value, element) => Column(
                  children: [
                    value,
                    if (element is SizedBox || value is SizedBox)
                      const SizedBox.shrink()
                    else
                      const Divider(height: AppDimens.xl),
                    element,
                  ],
                ),
              ),
        ),
        const SizedBox(height: AppDimens.l),
      ],
    );
  }
}

class _Article extends StatelessWidget {
  const _Article({
    required this.article,
    required this.onItemTap,
    this.briefId,
    this.topicId,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;
  final String? briefId;
  final String? topicId;
  final VoidCallback onItemTap;

  @override
  Widget build(BuildContext context) {
    return CoverOpacity(
      visited: article.progressState == ArticleProgressState.finished,
      child: ArticleCover.otherBriefItemsList(
        article: article,
        onTap: () {
          onItemTap.call();
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
    required this.onItemTap,
    this.briefId,
    Key? key,
  }) : super(key: key);

  final TopicPreview topic;
  final String? briefId;
  final VoidCallback onItemTap;

  @override
  Widget build(BuildContext context) {
    return CoverOpacity(
      visited: topic.visited,
      child: TopicCover.otherBriefItemsList(
        topic: topic,
        onTap: () {
          onItemTap.call();
          context.navigateToTopic(
            topic: topic,
            briefId: briefId,
          );
        },
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
        slug: article.slug,
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
