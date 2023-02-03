import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry_style.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/presentation/routing/main_router.gr.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/article_cover.dart';
import 'package:better_informed_mobile/presentation/widget/brief_entry_cover/brief_entry_cover_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/topic_cover.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:visibility_detector/visibility_detector.dart';

class BriefEntryCover extends HookWidget {
  const BriefEntryCover({
    required this.entry,
    required this.briefId,
    required this.onVisibilityChanged,
    this.topicCardKey,
    Key? key,
  }) : super(key: key);

  final BriefEntry entry;
  final String briefId;
  final GlobalKey? topicCardKey;
  final Function(VisibilityInfo, BriefEntry) onVisibilityChanged;

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<BriefEntryCoverCubit>();
    final state = useCubitBuilder(cubit);
    final stateBriefEntry = state.map(initializing: (_) => entry, idle: (state) => state.entry);
    final item = stateBriefEntry.item;
    final style = stateBriefEntry.style;
    final isNew = stateBriefEntry.isNew;

    useEffect(
      () {
        cubit.initialize(entry);
      },
      [cubit, entry],
    );

    return VisibilityDetector(
      key: Key(entry.id),
      onVisibilityChanged: (visibility) {
        onVisibilityChanged(visibility, stateBriefEntry);
      },
      child: item.map(
        article: (data) {
          switch (style.type) {
            case BriefEntryStyleType.articleCardLarge:
              return data.article.map(
                article: (article) => ArticleCover.large(
                  article: article,
                  onTap: () async {
                    await context.navigateToArticle(
                      article: article,
                      briefId: briefId,
                    );
                  },
                  isNew: isNew,
                  showNote: true,
                  showRecommendedBy: false,
                ),
                unknown: (_) => const SizedBox(),
              );
            case BriefEntryStyleType.articleCardMedium:
              return data.article.map(
                article: (article) {
                  if (article.hasImage) {
                    return ArticleCover.medium(
                      article: article,
                      onTap: () async {
                        await context.navigateToArticle(
                          article: article,
                          briefId: briefId,
                        );
                      },
                      isNew: isNew,
                      showNote: true,
                      showRecommendedBy: false,
                    );
                  } else {
                    return ArticleCover.large(
                      article: article,
                      onTap: () async {
                        await context.navigateToArticle(
                          article: article,
                          briefId: briefId,
                        );
                      },
                      isNew: isNew,
                      showNote: true,
                      showRecommendedBy: false,
                    );
                  }
                },
                unknown: (_) => const SizedBox(),
              );
            default:
              return const SizedBox();
          }
        },
        topicPreview: (data) {
          switch (style.type) {
            case BriefEntryStyleType.topicCard:
              return item.maybeMap(
                topicPreview: (data) => TopicCover.large(
                  key: topicCardKey,
                  topic: data.topicPreview,
                  isNew: isNew,
                  onTap: () async {
                    await context.navigateToTopic(
                      topicPreview: data.topicPreview,
                      briefId: briefId,
                    );
                  },
                ),
                orElse: () => const SizedBox.shrink(),
              );
            default:
              return const SizedBox();
          }
        },
        unknown: (_) => const SizedBox(),
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
