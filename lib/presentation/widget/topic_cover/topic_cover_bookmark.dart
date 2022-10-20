part of 'topic_cover.dart';

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
              child: _TopicCoverContent.bookmark(
                topic: topic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
