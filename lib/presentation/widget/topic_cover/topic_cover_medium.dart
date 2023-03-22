part of 'topic_cover.dart';

class _TopicCoverMedium extends TopicCover {
  const _TopicCoverMedium({
    required this.onTap,
    required this.topic,
    required this.isNew,
    this.onBookmarkTap,
    Key? key,
  }) : super._(key: key);

  final VoidCallback? onTap;
  final VoidCallback? onBookmarkTap;
  final TopicPreview topic;
  final bool isNew;

  @override
  Widget build(BuildContext context) {
    final coverSize = useMemoized(
      () => AppDimens.coverSize(context, AppDimens.coverSizeToScreenWidthFactor),
      [MediaQuery.of(context).size],
    );
    final ownersNote = topic.ownersNote;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.pageHorizontalMargin,
        vertical: AppDimens.l,
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropCapText(
              topic.strippedTitle,
              style: AppTypography.sansTitleMediumLausanne.copyWith(
                color: AppColors.of(context).textPrimary,
              ),
              dropCapPadding: const EdgeInsets.only(left: AppDimens.m),
              dropCapPosition: DropCapPosition.end,
              belowTextWidget: Padding(
                padding: const EdgeInsets.only(top: AppDimens.sl),
                child: PublisherLogoRow(topic: topic),
              ),
              mode: DropCapMode.baseline,
              dropCap: DropCap(
                width: coverSize,
                height: coverSize,
                child: TopicSquareImageFrame(
                  topic: topic,
                  size: coverSize,
                ),
              ),
            ),
            const SizedBox(height: AppDimens.m),
            if (ownersNote != null) ...[
              OwnersNote(note: ownersNote),
              const SizedBox(height: AppDimens.m),
            ],
            _TopicCoverBar.medium(
              topic: topic,
              onBookmarkTap: onBookmarkTap,
              isNew: isNew,
            ),
          ],
        ),
      ),
    );
  }
}
