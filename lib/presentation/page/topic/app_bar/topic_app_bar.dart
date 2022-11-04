part of '../topic_page.dart';

class _TopicAppBar extends HookWidget {
  const _TopicAppBar({
    required this.isScrolled,
    required this.topic,
    required this.cubit,
    required this.snackbarController,
    Key? key,
  }) : super(key: key);

  final ValueNotifier<bool> isScrolled;
  final Topic topic;
  final TopicPageCubit cubit;
  final SnackbarController snackbarController;

  @override
  Widget build(BuildContext context) {
    final title = topic.curationInfo.curator.maybeMap(
      expert: (_) => LocaleKeys.topic_labelExpert.tr(),
      orElse: () => LocaleKeys.topic_label.tr(),
    );
    final animationController = useAnimationController(duration: const Duration(milliseconds: 150));
    final backgroundColorAnimation = ColorTween(
      begin: AppColors.transparent,
      end: AppColors.background95,
    ).chain(CurveTween(curve: Curves.easeIn)).animate(animationController);

    void updateAppBar() {
      if (isScrolled.value) {
        animationController.forward();
      } else {
        animationController.reverse();
      }
    }

    useEffect(
      () {
        isScrolled.addListener(updateAppBar);
        return () => isScrolled.removeListener(updateAppBar);
      },
      [isScrolled],
    );

    return AnimatedBuilder(
      animation: backgroundColorAnimation,
      builder: (context, _) => ClipRect(
        child: BackdropFilter(
          // Blur values extracted from [CupertinoNavigationBar]
          filter: isScrolled.value ? ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0) : ImageFilter.blur(),
          child: AppBar(
            centerTitle: true,
            titleSpacing: AppDimens.s,
            backgroundColor: backgroundColorAnimation.value,
            leading: BackTextButton(color: isScrolled.value ? AppColors.textPrimary : AppColors.white),
            leadingWidth: AppDimens.xxc,
            title: Text(
              isScrolled.value ? topic.strippedTitle : title,
              style: AppTypography.h4Medium.copyWith(
                fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.5),
                height: 1.11,
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
              ShareTopicButton(
                key: const Key('share-topic-button'),
                topic: topic.asPreview,
                snackbarController: snackbarController,
                iconColor: isScrolled.value ? AppColors.textPrimary : AppColors.white,
              ),
              const SizedBox(width: AppDimens.m),
            ],
          ),
        ),
      ),
    );
  }
}
