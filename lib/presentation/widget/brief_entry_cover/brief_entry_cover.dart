import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry_style.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/presentation/routing/main_router.gr.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/article_cover.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/topic_cover.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class BriefEntryCover extends HookWidget {
  const BriefEntryCover({
    required this.briefEntry,
    required this.briefId,
    Key? key,
  }) : super(key: key);

  final BriefEntry briefEntry;
  final String briefId;

  @override
  Widget build(BuildContext context) {
    final item = briefEntry.item;
    final style = briefEntry.style;
    switch (style.type) {
      case BriefEntryStyleType.articleCardWithLargeImage:
        return item.maybeMap(
          article: (data) => data.article.map(
            article: (article) => ArticleCover.dailyBriefLarge(
              article: article,
              editorsNote: article.note,
              onTap: () => context.navigateToArticle(article),
            ),
            unknown: (_) => const SizedBox(),
          ),
          orElse: () => const SizedBox(),
        );
      case BriefEntryStyleType.articleCardWithSmallImage:
        return item.maybeMap(
          article: (data) => data.article.map(
            article: (article) => ArticleCover.dailyBriefSmall(
              article: article,
              coverColor: style.backgroundColor,
              editorsNote: article.note,
              onTap: () => context.navigateToArticle(article),
            ),
            unknown: (_) => const SizedBox(),
          ),
          orElse: () => const SizedBox(),
        );
      case BriefEntryStyleType.topicCard:
        return item.maybeMap(
          topicPreview: (data) => TopicCover.large(
            topic: data.topicPreview,
            onTap: () => context.navigateToTopic(
              topicPreview: data.topicPreview,
              briefId: briefId,
            ),
          ),
          orElse: () => const SizedBox(),
        );
    }
  }
}

extension on BuildContext {
  void navigateToArticle(MediaItemArticle article) {
    pushRoute(
      MediaItemPageRoute(article: article),
    );
  }

  void navigateToTopic({
    required TopicPreview topicPreview,
    required String briefId,
  }) {
    pushRoute(
      TopicPage(
        topicSlug: topicPreview.slug,
        briefId: briefId,
      ),
    );
  }
}
