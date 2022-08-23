import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_area_referred.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content_area.dt.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/presentation/page/explore/explore_area_item.dt.dart';
import 'package:better_informed_mobile/presentation/page/explore/widget/explore_area_header.dart';
import 'package:better_informed_mobile/presentation/page/explore/widget/explore_area_item_carousel_view.dart';
import 'package:better_informed_mobile/presentation/routing/main_router.gr.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/topic_cover.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class HighlightedTopicsAreaView extends HookWidget {
  HighlightedTopicsAreaView({
    required this.area,
    Key? key,
  })  : _items = ExploreAreaItemGenerator.generate(
          area.topics,
          viewAllTitle: area.title,
        ),
        super(key: key);

  final ExploreContentAreaHighlightedTopics area;
  final List<ExploreAreaItem<TopicPreview>> _items;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * AppDimens.exploreTopicCarouselSmallCoverWidthFactor;
    final height = width * AppDimens.exploreTopicCarouselSmallCoverAspectRatio;
    final backgroundColor = area.backgroundColor == null ? AppColors.background : Color(area.backgroundColor!);

    return Container(
      color: backgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppDimens.ml),
          ExploreAreaHeader(
            title: area.title,
            description: area.description,
            isPreferred: area.isPreferred,
          ),
          const SizedBox(height: AppDimens.m),
          ExploreAreaItemCarouselView<TopicPreview>(
            areaId: area.id,
            itemBuilder: (topic, _) => TopicCover.exploreSmall(
              topic: topic,
              onTap: () => context.navigateToTopic(topic),
              hasBackgroundColor: true,
            ),
            items: _items,
            itemWidth: width,
            itemHeight: height,
            onViewAllTap: () => _navigateToSeeAll(context),
          ),
          const SizedBox(height: AppDimens.ml),
        ],
      ),
    );
  }

  void _navigateToSeeAll(BuildContext context) => context.pushRoute(
        TopicsSeeAllPageRoute(
          areaId: area.id,
          title: area.title,
          topics: area.topics,
          referred: ExploreAreaReferred.highlightedStream,
        ),
      );
}

extension on BuildContext {
  void navigateToTopic(TopicPreview topicPreview) {
    pushRoute(
      TopicPage(
        topicSlug: topicPreview.slug,
      ),
    );
  }
}
