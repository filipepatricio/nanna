import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_area_referred.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content_area.dt.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/presentation/page/explore/explore_area_item.dt.dart';
import 'package:better_informed_mobile/presentation/page/explore/widget/explore_area_header.dart';
import 'package:better_informed_mobile/presentation/page/explore/widget/explore_area_item_carousel_view.dart';
import 'package:better_informed_mobile/presentation/routing/main_router.gr.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/topic_cover.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _cellWidthFactor = 0.4;
const _aspectRatio = 1.52;

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
    final width = MediaQuery.of(context).size.width * _cellWidthFactor;
    final height = width * _aspectRatio;

    return Container(
      color: Color(area.backgroundColor),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppDimens.l),
          ExploreAreaHeader(
            title: area.title,
            description: area.description,
          ),
          const SizedBox(height: AppDimens.m),
          ExploreAreaItemCarouselView<TopicPreview>(
            areaId: area.id,
            itemBuilder: (topic, _) => GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => context.navigateToTopic(topic),
              child: TopicCover.small(topic: topic),
            ),
            items: _items,
            itemWidth: width,
            itemHeight: height,
            onViewAllTap: () => _navigateToSeeAll(context),
          ),
          const SizedBox(height: AppDimens.l),
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
