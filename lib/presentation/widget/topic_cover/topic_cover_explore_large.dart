part of 'topic_cover.dart';

class _TopicCoverExploreLarge extends StatelessWidget {
  const _TopicCoverExploreLarge({
    required this.topic,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final TopicPreview topic;
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
          child: Stack(
            children: [
              TopicCoverImage(
                topic: topic,
                borderRadius: AppDimens.s,
                darkeningMode: DarkeningMode.solid,
              ),
              _TopicCoverContent.exploreLarge(
                topic: topic,
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
      ),
    );
  }
}
