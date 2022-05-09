import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/cover_label/cover_label.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/content/topic_cover_content.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/image/topic_cover_image.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/topic_cover_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/topic_cover_state.dt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

enum TopicCoverType { small, large, exploreLarge, exploreSmall }

class TopicCover extends HookWidget {
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

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case TopicCoverType.exploreSmall:
      case TopicCoverType.exploreLarge:
        return GestureDetector(
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppDimens.s),
            child: type == TopicCoverType.exploreLarge
                ? _TopicCoverExploreLarge(topic: topic)
                : _TopicCoverExploreSmall(topic: topic, hasBackgroundColor: hasBackgroundColor),
          ),
        );

      case TopicCoverType.small:
      case TopicCoverType.large:
        final cubit = useCubit<TopicCoverCubit>();
        final state = useCubitBuilder<TopicCoverCubit, TopicCoverState>(cubit);

        useEffect(
          () {
            cubit.initialize();
          },
          [cubit],
        );

        return GestureDetector(
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppDimens.m),
            child: Stack(
              children: state.map(
                idle: (data) => [
                  TopicCoverImage(
                    topic: topic,
                    showPhoto: data.showPhoto,
                  ),
                  TopicCoverContent(
                    topic: topic,
                    type: type,
                    mode: data.showPhoto ? Brightness.light : Brightness.dark,
                  ),
                ],
                loading: (_) => [
                  TopicCoverContent(
                    topic: topic,
                    type: type,
                  ),
                ],
              ),
            ),
          ),
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
          showPhoto: true,
          borderRadius: AppDimens.s,
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
    final _imageHeightFactor = (AppDimens.exploreTopicCarousellSmallCoverImageHeightFactor * 100).toInt();
    final _contentHeightFactor = 100 - _imageHeightFactor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: _imageHeightFactor,
          child: Stack(
            children: [
              Positioned.fill(
                child: TopicCoverImage(
                  topic: topic,
                  showPhoto: true,
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
        Expanded(
          flex: _contentHeightFactor,
          child: TopicCoverContent(
            topic: topic,
            type: TopicCoverType.exploreSmall,
            mode: Brightness.light,
            hasBackgroundColor: hasBackgroundColor,
          ),
        ),
      ],
    );
  }
}
