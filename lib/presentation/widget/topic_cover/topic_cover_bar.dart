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
  }) =>
      _TopicCoverBar._(
        type: TopicCoverType.big,
        topic: topic,
        snackbarController: snackbarController,
      );

  const _TopicCoverBar._({
    required this.topic,
    required this.type,
    this.snackbarController,
    Key? key,
  }) : super(key: key);

  final TopicPreview topic;
  final TopicCoverType type;
  final SnackbarController? snackbarController;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case TopicCoverType.big:
        return _TopicCoverBarBig(
          topic: topic,
          snackbarController: snackbarController!,
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
    Key? key,
  }) : super(key: key);

  final TopicPreview topic;
  final SnackbarController snackbarController;

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<TopicCoverBarCubit>();

    useCubitListener<TopicCoverBarCubit, TopicCoverBarState>(cubit, (cubit, state, _) {
      state.whenOrNull(
        share: (topic, options) => shareTopicArticlesList(
          context,
          topic,
          options,
          snackbarController,
        ),
      );
    });

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PublisherLogoRow(topic: topic),
        const Spacer(),
        ShareButton(
          onTap: (options) => cubit.shareTopic(topic.slug, options),
          backgroundColor: AppColors.transparent,
        ),
        const SizedBox(width: AppDimens.m),
        BookmarkButton.topic(
          topic: topic,
          snackbarController: snackbarController,
        ),
      ],
    );
  }
}
