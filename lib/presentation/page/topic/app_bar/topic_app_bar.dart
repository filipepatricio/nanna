import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/topic/header/topic_header.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/app_theme.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/bookmark_button/bookmark_button.dart';
import 'package:better_informed_mobile/presentation/widget/share/share_options/share_options_view.dart';
import 'package:better_informed_mobile/presentation/widget/share/topic_articles_select_view.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TopicAppBar extends HookWidget {
  const TopicAppBar({
    required this.topic,
    required this.cubit,
    required this.isShowingTutorialToast,
    required this.scrollPositionNotifier,
    required this.snackbarController,
    Key? key,
  }) : super(key: key);
  final Topic topic;
  final TopicPageCubit cubit;
  final ValueNotifier<double> scrollPositionNotifier;
  final ValueNotifier<bool> isShowingTutorialToast;
  final SnackbarController snackbarController;

  @override
  Widget build(BuildContext context) {
    final isExpanded = useState(true);

    final title = Text(
      LocaleKeys.topic_label.tr(),
      textAlign: TextAlign.center,
      textScaleFactor: 1.0,
      style: AppTypography.h4Bold.copyWith(
        height: 1,
        color: isExpanded.value ? AppColors.white : AppColors.textPrimary,
      ),
    );

    final scrollThreshold = AppDimens.topicViewHeaderImageHeight(context) * .85;

    void updateAppBar() {
      if (isExpanded.value != scrollPositionNotifier.value < scrollThreshold) {
        isExpanded.value = scrollPositionNotifier.value < scrollThreshold;
      }
    }

    useEffect(
      () {
        scrollPositionNotifier.addListener(updateAppBar);
        return () => scrollPositionNotifier.removeListener(updateAppBar);
      },
      [scrollPositionNotifier],
    );

    return SliverAppBar(
      elevation: 1,
      pinned: true,
      titleSpacing: 0,
      centerTitle: true,
      shadowColor: AppColors.black40,
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.background,
      systemOverlayStyle: isExpanded.value && !isShowingTutorialToast.value
          ? AppTheme.systemUIOverlayStyleLight
          : AppTheme.systemUIOverlayStyleDark,
      // Because expandedHeight automatically includes the status bar height, I have to remove it from this value
      expandedHeight: AppDimens.topicViewHeaderImageHeight(context) - MediaQuery.of(context).viewPadding.top,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: TopicHeader(topic: topic),
      ),
      leading: IconButton(
        padding: EdgeInsets.zero,
        icon: const Icon(Icons.arrow_back_ios_rounded),
        iconSize: AppDimens.backArrowSize,
        color: isExpanded.value ? AppColors.white : AppColors.black,
        onPressed: () => AutoRouter.of(context).pop(),
      ),
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.s),
        child: title,
      ),
      actions: [
        BookmarkButton.topic(
          topic: topic.asPreview,
          briefId: cubit.briefId,
          color: isExpanded.value ? AppColors.white : AppColors.textPrimary,
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
            color: isExpanded.value ? AppColors.white : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
