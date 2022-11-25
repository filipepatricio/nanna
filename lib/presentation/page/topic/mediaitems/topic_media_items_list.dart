import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/entry_style.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/article_cover.dart';
import 'package:better_informed_mobile/presentation/widget/track/general_event_tracker/general_event_tracker.dart';
import 'package:better_informed_mobile/presentation/widget/track/view_visibility_notifier/view_visibility_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TopicMediaItemsList extends HookWidget {
  const TopicMediaItemsList({
    required this.topic,
    required this.cubit,
    required this.eventController,
    this.mediaItemKey,
  });

  final Topic topic;
  final TopicPageCubit cubit;
  final GeneralEventTrackingController eventController;
  final GlobalKey? mediaItemKey;

  @override
  Widget build(BuildContext context) {
    final entryList = topic.entries;

    useEffect(
      () {
        _trackReadingListBrowse(0);
      },
      [topic],
    );

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.pageHorizontalMargin),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final entry = topic.entries[index];
            return entry.item.map(
              article: (item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppDimens.xl),
                  child: ViewVisibilityNotifier(
                    detectorKey: Key(item.slug),
                    onVisible: () {
                      _trackReadingListBrowse(index);
                    },
                    borderFraction: 0.6,
                    child: _ArticleItemView(
                      mediaItemKey: index == 0 ? mediaItemKey : null,
                      entryStyle: entry.style,
                      article: item,
                      onTap: () => _navigateToArticle(context, index),
                    ),
                  ),
                );
              },
              unknown: (_) => const SizedBox.shrink(),
            );
          },
          childCount: entryList.length,
        ),
      ),
    );
  }

  void _trackReadingListBrowse(int index) {
    final event = AnalyticsEvent.readingListBrowsed(
      topic.id,
      index,
    );
    eventController.track(event);
  }

  void _navigateToArticle(BuildContext context, int index) {
    AutoRouter.of(context).push(
      MediaItemPageRoute(
        article: topic.articleAt(index),
        topicId: topic.id,
        topicSlug: topic.slug,
        briefId: cubit.briefId,
      ),
    );
  }
}

class _ArticleItemView extends HookWidget {
  const _ArticleItemView({
    required this.onTap,
    required this.article,
    required this.entryStyle,
    this.mediaItemKey,
    Key? key,
  }) : super(key: key);

  final VoidCallback onTap;
  final MediaItemArticle article;
  final EntryStyle entryStyle;
  final GlobalKey? mediaItemKey;

  @override
  Widget build(BuildContext context) {
    return _ArticleCover(
      entryStyle: entryStyle,
      article: article,
      mediaItemKey: mediaItemKey,
      onTap: onTap,
    );
  }
}

class _ArticleCover extends StatelessWidget {
  const _ArticleCover({
    required this.entryStyle,
    required this.article,
    required this.mediaItemKey,
    required this.onTap,
  });

  final EntryStyle entryStyle;
  final MediaItemArticle article;
  final GlobalKey? mediaItemKey;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    switch (entryStyle.type) {
      case EntryStyleType.articleCoverWithBigImage:
        return ArticleCover.large(
          article: article,
          onTap: onTap,
          showNote: true,
          showRecommendedBy: false,
          key: mediaItemKey,
        );
      case EntryStyleType.articleCoverWithoutImage:
        return ArticleCover.large(
          article: article,
          onTap: onTap,
          showNote: true,
          showRecommendedBy: false,
          key: mediaItemKey,
        );
    }
  }
}
