part of 'topic_cover.dart';

const _coverSizeToScreenWidthFactor = 0.26;

class _TopicCoverBookmark extends HookWidget {
  const _TopicCoverBookmark({
    required this.onTap,
    required this.topic,
    Key? key,
  }) : super(key: key);

  final VoidCallback? onTap;
  final TopicPreview topic;

  @override
  Widget build(BuildContext context) {
    final coverSize = useMemoized(
      () => AppDimens.coverSize(context, _coverSizeToScreenWidthFactor),
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
              borderRadius: AppDimens.s,
            ),
          ),
          const SizedBox(width: AppDimens.m),
          Expanded(
            child: SizedBox(
              height: coverSize,
              child: _CoverContentBookmark(topic: topic),
            ),
          ),
        ],
      ),
    );
  }
}

class _CoverContentBookmark extends HookWidget {
  const _CoverContentBookmark({
    required this.topic,
    Key? key,
  }) : super(key: key);

  final TopicPreview topic;

  @override
  Widget build(BuildContext context) {
    final coverSize = useMemoized(
      () => AppDimens.coverSize(context, _coverSizeToScreenWidthFactor),
      [MediaQuery.of(context).size],
    );

    return SizedBox(
      height: coverSize,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(height: AppDimens.s),
          CurationInfoView(
            curationInfo: topic.curationInfo,
            shortLabel: true,
          ),
          const SizedBox(height: AppDimens.s),
          InformedMarkdownBody(
            markdown: topic.title,
            maxLines: 3,
            baseTextStyle: AppTypography.h5BoldSmall.copyWith(height: 1.25),
          ),
        ],
      ),
    );
  }
}
