part of 'topic_cover.dart';

class _TopicCoverSmall extends StatelessWidget {
  const _TopicCoverSmall({
    required this.topic,
    required this.onTap,
    required this.snackbarController,
    Key? key,
  }) : super(key: key);

  final TopicPreview topic;
  final VoidCallback? onTap;
  final SnackbarController snackbarController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox.square(
              dimension: constraints.maxWidth,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 4,
                    child: TopicCoverImage(
                      topic: topic,
                      borderRadius: AppDimens.smallImageCoverBorderRadius,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      color: topic.category.color,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(AppDimens.m),
                          child: Text(
                            topic.strippedTitle,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: AppTypography.subH0Medium.copyWith(height: 1.3),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimens.s),
            _TopicCoverContent.small(
              topic: topic,
              snackbarController: snackbarController,
            ),
          ],
        ),
      ),
    );
  }
}
