part of '../topic_page.dart';

class _TopicAppBar extends HookWidget {
  const _TopicAppBar({
    required this.isScrolled,
    required this.topic,
    required this.cubit,
    Key? key,
  }) : super(key: key);

  final ValueNotifier<bool> isScrolled;
  final Topic topic;
  final TopicPageCubit cubit;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = AppColors.of(context).backgroundPrimary;
    final title = topic.curationInfo.curator.maybeMap(
      expert: (_) => context.l10n.topic_labelExpert,
      orElse: () => context.l10n.topic_label,
    );
    final animationController = useAnimationController(duration: const Duration(milliseconds: 150));
    final backgroundColorAnimation = ColorTween(
      begin: AppColors.transparent,
      end: backgroundColor,
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
            leading: BackTextButton(color: isScrolled.value ? null : AppColors.stateTextSecondary),
            leadingWidth: AppDimens.xxc,
            title: Text(
              isScrolled.value ? topic.strippedTitle : title,
              style: AppTypography.h4Medium.w550.copyWith(
                height: 1.11,
                color: isScrolled.value ? null : AppColors.stateTextSecondary,
              ),
            ),
            actions: [
              BookmarkButton.topic(
                topic: topic.asPreview,
                briefId: cubit.briefId,
                color: isScrolled.value ? null : AppColors.stateTextSecondary,
              ),
              const SizedBox(width: AppDimens.s),
              ShareTopicButton(
                key: const Key('share-topic-button'),
                topic: topic.asPreview,
                color: isScrolled.value ? null : AppColors.stateTextSecondary,
              ),
              const SizedBox(width: AppDimens.m),
            ],
          ),
        ),
      ),
    );
  }
}
