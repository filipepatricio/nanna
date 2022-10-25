part of 'topic_cover.dart';

class _TopicCoverBig extends StatelessWidget {
  const _TopicCoverBig({
    required this.topic,
    required this.snackbarController,
    required this.onTap,
    this.onBookmarkTap,
    Key? key,
  }) : super(key: key);

  final TopicPreview topic;
  final SnackbarController snackbarController;
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
            TopicOwnerAvatar.small(owner: topic.owner),
            const SizedBox(height: AppDimens.s),
            Expanded(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Positioned.fill(
                    child: TopicCoverImage(
                      topic: topic,
                      borderRadius: AppDimens.smallImageCoverBorderRadius,
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
                          child: Text(
                            topic.strippedTitle,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: AppTypography.subH0Medium.copyWith(height: 1.25),
                            overflow: TextOverflow.ellipsis,
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
              snackbarController: snackbarController,
              onBookmarkTap: onBookmarkTap,
            ),
          ],
        ),
      ),
    );
  }
}
