part of 'topic_cover.dart';

class _TopicCoverBar extends StatelessWidget {
  factory _TopicCoverBar.small({
    required TopicPreview topic,
    required SnackbarController snackbarController,
  }) =>
      _TopicCoverBar._(
        type: TopicCoverType.small,
        topic: topic,
        snackbarController: snackbarController,
      );

  factory _TopicCoverBar.big({
    required TopicPreview topic,
    required SnackbarController snackbarController,
    VoidCallback? onBookmarkTap,
  }) =>
      _TopicCoverBar._(
        type: TopicCoverType.big,
        topic: topic,
        snackbarController: snackbarController,
        onBookmarkTap: onBookmarkTap,
      );

  const _TopicCoverBar._({
    required this.topic,
    required this.type,
    this.snackbarController,
    this.onBookmarkTap,
    Key? key,
  }) : super(key: key);

  final TopicPreview topic;
  final TopicCoverType type;
  final SnackbarController? snackbarController;
  final VoidCallback? onBookmarkTap;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case TopicCoverType.big:
        return _TopicCoverBarBig(
          topic: topic,
          snackbarController: snackbarController!,
          onBookmarkTap: onBookmarkTap,
        );
      case TopicCoverType.small:
        return _TopicCoverBarSmall(
          topic: topic,
          snackbarController: snackbarController!,
        );
      default:
        return Container();
    }
  }
}

class _TopicCoverBarSmall extends StatelessWidget {
  const _TopicCoverBarSmall({
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
          child: TopicOwnerAvatar.small(
            owner: topic.owner,
            shortLabel: true,
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

class _TopicCoverBarBig extends HookWidget {
  const _TopicCoverBarBig({
    required this.topic,
    required this.snackbarController,
    this.onBookmarkTap,
    Key? key,
  }) : super(key: key);

  final TopicPreview topic;
  final SnackbarController snackbarController;
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
          snackbarController: snackbarController,
        ),
        const SizedBox(width: AppDimens.m),
        BookmarkButton.topic(
          topic: topic,
          snackbarController: snackbarController,
          onTap: onBookmarkTap,
        ),
      ],
    );
  }
}
