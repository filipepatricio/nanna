part of 'topic_cover.dart';

const _coverSizeToScreenWidthFactor = 0.35;

class _TopicCoverMedium extends TopicCover {
  const _TopicCoverMedium({
    required this.onTap,
    required this.topic,
    this.onBookmarkTap,
    Key? key,
  }) : super._(key: key);

  final VoidCallback? onTap;
  final VoidCallback? onBookmarkTap;
  final TopicPreview topic;

  @override
  Widget build(BuildContext context) {
    final coverSize = useMemoized(
      () => AppDimens.coverSize(context, _coverSizeToScreenWidthFactor),
      [MediaQuery.of(context).size],
    );
    final ownersNote = topic.ownersNote;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimens.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: coverSize,
                    child: _CoverContentList(topic: topic),
                  ),
                ),
                const SizedBox(width: AppDimens.m),
                TopicSquareImageFrame(
                  topic: topic,
                  size: coverSize,
                ),
              ],
            ),
            const SizedBox(height: AppDimens.m),
            if (ownersNote != null) ...[
              Container(
                padding: const EdgeInsets.only(left: AppDimens.sl),
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(color: AppColors.brandAccent),
                  ),
                ),
                child: InformedMarkdownBody(
                  markdown: ownersNote,
                  baseTextStyle: AppTypography.sansTextSmallLausanne.copyWith(
                    color: AppColors.of(context).textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: AppDimens.l),
            ],
            _TopicCoverBar.medium(
              topic: topic,
              onBookmarkTap: onBookmarkTap,
            ),
          ],
        ),
      ),
    );
  }
}

class _CoverContentList extends HookWidget {
  const _CoverContentList({
    required this.topic,
    Key? key,
  }) : super(key: key);

  final TopicPreview topic;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          InformedMarkdownBody(
            markdown: topic.title,
            maxLines: 3,
            baseTextStyle: AppTypography.sansTitleMediumLausanne.copyWith(height: 1.25),
          ),
          const SizedBox(height: AppDimens.sl),
          PublisherLogoRow(topic: topic),
        ],
      ),
    );
  }
}
