part of 'topic_cover.dart';

class _TopicCoverBookmark extends HookWidget {
  const _TopicCoverBookmark({
    required this.onTap,
    required this.topic,
    this.hasBackgroundColor = false,
    Key? key,
  }) : super(key: key);

  final VoidCallback? onTap;
  final TopicPreview topic;
  final bool hasBackgroundColor;

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
            child: Stack(
              children: [
                Positioned.fill(
                  child: TopicCoverImage(
                    topic: topic,
                    borderRadius: AppDimens.s,
                  ),
                ),
                // Positioned(
                //   top: AppDimens.s,
                //   left: AppDimens.s,
                //   child: CoverLabel.topic(topic: topic),
                // ),
              ],
            ),
          ),
          const SizedBox(width: AppDimens.m),
          Expanded(
            child: SizedBox(
              height: coverSize,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  TopicCoverContent.bookmark(
                    topic: topic,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
