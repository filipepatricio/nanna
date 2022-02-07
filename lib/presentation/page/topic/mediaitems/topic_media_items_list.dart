import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_event.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/article/article_item_view.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/bottom_stacked_cards.dart';
import 'package:better_informed_mobile/presentation/widget/track/general_event_tracker/general_event_tracker.dart';
import 'package:better_informed_mobile/presentation/widget/track/view_visibility_notifier/view_visibility_notifier.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TopicMediaItemsList extends HookWidget {
  final ValueNotifier<int> pageIndex;
  final Topic topic;
  final GeneralEventTrackerController eventController;
  final GlobalKey? mediaItemKey;

  const TopicMediaItemsList({
    required this.pageIndex,
    required this.topic,
    required this.eventController,
    this.mediaItemKey,
  });

  @override
  Widget build(BuildContext context) {
    final entryList = topic.readingList.entries;

    useEffect(
      () {
        _trackReadingListBrowse(0);
      },
      [topic],
    );

    return Container(
      color: AppColors.darkLinen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const BottomStackedCards(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.l, vertical: AppDimens.xl),
            child: SizedBox(
              child: Text(
                LocaleKeys.todaysTopics_articlesCount.tr(args: [topic.readingList.entries.length.toString()]),
                style: AppTypography.h2Jakarta,
                maxLines: 1,
              ),
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
              final entry = topic.readingList.entries[index];
              if (entry.item is MediaItemArticle) {
                final article = entry.item as MediaItemArticle;
                return ViewVisibilityNotifier(
                    detectorKey: Key(article.slug),
                    onVisible: () {
                      _trackReadingListBrowse(index);
                    },
                    borderFraction: 0.6,
                    child: ArticleItemView(
                      article: article,
                      entryNote: entry.note,
                      entryStyle: entry.style,
                      onTap: () => _navigateToArticle(context, index),
                      mediaItemKey: index == 0 ? mediaItemKey : null,
                    ));
              }
              return const SizedBox();
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
      ),
    );
    return;
  }
}
