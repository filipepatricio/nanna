part of 'topic_cover.dart';

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
              borderRadius: AppDimens.xs,
            ),
          ),
          const SizedBox(width: AppDimens.m),
          _TopicCoverContent.otherBriefItemsList(
            topic: topic,
            coverSize: coverSize,
          ),
        ],
      ),
    );
  }
}
