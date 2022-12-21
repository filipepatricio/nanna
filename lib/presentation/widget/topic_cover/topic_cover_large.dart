part of 'topic_cover.dart';

class _TopicCoverLarge extends TopicCover {
  const _TopicCoverLarge({
    required this.topic,
    required this.onTap,
    Key? key,
  }) : super._(key: key);

  final TopicPreview topic;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ownersNote = topic.ownersNote;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 1 / 1,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: TopicImage(
                    topic: topic,
                    borderRadius: BorderRadius.circular(AppDimens.defaultRadius),
                  ),
                ),
                Positioned(
                  top: AppDimens.m,
                  child: InformedPill(
                    title: LocaleKeys.topic_label.tr(),
                    color: AppColors.of(context).buttonSecondaryFrame,
                  ),
                ),
                Positioned(
                  left: AppDimens.xl,
                  right: AppDimens.xl,
                  bottom: AppDimens.zero,
                  child: Container(
                    color: topic.category.color,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppDimens.m),
                        child: Column(
                          children: [
                            const SizedBox(height: AppDimens.m),
                            Text(
                              topic.strippedTitle,
                              maxLines: 3,
                              textAlign: TextAlign.center,
                              style: AppTypography.sansTitleLargeLausanne.copyWith(
                                color: AppColors.light.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: AppDimens.m),
                            PublisherLogoRow(topic: topic),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimens.m),
          if (ownersNote != null) ...[
            OwnersNoteContainer(
              child: InformedMarkdownBody(
                markdown: ownersNote,
                baseTextStyle: AppTypography.sansTextSmallLausanne.copyWith(
                  color: AppColors.of(context).textSecondary,
                ),
              ),
            ),
            const SizedBox(height: AppDimens.m),
          ],
          _TopicCoverBar.large(
            topic: topic,
          ),
        ],
      ),
    );
  }
}
