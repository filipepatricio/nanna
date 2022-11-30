part of 'topic_cover.dart';

const _coverSizeToScreenWidthFactor = 0.35;

class _TopicCoverList extends HookWidget {
  const _TopicCoverList({
    required this.onTap,
    required this.topic,
    this.onBookmarkTap,
    Key? key,
  }) : super(key: key);

  final VoidCallback? onTap;
  final VoidCallback? onBookmarkTap;
  final TopicPreview topic;

  @override
  Widget build(BuildContext context) {
    final coverSize = useMemoized(
      () => AppDimens.coverSize(context, _coverSizeToScreenWidthFactor),
      [MediaQuery.of(context).size],
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.pageHorizontalMargin),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: coverSize,
                    child: _CoverContentBookmark(topic: topic),
                  ),
                ),
                const SizedBox(width: AppDimens.m),
                Stack(
                  children: [
                    SizedBox.square(
                      dimension: coverSize,
                      child: TopicCoverImage(
                        topic: topic,
                        borderRadius: BorderRadius.circular(AppDimens.defaultRadius),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: coverSize * 0.3,
                          width: coverSize * 0.7,
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
                              padding: const EdgeInsets.symmetric(horizontal: AppDimens.s),
                              child: Text(
                                LocaleKeys.topic_label.tr(),
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: AppTypography.h4Regular.copyWith(height: 1.25),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppDimens.sl),
            _TopicCoverBar.list(
              topic: topic,
              onBookmarkTap: onBookmarkTap,
            ),
          ],
        ),
      ),
    );
  }
}

class _CoverContentBookmark extends HookWidget {
  const _CoverContentBookmark({
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
            baseTextStyle: AppTypography.h2Medium.copyWith(height: 1.25),
          ),
          const SizedBox(height: AppDimens.sl),
          PublisherLogoRow(topic: topic),
        ],
      ),
    );
  }
}
