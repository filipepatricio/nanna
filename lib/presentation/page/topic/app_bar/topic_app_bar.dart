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
    final color = isScrolled.value ? AppColors.textPrimary : AppColors.white;
    return AnimatedBuilder(
      animation: backgroundColorAnimation,
      builder: (context, child) => AppBar(
        centerTitle: true,
        titleSpacing: AppDimens.s,
        backgroundColor: backgroundColorAnimation.value,
        leading: BackTextButton(text: LocaleKeys.common_back.tr(), color: color),
        leadingWidth: AppDimens.xxc,
        title: Text(
          isScrolled.value ? topic.strippedTitle : title,
          style: AppTypography.h4Medium.copyWith(
            fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.5),
            height: 1.11,
            color: color,
          ),
        ),
        actions: [
          BookmarkButton.topic(
            topic: topic.asPreview,
            briefId: cubit.briefId,
            color: color,
            snackbarController: snackbarController,
          ),
          IconButton(
            key: const Key('share-topic-button'),
            splashColor: AppColors.transparent,
            highlightColor: AppColors.transparent,
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
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
