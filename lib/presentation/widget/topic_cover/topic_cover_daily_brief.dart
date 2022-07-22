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
              Stack(
                children: [
                  Positioned.fill(
                    child: TopicCoverImage(
                      topic: topic,
                      darkeningMode: DarkeningMode.gradient,
                    ),
                  ),
                  Positioned(
                    top: AppDimens.m,
                    left: AppDimens.m,
                    child: CoverLabel.topic(topic: topic),
                  ),
                ],
              ),
              _TopicCoverContent.dailyBrief(
                topic: topic,
                mode: Brightness.light,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
