part of 'topic_cover.dart';

class _TopicCoverSmall extends StatelessWidget {
  const _TopicCoverSmall({
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
      child: LayoutBuilder(
        builder: (context, constraints) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TopicCoverImage(
              topic: topic,
              size: constraints.maxWidth,
            ),
            const SizedBox(height: AppDimens.sl),
            PublisherLogoRow(topic: topic),
            const SizedBox(height: AppDimens.sl),
            InformedMarkdownBody(
              markdown: topic.title,
              maxLines: 3,
              baseTextStyle: AppTypography.sansTitleSmallMediumLausanne.copyWith(height: 1.25),
            ),
            const Spacer(),
            _TopicCoverBar.small(
              topic: topic,
            ),
          ],
        ),
      ),
    );
  }
}
