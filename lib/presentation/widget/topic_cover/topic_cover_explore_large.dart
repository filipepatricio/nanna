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
    return GestureDetector(
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
            TopicCoverContent.exploreLarge(
              topic: topic,
            ),
          ],
        ),
      ),
    );
  }
}
