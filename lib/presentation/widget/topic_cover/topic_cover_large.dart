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
    final coverWidth = useMemoized(
      () => AppDimens.topicCardBigMaxWidth(context),
      [MediaQuery.of(context).size],
    );
    final ownersNote = topic.ownersNote;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox.square(
        dimension: coverWidth,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.bottomCenter,
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
                      color: AppColors.white,
                    ),
                  ),
                  Positioned(
                    left: AppDimens.xl,
                    right: AppDimens.xl,
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
                                style: AppTypography.sansTitleLargeLausanne,
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
              Container(
                padding: const EdgeInsets.only(left: AppDimens.sl),
                decoration: const BoxDecoration(
                  border: Border(left: BorderSide(color: AppColors.limeGreen)),
                ),
                child: InformedMarkdownBody(
                  markdown: ownersNote,
                  baseTextStyle: AppTypography.sansTextSmallLausanne.copyWith(
                    color: AppColors.textGrey,
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
      ),
    );
  }
}
