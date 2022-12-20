part of 'topic_cover.dart';

abstract class _TopicCoverBar extends StatelessWidget {
  const _TopicCoverBar._({super.key}) : super();

  factory _TopicCoverBar.large({
    required TopicPreview topic,
    Key? key,
  }) =>
      _TopicCoverBarLarge(
        topic: topic,
        key: key,
      );

  factory _TopicCoverBar.medium({
    required TopicPreview topic,
    VoidCallback? onBookmarkTap,
    Key? key,
  }) =>
      _TopicCoverBarMedium(
        topic: topic,
        onBookmarkTap: onBookmarkTap,
        key: key,
      );

  factory _TopicCoverBar.small({
    required TopicPreview topic,
    Key? key,
  }) =>
      _TopicCoverBarSmall(
        topic: topic,
        key: key,
      );
}

class _TopicCoverBarLarge extends _TopicCoverBar {
  const _TopicCoverBarLarge({
    required this.topic,
    Key? key,
  }) : super._(key: key);

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

class _TopicCoverBarMedium extends _TopicCoverBar {
  const _TopicCoverBarMedium({
    required this.topic,
    this.onBookmarkTap,
    Key? key,
  }) : super._(key: key);

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

class _TopicCoverBarSmall extends _TopicCoverBar {
  const _TopicCoverBarSmall({
    required this.topic,
    Key? key,
  }) : super._(key: key);

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
