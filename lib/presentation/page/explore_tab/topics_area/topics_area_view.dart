import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_event.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content_area.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/page_view_util.dart';
import 'package:better_informed_mobile/presentation/widget/hero_tag.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/link_label.dart';
import 'package:better_informed_mobile/presentation/widget/page_dot_indicator.dart';
import 'package:better_informed_mobile/presentation/widget/reading_list_cover.dart';
import 'package:better_informed_mobile/presentation/widget/see_all_arrow.dart';
import 'package:better_informed_mobile/presentation/widget/stacked_cards/page_view_stacked_card.dart';
import 'package:better_informed_mobile/presentation/widget/stacked_cards/stacked_cards_random_variant_builder.dart';
import 'package:better_informed_mobile/presentation/widget/track/general_event_tracker/general_event_tracker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TopicsAreaView extends HookWidget {
  final ExploreContentAreaTopics area;

  const TopicsAreaView({
    required this.area,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final eventController = useEventTrackController();
    final controller = usePageController(viewportFraction: 0.81);
    final width = MediaQuery.of(context).size.width * 0.81;
    final cardStackHeight =
        MediaQuery.of(context).size.width * 0.5 > 450 ? MediaQuery.of(context).size.width * 0.5 : 450.0;

    return GeneralEventTracker(
      controller: eventController,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppDimens.xxxl),
          GestureDetector(
              onTap: () => _navigateToSeeAll(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                child: Row(
                  children: [
                    Expanded(
                      child: Hero(
                        tag: HeroTag.exploreTopicsTitle(area.title.hashCode),
                        child: InformedMarkdownBody(
                          markdown: area.title,
                          highlightColor: AppColors.transparent,
                          baseTextStyle: AppTypography.h2Jakarta,
                        ),
                      ),
                    ),
                    SeeAllArrow(
                      onTap: () => _navigateToSeeAll(context),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: AppDimens.l),
          Container(
            height: cardStackHeight,
            child: StackedCardsRandomVariantBuilder(
                count: area.topics.length,
                builder: (variants) {
                  return NoScrollGlow(
                    child: PageView.builder(
                      physics: const ClampingScrollPhysics(),
                      controller: controller,
                      padEnds: false,
                      onPageChanged: (page) => eventController.track(
                        AnalyticsEvent.exploreAreaCarouselBrowsed(
                          area.id,
                          page,
                        ),
                      ),
                      itemCount: area.topics.length + 1,
                      itemBuilder: (context, index) {
                        if (index == area.topics.length) {
                          return _SeeAllTopicsLabel(
                            onTap: () => _navigateToSeeAll(context),
                          );
                        }

                        return Padding(
                          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 16),
                          child: PageViewStackedCards.variant(
                            variant: variants[index],
                            centered: true,
                            coverSize: Size(width, cardStackHeight),
                            child: ReadingListCover(
                              topic: area.topics[index],
                              onTap: () => _onTopicTap(context, index),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
          ),
          const SizedBox(height: AppDimens.l),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
            child: PageDotIndicator(
              pageCount: area.topics.length,
              controller: controller,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToSeeAll(BuildContext context) => AutoRouter.of(context).push(
        TopicsSeeAllPageRoute(
          areaId: area.id,
          title: area.title,
          topics: area.topics,
        ),
      );

  void _onTopicTap(BuildContext context, int index) {
    AutoRouter.of(context).push(
      TopicPageRoute(
        topicSlug: area.topics[index].id,
        topic: area.topics[index],
      ),
    );
  }
}

class _SeeAllTopicsLabel extends StatelessWidget {
  const _SeeAllTopicsLabel({
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppDimens.xl),
      child: LinkLabel(
        labelText: LocaleKeys.explore_seeAllTopics.tr(),
        horizontalAlignment: MainAxisAlignment.end,
        onTap: onTap,
      ),
    );
  }
}
