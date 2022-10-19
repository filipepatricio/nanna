part of 'topic_cover.dart';

class _TopicCoverContent extends StatelessWidget {
  factory _TopicCoverContent.dailyBrief({required TopicPreview topic, Brightness mode = Brightness.dark}) =>
      _TopicCoverContent._(
        type: TopicCoverType.dailyBrief,
        topic: topic,
        mode: mode,
      );

  factory _TopicCoverContent.bookmark({required TopicPreview topic}) => _TopicCoverContent._(
        type: TopicCoverType.bookmark,
        topic: topic,
      );

  factory _TopicCoverContent.small({
    required TopicPreview topic,
    required SnackbarController snackbarController,
  }) =>
      _TopicCoverContent._(
        type: TopicCoverType.small,
        topic: topic,
        snackbarController: snackbarController,
      );

  factory _TopicCoverContent.otherBriefItemsList({required TopicPreview topic, required double coverSize}) =>
      _TopicCoverContent._(
        type: TopicCoverType.otherBriefItemsList,
        topic: topic,
        coverSize: coverSize,
      );

  const _TopicCoverContent._({
    required this.topic,
    required this.type,
    this.mode = Brightness.dark,
    this.coverSize,
    this.snackbarController,
    Key? key,
  }) : super(key: key);

  final TopicPreview topic;
  final TopicCoverType type;
  final Brightness mode;
  final double? coverSize;
  final SnackbarController? snackbarController;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case TopicCoverType.dailyBrief:
        return _CoverContentDailyBrief(topic: topic, mode: mode);
      case TopicCoverType.bookmark:
        return _CoverContentBookmark(topic: topic);
      case TopicCoverType.small:
        return _CoverContentSmall(
          topic: topic,
          snackbarController: snackbarController!,
        );
      case TopicCoverType.otherBriefItemsList:
        return _CoverContentOtherBriefItemsList(topic: topic, coverSize: coverSize);
    }
  }
}

class _CoverContentDailyBrief extends StatelessWidget {
  const _CoverContentDailyBrief({
    required this.topic,
    required this.mode,
    Key? key,
  }) : super(key: key);

  final TopicPreview topic;
  final Brightness mode;

  bool get darkMode => mode == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimens.m),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CoverLabel.topic(topic: topic),
          const Spacer(),
          InformedMarkdownBody(
            markdown: topic.title,
            baseTextStyle: AppTypography.h1ExtraBold.copyWith(
              color: darkMode ? null : AppColors.white,
            ),
            maxLines: 4,
          ),
          const SizedBox(height: AppDimens.l),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BookmarkButton.topic(
                topic: topic,
                color: AppColors.white,
                iconSize: AppDimens.l,
              ),
              const SizedBox(width: AppDimens.ml),
              Flexible(
                child: TopicOwnerAvatar(
                  owner: topic.owner,
                  withPrefix: true,
                  underlined: true,
                  mode: mode,
                  imageSize: AppDimens.l,
                  textStyle: AppTypography.h5BoldSmall.copyWith(height: 1.5),
                  onTap: () => AutoRouter.of(context).push(
                    TopicOwnerPageRoute(owner: topic.owner, fromTopicSlug: topic.slug),
                  ),
                ),
              ),
              if (!topic.visited)
                Text(
                  LocaleKeys.readingList_articleCount.tr(
                    args: [topic.entryCount.toString()],
                  ),
                  style: AppTypography.metadata1Medium.copyWith(
                    height: 1.5,
                    color: darkMode ? null : AppColors.white,
                  ),
                ),
            ],
          ),
        ],
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
    final coverSize = useMemoized(
      () => AppDimens.coverSize(context, _coverSizeToScreenWidthFactor),
      [MediaQuery.of(context).size],
    );

    return SizedBox(
      height: coverSize,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(height: AppDimens.s),
          TopicOwnerAvatar(
            owner: topic.owner,
            withImage: false,
            imageSize: AppDimens.zero,
            textStyle: AppTypography.caption1Medium.copyWith(color: AppColors.textGrey),
            mode: Brightness.dark,
          ),
          const SizedBox(height: AppDimens.s),
          InformedMarkdownBody(
            markdown: topic.title,
            maxLines: 3,
            baseTextStyle: AppTypography.h5BoldSmall.copyWith(height: 1.25),
          ),
        ],
      ),
    );
  }
}

class _CoverContentSmall extends StatelessWidget {
  const _CoverContentSmall({
    required this.topic,
    required this.snackbarController,
    Key? key,
  }) : super(key: key);

  final TopicPreview topic;
  final SnackbarController snackbarController;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TopicOwnerAvatar(
            owner: topic.owner,
            withImage: true,
            imageSize: AppDimens.l,
            textStyle: AppTypography.b3Regular.copyWith(
              color: AppColors.textGrey,
              height: 1.1,
            ),
            mode: Brightness.dark,
          ),
        ),
        BookmarkButton.topic(
          topic: topic,
          snackbarController: snackbarController,
        ),
      ],
    );
  }
}

class _CoverContentOtherBriefItemsList extends StatelessWidget {
  const _CoverContentOtherBriefItemsList({
    required this.topic,
    this.coverSize,
    Key? key,
  }) : super(key: key);

  final TopicPreview topic;
  final double? coverSize;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: coverSize,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            CoverLabel.topic(
              topic: topic,
              color: AppColors.white,
              borderColor: AppColors.dividerGrey,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(AppDimens.xxs),
              child: AutoSizeText(
                topic.strippedTitle,
                maxLines: 2,
                style: AppTypography.h5BoldSmall.copyWith(height: 1.25),
                overflow: TextOverflow.ellipsis,
                maxFontSize: 14,
                minFontSize: 12,
              ),
            ),
            const Spacer(),
            Text(
              topic.owner.name,
              maxLines: 1,
              style: AppTypography.caption1Medium.copyWith(color: AppColors.textGrey),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
