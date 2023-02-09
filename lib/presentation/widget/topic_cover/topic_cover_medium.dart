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
