import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry_item.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/article_cover.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/topic_cover.dart';
import 'package:flutter/material.dart';

class ArticleOtherBriefItemsSection extends StatelessWidget {
  const ArticleOtherBriefItemsSection({
    required this.otherBriefItems,
    this.briefId,
    this.topicId,
    Key? key,
  }) : super(key: key);

  final List<BriefEntryItem> otherBriefItems;
  final String? briefId;
  final String? topicId;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(height: 0),
        Padding(
          padding: const EdgeInsets.all(AppDimens.l),
          child: Text(
            LocaleKeys.article_otherBriefs.tr(),
            style: AppTypography.h1ExtraBold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
          child: otherBriefItems
              .map(
                (e) =>
                    e.mapOrNull(
                      article: (data) => data.article.mapOrNull(
                        article: (data) => _Article(
                          article: data,
                          briefId: briefId,
                          topicId: topicId,
                        ),
                      ),
                      topicPreview: (data) => _Topic(
                        topic: data.topicPreview,
                        briefId: briefId,
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
    this.briefId,
    this.topicId,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;
  final String? briefId;
  final String? topicId;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: article.progressState == ArticleProgressState.finished ? 0.30 : 1,
      child: ArticleCover.otherBriefItemsList(
        article: article,
        onTap: () => _navigateToArticle(
          context: context,
          article: article,
          briefId: briefId,
          topicId: topicId,
        ),
      ),
    );
  }
}

class _Topic extends StatelessWidget {
  const _Topic({
    required this.topic,
    this.briefId,
    Key? key,
  }) : super(key: key);

  final TopicPreview topic;
  final String? briefId;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: topic.visited ? 0.30 : 1,
      child: TopicCover.otherBriefItemsList(
        topic: topic,
        onTap: () => _navigateToTopic(
          context: context,
          topic: topic,
          briefId: briefId,
        ),
      ),
    );
  }
}

void _navigateToArticle({
  required BuildContext context,
  required MediaItemArticle article,
  String? briefId,
  String? topicId,
}) {
  AutoRouter.of(context).push(
    MediaItemPageRoute(
      article: article,
      briefId: briefId,
      topicId: topicId,
      slug: article.slug,
    ),
  );
}

void _navigateToTopic({
  required BuildContext context,
  required TopicPreview topic,
  String? briefId,
}) {
  AutoRouter.of(context).push(
    TopicPage(
      topicSlug: topic.slug,
      briefId: briefId,
    ),
  );
}
