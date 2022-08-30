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

  factory _TopicCoverContent.exploreLarge({required TopicPreview topic}) => _TopicCoverContent._(
        type: TopicCoverType.exploreLarge,
        topic: topic,
      );

  factory _TopicCoverContent.exploreSmall({required TopicPreview topic, bool hasBackgroundColor = false}) =>
      _TopicCoverContent._(
        type: TopicCoverType.exploreSmall,
        topic: topic,
        hasBackgroundColor: hasBackgroundColor,
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
    this.hasBackgroundColor = false,
    this.coverSize,
    Key? key,
  }) : super(key: key);

  final TopicPreview topic;
  final TopicCoverType type;
  final Brightness mode;
  final bool hasBackgroundColor;
  final double? coverSize;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case TopicCoverType.dailyBrief:
        return _CoverContentDailyBrief(topic: topic, mode: mode);
      case TopicCoverType.bookmark:
        return _CoverContentBookmark(topic: topic);
      case TopicCoverType.exploreLarge:
        return _CoverContentExploreLarge(topic: topic);
      case TopicCoverType.exploreSmall:
        return _CoverContentExploreSmall(topic: topic, hasBackgroundColor: hasBackgroundColor);
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
              BookmarkButton.topic(topic: topic, mode: BookmarkButtonMode.image),
              const SizedBox(width: AppDimens.sl),
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

class _CoverContentExploreLarge extends StatelessWidget {
  const _CoverContentExploreLarge({
    required this.topic,
    Key? key,
  }) : super(key: key);

  final TopicPreview topic;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      top: AppDimens.m,
      bottom: AppDimens.l,
      left: AppDimens.m,
      right: AppDimens.l,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CoverLabel.topic(topic: topic),
          const SizedBox(height: AppDimens.m),
          InformedMarkdownBody(
            markdown: topic.title,
            maxLines: 4,
            baseTextStyle: AppTypography.h1ExtraBold.copyWith(
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: AppDimens.s),
          UpdatedLabel(
            mode: Brightness.light,
            dateTime: topic.lastUpdatedAt,
          ),
        ],
      ),
    );
  }
}

class _CoverContentExploreSmall extends StatelessWidget {
  const _CoverContentExploreSmall({
    required this.topic,
    this.hasBackgroundColor = false,
    Key? key,
  }) : super(key: key);

  final TopicPreview topic;
  final bool hasBackgroundColor;

  @override
  Widget build(BuildContext context) {
    const titleMaxLines = 2;
    const titleStyle = AppTypography.metadata1ExtraBold;
    final titleHeight = AppDimens.textHeight(style: titleStyle, maxLines: titleMaxLines);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppDimens.s),
        TopicOwnerAvatar(
          owner: topic.owner,
          withImage: false,
          imageSize: AppDimens.zero,
          textStyle: AppTypography.caption1Medium,
          mode: Brightness.dark,
        ),
        const SizedBox(height: AppDimens.s),
        SizedBox(
          height: titleHeight,
          child: InformedMarkdownBody(
            markdown: topic.title,
            maxLines: titleMaxLines,
            baseTextStyle: titleStyle,
          ),
        ),
        const SizedBox(height: AppDimens.s),
        Wrap(
          children: [
            UpdatedLabel(
              withPrefix: false,
              dateTime: topic.lastUpdatedAt,
              mode: Brightness.dark,
              textStyle: AppTypography.caption1Medium.copyWith(
                height: 1.2,
                color: hasBackgroundColor ? null : AppColors.textGrey,
              ),
            ),
          ],
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
