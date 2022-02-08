import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_event.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/article/article_item_view.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/device_type.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/page_view_util.dart';
import 'package:better_informed_mobile/presentation/widget/bottom_stacked_cards.dart';
import 'package:better_informed_mobile/presentation/widget/link_label.dart';
import 'package:better_informed_mobile/presentation/widget/page_dot_indicator.dart';
import 'package:better_informed_mobile/presentation/widget/track/general_event_tracker/general_event_tracker.dart';
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
    final controller = usePageController();

    useEffect(
      () {
        _trackReadingListBrowse(0);
      },
      [topic],
    );

    return Container(
      height: AppDimens.topicViewArticleSectionFullHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: NoScrollGlow(
              child: PageView.builder(
                controller: controller,
                scrollDirection: Axis.horizontal,
                onPageChanged: (index) {
                  _trackReadingListBrowse(index);
                  pageIndex.value = index;
                },
                itemCount: entryList.length,
                itemBuilder: (context, index) {
                  return ArticleItemView(
                    index: index,
                    topic: topic,
                    topPadding: AppDimens.topicViewArticleSectionArticleCountLabelHeight +
                        AppDimens.topicViewStackedCardsDividerHeight,
                    onTap: () => _navigateToArticle(context, index, controller),
                    mediaItemKey: index == 0 ? mediaItemKey : null,
                  );
                },
              ),
            ),
          ),
          Positioned(
            left: AppDimens.l,
            top: AppDimens.l + AppDimens.topicViewStackedCardsDividerHeight,
            child: SizedBox(
              height: AppDimens.topicViewArticleSectionArticleCountLabelHeight,
              child: Text(
                LocaleKeys.todaysTopics_articlesCount.tr(args: [topic.readingList.entries.length.toString()]),
                style: AppTypography.h2Jakarta,
                maxLines: 1,
              ),
            ),
          ),
          Positioned(
            left: AppDimens.l,
            bottom: AppDimens.xl,
            child: PageDotIndicator(
              pageCount: entryList.length,
              controller: controller,
            ),
          ),
          if (kIsNotSmallDevice) ...[
            Positioned(
              left: AppDimens.l,
              bottom: AppDimens.xxxc,
              child: LinkLabel(
                labelText: LocaleKeys.article_readMore.tr(),
                fontSize: AppDimens.m,
                onTap: () => _navigateToArticle(context, controller.page?.floor() ?? 0, controller),
              ),
            ),
            const Positioned.fill(top: 0, child: BottomStackedCards()),
          ]
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

  void _navigateToArticle(BuildContext context, int index, PageController controller) {
    AutoRouter.of(context).push(
      MediaItemPageRoute(
        article: topic.articleAt(index),
        topicId: topic.id,
      ),
    );
    return;
  }
}
