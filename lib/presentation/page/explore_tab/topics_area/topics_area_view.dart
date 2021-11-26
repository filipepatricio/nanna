import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_event.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content_area.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/hero_tag.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/page_dot_indicator.dart';
import 'package:better_informed_mobile/presentation/widget/page_view_stacked_card.dart';
import 'package:better_informed_mobile/presentation/widget/reading_list_cover.dart';
import 'package:better_informed_mobile/presentation/widget/see_all_button.dart';
import 'package:better_informed_mobile/presentation/widget/track/general_event_tracker/general_event_tracker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _pageViewHeight = 550.0;

class TopicsAreaView extends HookWidget {
  final ExploreContentAreaTopics area;

  const TopicsAreaView({
    required this.area,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final eventController = useEventTrackController();
    final controller = usePageController(viewportFraction: 0.9);
    final width = MediaQuery.of(context).size.width * 0.9;

    return GeneralEventTracker(
      controller: eventController,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppDimens.xc),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
            child: Row(
              children: [
                Expanded(
                  child: Hero(
                    tag: HeroTag.exploreTopicsTitle(area.title.hashCode),
                    child: InformedMarkdownBody(
                      markdown: area.title,
                      highlightColor: AppColors.transparent,
                      baseTextStyle: AppTypography.h1Medium,
                    ),
                  ),
                ),
                const SizedBox(width: AppDimens.s),
                SeeAllButton(
                  onTap: () => AutoRouter.of(context).push(
                    TopicsSeeAllPageRoute(
                      areaId: area.id,
                      title: area.title,
                      topics: area.topics,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimens.l),
          Container(
            height: _pageViewHeight,
            child: PageView.builder(
              padEnds: false,
              controller: controller,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(left: AppDimens.l),
                child: ReadingListStackedCards(
                  coverSize: Size(width, _pageViewHeight),
                  child: ReadingListCover(
                    topic: area.topics[index],
                    onTap: () => _onTopicTap(context, index),
                  ),
                ),
              ),
              onPageChanged: (page) {
                eventController.track(
                  AnalyticsEvent.exploreAreaCarouselBrowsed(
                    area.id,
                    page,
                  ),
                );
              },
              itemCount: area.topics.length,
            ),
          ),
          const SizedBox(height: AppDimens.l),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
            child: PageDotIndicator(
              pageCount: area.topics.length,
              controller: controller,
            ),
          ),
          const SizedBox(height: AppDimens.l),
        ],
      ),
    );
  }

  void _onTopicTap(BuildContext context, int index) {
    AutoRouter.of(context).push(
      TopicPageRoute(topic: area.topics[index]),
    );
  }
}
