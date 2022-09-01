import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry_style.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/presentation/routing/main_router.gr.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/article_cover.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/topic_cover.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:visibility_detector/visibility_detector.dart';

class BriefEntryCover extends HookWidget {
  const BriefEntryCover({
    required this.briefEntry,
    required this.briefId,
    required this.width,
    required this.height,
    this.topicCardKey,
    this.onVisibilityChanged,
    this.padding,
    Key? key,
  }) : super(key: key);

  final BriefEntry briefEntry;
  final String briefId;
  final double width;
  final double height;
  final GlobalKey? topicCardKey;
  final Function(VisibilityInfo)? onVisibilityChanged;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final item = briefEntry.item;
    final style = briefEntry.style;

    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: AppDimens.sl),
      child: VisibilityDetector(
        key: Key(briefEntry.id),
        onVisibilityChanged: onVisibilityChanged,
        child: item.map(
          article: (data) {
            switch (style.type) {
              case BriefEntryStyleType.articleCardWithLargeImage:
                return item.maybeMap(
                  article: (data) => data.article.map(
                    article: (article) => ArticleCover.dailyBriefLarge(
                      article: article,
                      onTap: () async {
                        await context.navigateToArticle(
                          article: article,
                          briefId: briefId,
                        );
                      },
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
                      onTap: () async {
                        await context.navigateToArticle(
                          article: article,
                          briefId: briefId,
                        );
                      },
                    ),
                    unknown: (_) => const SizedBox(),
                  ),
                  orElse: () => const SizedBox(),
                );
              case BriefEntryStyleType.articleCardSmallItem:
                return item.maybeMap(
                  article: (data) => data.article.map(
                    article: (article) => ArticleCover.dailyBriefList(
                      article: article,
                      backgroundColor: style.backgroundColor,
                      onTap: () async {
                        await context.navigateToArticle(
                          article: article,
                          briefId: briefId,
                        );
                      },
                    ),
                    unknown: (_) => const SizedBox(),
                  ),
                  orElse: () => const SizedBox(),
                );
              default:
                return const SizedBox();
            }
          },
          topicPreview: (data) {
            switch (style.type) {
              case BriefEntryStyleType.topicCard:
                return item.maybeMap(
                  topicPreview: (data) => LimitedBox(
                    key: topicCardKey,
                    maxWidth: width,
                    maxHeight: height,
                    child: TopicCover.dailyBrief(
                      topic: data.topicPreview,
                      onTap: () async {
                        await context.navigateToTopic(
                          topicPreview: data.topicPreview,
                          briefId: briefId,
                        );
                      },
                    ),
                  ),
                  orElse: () => const SizedBox.shrink(),
                );
              default:
                return const SizedBox();
            }
          },
          unknown: (_) => const SizedBox(),
        ),
      ),
    );
  }
}

extension on BuildContext {
  Future<void> navigateToArticle({
    required MediaItemArticle article,
    required String briefId,
  }) async {
    await pushRoute(
      MediaItemPageRoute(
        article: article,
        briefId: briefId,
      ),
    );
  }

  Future<void> navigateToTopic({
    required TopicPreview topicPreview,
    required String briefId,
  }) async {
    await pushRoute(
      TopicPage(
        topicSlug: topicPreview.slug,
        briefId: briefId,
      ),
    );
  }
}
