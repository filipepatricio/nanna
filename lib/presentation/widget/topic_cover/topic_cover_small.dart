part of 'topic_cover.dart';

class _TopicCoverSmall extends StatelessWidget {
  const _TopicCoverSmall({
    required this.topic,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final TopicPreview topic;
  final VoidCallback? onTap;

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
                    flex: 9,
                    child: TopicCoverImage(
                      topic: topic,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(
                          AppDimens.defaultRadius,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: topic.category.color,
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(
                            AppDimens.defaultRadius,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppDimens.m),
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
            _TopicCoverBar.small(
              topic: topic,
            ),
          ],
        ),
      ),
    );
  }
}
