import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/article/article_item_view.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/track/general_event_tracker/general_event_tracker.dart';
import 'package:better_informed_mobile/presentation/widget/track/view_visibility_notifier/view_visibility_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TopicMediaItemsList extends HookWidget {
  final ValueNotifier<int> pageIndex;
  final Topic topic;
  final TopicPageCubit cubit;
  final GeneralEventTrackerController eventController;
  final GlobalKey? mediaItemKey;

  const TopicMediaItemsList({
    required this.pageIndex,
    required this.topic,
    required this.cubit,
    required this.eventController,
    this.mediaItemKey,
  });

  @override
  Widget build(BuildContext context) {
    final entryList = topic.entries;

    useEffect(
      () {
        _trackReadingListBrowse(0);
      },
      [topic],
    );

    return Container(
      color: AppColors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.l, vertical: AppDimens.xl),
            child: Text(
              LocaleKeys.todaysTopics_articlesCount.tr(args: [topic.entries.length.toString()]),
              style: AppTypography.h2Jakarta,
              maxLines: 1,
            ),
          ),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
            separatorBuilder: (context, index) => const SizedBox(height: AppDimens.l),
            itemCount: entryList.length,
            itemBuilder: (context, index) {
              final entry = topic.entries[index];
              if (entry.item is MediaItemArticle) {
                final article = entry.item as MediaItemArticle;
                return ViewVisibilityNotifier(
                  detectorKey: Key(article.slug),
                  onVisible: () {
                    _trackReadingListBrowse(index);
                  },
                  borderFraction: 0.6,
                  child: ArticleItemView(
                    mediaItemKey: index == 0 ? mediaItemKey : null,
                    entryStyle: entry.style,
                    article: article,
                    editorsNote: entry.note,
                    onTap: () => _navigateToArticle(context, index),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(height: AppDimens.xl)
        ],
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
        briefId: cubit.briefId,
      ),
    );
    return;
  }
}
