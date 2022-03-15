import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/presentation/page/topic/header/topic_header.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page_cubit.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/bookmark_button/bookmark_button.dart';
import 'package:better_informed_mobile/presentation/widget/marquee.dart';
import 'package:better_informed_mobile/presentation/widget/share/reading_list_articles_select_view.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

class TopicAppBar extends HookWidget {
  final Topic topic;
  final TopicPageCubit cubit;
  final ValueNotifier<double> scrollPositionNotifier;
  final VoidCallback onArticlesLabelTap;
  final VoidCallback onArrowTap;
  final ValueNotifier<bool> isShowingTutorialToast;
  final SnackbarController snackbarController;

  const TopicAppBar({
    required this.topic,
    required this.isShowingTutorialToast,
    required this.cubit,
    required this.isShowingTutorialToast,
    required this.scrollPositionNotifier,
    required this.onArticlesLabelTap,
    required this.onArrowTap,
    required this.snackbarController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isExpanded = useState(true);
    final hasScrolled = useState(false);
    final isMounted = useIsMounted();

    final title = Text(
      topic.strippedTitle,
      textAlign: TextAlign.center,
      textScaleFactor: 1.0,
      style: AppTypography.h4Bold.copyWith(
        height: 1,
        color: isExpanded.value ? AppColors.transparent : AppColors.black,
      ),
    );

    final scrollThreshold = AppDimens.topicViewHeaderImageHeight(context) * .85;

    void _updateAppBar() {
      if (isExpanded.value != scrollPositionNotifier.value < scrollThreshold) {
        isExpanded.value = scrollPositionNotifier.value < scrollThreshold;
      }
    }

    useEffect(
      () {
        scrollPositionNotifier.addListener(_updateAppBar);
        return () => scrollPositionNotifier.removeListener(_updateAppBar);
      },
      [scrollPositionNotifier],
    );

    return SliverAppBar(
      pinned: true,
      elevation: 3.0,
      shadowColor: AppColors.shadowDarkColor,
      backgroundColor: AppColors.background,
      titleSpacing: 0,
      automaticallyImplyLeading: false,
      centerTitle: true,
      systemOverlayStyle:
          isExpanded.value && !isShowingTutorialToast.value ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      // Because expandedHeight automatically includes the status bar height, I have to remove it from this value
      expandedHeight: AppDimens.topicViewHeaderImageHeight(context) - MediaQuery.of(context).viewPadding.top,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: TopicHeader(
          topic: topic,
          onArticlesLabelTap: onArticlesLabelTap,
          onArrowTap: onArrowTap,
        ),
      ),
      leading: IconButton(
        padding: EdgeInsets.zero,
        icon: const Icon(Icons.arrow_back_ios_rounded),
        iconSize: AppDimens.backArrowSize,
        color: isExpanded.value ? AppColors.white : AppColors.black,
        onPressed: () => AutoRouter.of(context).pop(),
      ),
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
        child: hasScrolled.value || isExpanded.value
            ? title
            : Marquee(
                animationDuration: const Duration(seconds: 3),
                onDone: () {
                  if (isMounted()) hasScrolled.value = true;
                },
                child: title,
              ),
      ),
      actions: [
        BookmarkButton.topic(
          topic: topic,
          briefId: cubit.briefId,
          mode: isExpanded.value ? BookmarkButtonMode.image : BookmarkButtonMode.color,
          snackbarController: snackbarController,
        ),
        IconButton(
          onPressed: () => shareReadingList(context, topic),
          padding: const EdgeInsets.only(right: AppDimens.s),
          icon: SvgPicture.asset(
            AppVectorGraphics.share,
            color: isExpanded.value ? AppColors.white : AppColors.black,
          ),
        ),
      ],
    );
  }
}
