import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/explore/explore_area_item.dt.dart';
import 'package:better_informed_mobile/presentation/page/explore/widget/explore_area_item_carousel_view.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/topic_cover.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class OwnerTopics extends HookWidget {
  const OwnerTopics({
    required this.topics,
    Key? key,
  }) : super(key: key);
  final List<TopicPreview> topics;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * AppDimens.exploreTopicCarouselSmallCoverWidthFactor;
    final height = width * AppDimens.exploreTopicCarouselSmallCoverAspectRatio;

    final items = ExploreAreaItemGenerator.generate(
      topics,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppDimens.m),
        ExploreAreaItemCarouselView<TopicPreview>(
          itemBuilder: (topic, _) => TopicCover.small(
            topic: topic,
            onTap: () => context.navigateToTopic(topic),
          ),
          items: items,
          itemWidth: width,
          itemHeight: height,
        ),
      ],
    );
  }
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
