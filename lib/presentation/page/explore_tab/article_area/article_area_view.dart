import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_event.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content_area.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/explore_tab/article_with_cover_area/article_list_item.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/see_all_button.dart';
import 'package:better_informed_mobile/presentation/widget/track/general_event_tracker/general_event_tracker.dart';
import 'package:better_informed_mobile/presentation/widget/track/horizontal_list_interaction_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ArticleAreaView extends HookWidget {
  final ExploreContentAreaArticles area;

  const ArticleAreaView({
    required this.area,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final eventController = useEventTrackController();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppDimens.xc),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
          child: Row(
            children: [
              Expanded(
                child: InformedMarkdownBody(
                  markdown: area.title,
                  baseTextStyle: AppTypography.h1,
                  highlightColor: AppColors.transparent,
                  maxLines: 2,
                ),
              ),
              const SizedBox(width: AppDimens.s),
              SeeAllButton(
                onTap: () => AutoRouter.of(context).push(
                  ArticleSeeAllPageRoute(
                    areaId: area.id,
                    title: area.title,
                    entries: area.articles,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimens.l),
        GeneralEventTracker(
          controller: eventController,
          child: HorizontalListInteractionListener(
            itemsCount: area.articles.length,
            callback: (int lastVisibleItemIndex) {
              eventController.track(
                AnalyticsEvent.exploreAreaCarouselBrowsed(
                  area.id,
                  lastVisibleItemIndex,
                ),
              );
            },
            child: SizedBox(
              height: listItemHeight,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                itemBuilder: (context, index) => ArticleListItem(
                  article: area.articles[index],
                  themeColor: AppColors.background,
                  cardColor: AppColors.mockedColors[index % AppColors.mockedColors.length],
                ),
                separatorBuilder: (context, index) => const SizedBox(width: AppDimens.s),
                itemCount: area.articles.length,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppDimens.xxl),
      ],
    );
  }
}
