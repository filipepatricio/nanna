part of '../topic_page.dart';

class _TopicAppBar extends StatelessWidget {
  const _TopicAppBar({
    required this.backgroundColorAnimation,
    required this.isScrolled,
    required this.topic,
    required this.cubit,
    required this.snackbarController,
    Key? key,
  }) : super(key: key);

  final Animation<Color?> backgroundColorAnimation;
  final ValueNotifier<bool> isScrolled;
  final Topic topic;
  final TopicPageCubit cubit;
  final SnackbarController snackbarController;

  @override
  Widget build(BuildContext context) {
    final title = topic.owner is Expert ? LocaleKeys.topic_labelExpert.tr() : LocaleKeys.topic_label.tr();

    return AnimatedBuilder(
      animation: backgroundColorAnimation,
      builder: (context, child) => AppBar(
        centerTitle: true,
        titleSpacing: AppDimens.zero,
        backgroundColor: backgroundColorAnimation.value,
        leading: IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.arrow_back_ios_rounded),
          iconSize: AppDimens.backArrowSize,
          color: isScrolled.value ? AppColors.textPrimary : AppColors.white,
          onPressed: () => AutoRouter.of(context).pop(),
        ),
        title: Text(
          isScrolled.value ? topic.strippedTitle : title,
          style: AppTypography.h4Bold.copyWith(
            height: 1,
            color: isScrolled.value ? AppColors.textPrimary : AppColors.white,
          ),
        ),
        actions: [
          BookmarkButton.topic(
            topic: topic.asPreview,
            briefId: cubit.briefId,
            color: isScrolled.value ? AppColors.textPrimary : AppColors.white,
            snackbarController: snackbarController,
          ),
          const SizedBox(width: AppDimens.s),
          IconButton(
            key: const Key('share-topic-button'),
            onPressed: () async {
              await shareTopicArticlesList(
                context,
                topic,
                await showShareOptions(context),
                snackbarController,
              );
            },
            iconSize: AppDimens.xxl,
            icon: SvgPicture.asset(
              AppVectorGraphics.share,
              color: isScrolled.value ? AppColors.textPrimary : AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
