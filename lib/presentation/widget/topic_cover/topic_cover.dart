import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/widget/cloudinary/cloudinary_image.dart';
import 'package:better_informed_mobile/presentation/widget/cover_label/cover_label.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/content/topic_cover_content.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/image/topic_cover_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _coverSizeToScreenWidthFactor = 0.26;

enum TopicCoverType { small, large, exploreLarge, exploreSmall, otherBriefItemsList }

class TopicCover extends HookWidget {
  factory TopicCover.large({required TopicPreview topic, Function()? onTap}) => TopicCover._(
        type: TopicCoverType.large,
        topic: topic,
        onTap: onTap,
      );

  factory TopicCover.small({required TopicPreview topic, Function()? onTap}) => TopicCover._(
        type: TopicCoverType.small,
        topic: topic,
        onTap: onTap,
      );

  factory TopicCover.exploreLarge({required TopicPreview topic, Function()? onTap}) => TopicCover._(
        type: TopicCoverType.exploreLarge,
        topic: topic,
        onTap: onTap,
      );

  factory TopicCover.exploreSmall({required TopicPreview topic, bool hasBackgroundColor = false, Function()? onTap}) =>
      TopicCover._(
        type: TopicCoverType.exploreSmall,
        topic: topic,
        onTap: onTap,
        hasBackgroundColor: hasBackgroundColor,
      );

  factory TopicCover.otherBriefItemsList({required TopicPreview topic, Function()? onTap}) => TopicCover._(
        type: TopicCoverType.otherBriefItemsList,
        topic: topic,
        onTap: onTap,
      );

  const TopicCover._({
    required this.topic,
    required this.type,
    this.hasBackgroundColor = false,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final TopicPreview topic;
  final TopicCoverType type;
  final bool hasBackgroundColor;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case TopicCoverType.exploreSmall:
      case TopicCoverType.exploreLarge:
        return GestureDetector(
          onTap: onTap,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppDimens.s),
              topRight: Radius.circular(AppDimens.s),
            ),
            child: type == TopicCoverType.exploreLarge
                ? _TopicCoverExploreLarge(topic: topic)
                : _TopicCoverExploreSmall(topic: topic, hasBackgroundColor: hasBackgroundColor),
          ),
        );

      case TopicCoverType.small:
      case TopicCoverType.large:
        return GestureDetector(
          onTap: onTap,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(AppDimens.m),
            ),
            child: Stack(
              children: [
                Stack(
                  children: [
                    Positioned.fill(
                      child: TopicCoverImage(
                        topic: topic,
                        darkeningMode: type == TopicCoverType.small ? DarkeningMode.solid : DarkeningMode.gradient,
                      ),
                    ),
                    if (type == TopicCoverType.large)
                      Positioned(
                        top: AppDimens.m,
                        left: AppDimens.m,
                        child: CoverLabel.topic(topic: topic),
                      ),
                  ],
                ),
                TopicCoverContent(
                  topic: topic,
                  type: type,
                  mode: Brightness.light,
                ),
              ],
            ),
          ),
        );

      case TopicCoverType.otherBriefItemsList:
        return GestureDetector(
          onTap: onTap,
          child: _TopicCoverOtherBriefItemsList(onTap: onTap, topic: topic),
        );
    }
  }
}

class _TopicCoverExploreLarge extends StatelessWidget {
  const _TopicCoverExploreLarge({
    required this.topic,
    Key? key,
  }) : super(key: key);

  final TopicPreview topic;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TopicCoverImage(
          topic: topic,
          borderRadius: AppDimens.s,
          darkeningMode: DarkeningMode.solid,
        ),
        TopicCoverContent(
          topic: topic,
          type: TopicCoverType.exploreLarge,
          mode: Brightness.light,
        ),
      ],
    );
  }
}

class _TopicCoverExploreSmall extends StatelessWidget {
  const _TopicCoverExploreSmall({
    required this.topic,
    this.hasBackgroundColor = false,
    Key? key,
  }) : super(key: key);

  final TopicPreview topic;
  final bool hasBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox.square(
            dimension: constraints.maxWidth,
            child: Stack(
              children: [
                Positioned.fill(
                  child: TopicCoverImage(
                    topic: topic,
                    borderRadius: AppDimens.s,
                  ),
                ),
                Positioned(
                  top: AppDimens.s,
                  left: AppDimens.s,
                  child: CoverLabel.topic(topic: topic),
                ),
              ],
            ),
          ),
          TopicCoverContent(
            topic: topic,
            type: TopicCoverType.exploreSmall,
            mode: Brightness.light,
            hasBackgroundColor: hasBackgroundColor,
          ),
        ],
      ),
    );
  }
}

class _TopicCoverOtherBriefItemsList extends HookWidget {
  const _TopicCoverOtherBriefItemsList({
    required this.onTap,
    required this.topic,
    Key? key,
  }) : super(key: key);

  final VoidCallback? onTap;
  final TopicPreview topic;

  @override
  Widget build(BuildContext context) {
    final coverSize = useMemoized(
      () => MediaQuery.of(context).size.width * _coverSizeToScreenWidthFactor,
      [MediaQuery.of(context).size],
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        children: [
          SizedBox.square(
            dimension: coverSize,
            child: TopicCoverImage(
              topic: topic,
              borderRadius: AppDimens.xs,
            ),
          ),
          const SizedBox(width: AppDimens.m),
          TopicCoverContent(
            topic: topic,
            type: TopicCoverType.otherBriefItemsList,
            coverSize: coverSize,
          ),
        ],
      ),
    );
  }
}
