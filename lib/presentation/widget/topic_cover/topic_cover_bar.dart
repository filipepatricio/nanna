part of 'topic_cover.dart';

class _TopicCoverBar extends StatelessWidget {
  factory _TopicCoverBar.large({
    required TopicPreview topic,
  }) =>
      _TopicCoverBar._(
        type: TopicCoverType.large,
        topic: topic,
      );

  factory _TopicCoverBar.medium({
    required TopicPreview topic,
    VoidCallback? onBookmarkTap,
  }) =>
      _TopicCoverBar._(
        type: TopicCoverType.medium,
        topic: topic,
        onBookmarkTap: onBookmarkTap,
      );

  factory _TopicCoverBar.small({
    required TopicPreview topic,
  }) =>
      _TopicCoverBar._(
        type: TopicCoverType.small,
        topic: topic,
      );

  const _TopicCoverBar._({
    required this.topic,
    required this.type,
    this.onBookmarkTap,
    Key? key,
  }) : super(key: key);

  final TopicPreview topic;
  final TopicCoverType type;
  final VoidCallback? onBookmarkTap;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case TopicCoverType.large:
        return _TopicCoverBarLarge(
          topic: topic,
        );
      case TopicCoverType.medium:
        return _TopicCoverBarMedium(
          topic: topic,
          onBookmarkTap: onBookmarkTap,
        );
      case TopicCoverType.small:
        return _TopicCoverBarSmall(
          topic: topic,
        );
      default:
        return Container();
    }
  }
}

class _TopicCoverBarLarge extends StatelessWidget {
  const _TopicCoverBarLarge({
    required this.topic,
    Key? key,
  }) : super(key: key);

  final TopicPreview topic;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: CurationInfoView(
            curationInfo: topic.curationInfo,
            style: AppTypography.sansTextNanoLausanne.copyWith(color: AppColors.neutralGrey),
            imageDimension: AppDimens.smallAvatarSize,
          ),
        ),
        BookmarkButton.topic(
          topic: topic,
        ),
      ],
    );
  }
}

class _TopicCoverBarMedium extends StatelessWidget {
  const _TopicCoverBarMedium({
    required this.topic,
    this.onBookmarkTap,
    Key? key,
  }) : super(key: key);

  final TopicPreview topic;
  final VoidCallback? onBookmarkTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: CurationInfoView(
            curationInfo: topic.curationInfo,
            shortLabel: false,
            style: AppTypography.sansTextNanoLausanne.copyWith(color: AppColors.neutralGrey),
            imageDimension: AppDimens.smallAvatarSize,
          ),
        ),
        BookmarkButton.topic(
          topic: topic,
          onTap: onBookmarkTap,
        ),
      ],
    );
  }
}

class _TopicCoverBarSmall extends StatelessWidget {
  const _TopicCoverBarSmall({
    required this.topic,
    Key? key,
  }) : super(key: key);

  final TopicPreview topic;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: CurationInfoView(
            curationInfo: topic.curationInfo,
            shortLabel: true,
            style: AppTypography.sansTextNanoLausanne.copyWith(color: AppColors.neutralGrey),
            imageDimension: AppDimens.smallAvatarSize,
          ),
        ),
        BookmarkButton.topic(
          topic: topic,
        ),
      ],
    );
  }
}
