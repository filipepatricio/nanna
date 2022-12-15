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
    return GestureDetector(
      onTap: onTap,
      child: LimitedBox(
        maxWidth: AppDimens.topicCardBigMaxWidth(context),
        maxHeight: AppDimens.topicCardBigMaxHeight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            const SizedBox(height: AppDimens.l),
            _TopicCoverBar.large(
              topic: topic,
            ),
          ],
        ),
      ),
    );
  }
}
