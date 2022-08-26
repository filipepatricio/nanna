part of 'topic_cover.dart';

class _TopicCoverDailyBrief extends StatelessWidget {
  const _TopicCoverDailyBrief({
    required this.onTap,
    required this.topic,
    Key? key,
  }) : super(key: key);

  final Function()? onTap;
  final TopicPreview topic;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(AppDimens.m),
        ),
        child: CoverOpacity.topic(
          topic: topic,
          child: Stack(
            children: [
              Positioned.fill(
                child: TopicCoverImage(
                  topic: topic,
                  darkeningMode: DarkeningMode.gradient,
                ),
              ),
              CoverOpacity.topic(
                topic: topic,
                child: _TopicCoverContent.dailyBrief(
                  topic: topic,
                  mode: Brightness.light,
                ),
              ),
              if (topic.visited)
                const Positioned(
                  bottom: AppDimens.m,
                  right: AppDimens.m,
                  child: VisitedCheck(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
