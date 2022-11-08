part of 'topic_cover.dart';

class _TopicCoverBar extends StatelessWidget {
  factory _TopicCoverBar.small({
    required TopicPreview topic,
  }) =>
      _TopicCoverBar._(
        type: TopicCoverType.small,
        topic: topic,
      );

  factory _TopicCoverBar.big({
    required TopicPreview topic,
    VoidCallback? onBookmarkTap,
  }) =>
      _TopicCoverBar._(
        type: TopicCoverType.big,
        topic: topic,
        onBookmarkTap: onBookmarkTap,
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
      case TopicCoverType.big:
        return _TopicCoverBarBig(
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
          ),
        ),
        BookmarkButton.topic(
          topic: topic,
        ),
      ],
    );
  }
}

class _TopicCoverBarBig extends HookWidget {
  const _TopicCoverBarBig({
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
        PublisherLogoRow(topic: topic),
        const Spacer(),
        ShareTopicButton(
          topic: topic,
        ),
        const SizedBox(width: AppDimens.m),
        BookmarkButton.topic(
          topic: topic,
          onTap: onBookmarkTap,
        ),
      ],
    );
  }
}
