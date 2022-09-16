part of 'topic_cover.dart';

class _TopicCoverExploreSmall extends StatelessWidget {
  const _TopicCoverExploreSmall({
    required this.topic,
    required this.onTap,
    this.hasBackgroundColor = false,
    Key? key,
  }) : super(key: key);

  final TopicPreview topic;
  final bool hasBackgroundColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return CoverOpacity.topic(
      topic: topic,
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppDimens.s),
            topRight: Radius.circular(AppDimens.s),
          ),
          child: LayoutBuilder(
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
                      if (topic.visited)
                        const Positioned(
                          bottom: AppDimens.s,
                          right: AppDimens.s,
                          child: VisitedCheck(),
                        ),
                    ],
                  ),
                ),
                _TopicCoverContent.exploreSmall(
                  topic: topic,
                  hasBackgroundColor: hasBackgroundColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
