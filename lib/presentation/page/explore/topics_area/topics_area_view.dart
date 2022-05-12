import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content_area.dt.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/explore/explore_area_item.dt.dart';
import 'package:better_informed_mobile/presentation/page/explore/widget/explore_area_header.dart';
import 'package:better_informed_mobile/presentation/page/explore/widget/explore_area_item_carousel_view.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/topic_cover.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TopicsAreaView extends HookWidget {
  TopicsAreaView({
    required this.area,
    required this.isHighlighted,
    Key? key,
  })  : _items = ExploreAreaItemGenerator.generate(area.topics),
        super(key: key);

  final ExploreContentAreaTopics area;
  final bool isHighlighted;
  final List<ExploreAreaItem<TopicPreview>> _items;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width * AppDimens.exploreTopicCellSizeFactor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppDimens.l),
        ExploreAreaHeader(title: area.title),
        const SizedBox(height: AppDimens.m),
        ExploreAreaItemCarouselView<TopicPreview>(
          areaId: area.id,
          items: _items,
          itemWidth: size,
          itemBuilder: (topic, index) => TopicCover.exploreLarge(
            topic: topic,
            onTap: () => context.navigateToTopic(topic),
          ),
        ),
        const SizedBox(height: AppDimens.l),
      ],
    );
  }
}

extension on BuildContext {
  void navigateToTopic(TopicPreview topic) {
    pushRoute(
      TopicPage(
        topicSlug: topic.slug,
      ),
    );
  }
}
