part of 'topic_cover.dart';

class _TopicCoverBig extends StatelessWidget {
  const _TopicCoverBig({
    required this.topic,
    required this.onTap,
    this.onBookmarkTap,
    Key? key,
  }) : super(key: key);

  final TopicPreview topic;
  final VoidCallback? onTap;
  final VoidCallback? onBookmarkTap;

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
                    child: TopicCoverImage(
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
                              Text(
                                '${topic.curationInfo.byline} ${topic.curationInfo.curator.name}',
                                style: AppTypography.sansTextSmallRegularLausanne.copyWith(
                                  color: AppColors.textGrey.blendMultiply(topic.category.color ?? AppColors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimens.s),
            _TopicCoverBar.big(
              topic: topic,
              onBookmarkTap: onBookmarkTap,
            ),
          ],
        ),
      ),
    );
  }
}
