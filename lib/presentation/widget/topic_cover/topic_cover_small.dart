part of 'topic_cover.dart';

class _TopicCoverSmall extends TopicCover {
  const _TopicCoverSmall({
    required this.topic,
    required this.onTap,
    Key? key,
  }) : super._(key: key);

  final TopicPreview topic;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final height = useMemoized(
      () => AppDimens.smallCardHeight(context),
      [MediaQuery.of(context).size],
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        height: height,
        child: LayoutBuilder(
          builder: (context, constraints) => Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TopicSquareImageFrame(
                topic: topic,
                size: constraints.maxWidth,
              ),
              const SizedBox(height: AppDimens.sl),
              PublisherLogoRow(topic: topic),
              const SizedBox(height: AppDimens.sl),
              InformedMarkdownBody(
                markdown: topic.title,
                maxLines: 4,
                baseTextStyle: AppTypography.sansTitleSmallLausanne.copyWith(height: 1.25),
              ),
              const Spacer(),
              _TopicCoverBar.small(
                topic: topic,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
