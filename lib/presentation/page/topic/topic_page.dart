import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/topic/app_bar/topic_app_bar.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_loading_view.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_view.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/scroll_controller_utils.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_wrapper.dart';
import 'package:better_informed_mobile/presentation/widget/general_error_view.dart';
import 'package:better_informed_mobile/presentation/widget/physics/platform_scroll_physics.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:better_informed_mobile/presentation/widget/toasts/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:scrolls_to_top/scrolls_to_top.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

/// Make sure that changes to the view won't change depth of the main scroll
/// If they do, adjust depth accordingly
/// Depth is being changed by modifying scroll nest layers (adding or removing scrollable widget)
const _mainScrollDepth = 0;

class TopicPage extends HookWidget {
  final String topicSlug;
  final Topic? topic;
  final String? briefId;

  const TopicPage({
    @pathParam required this.topicSlug,
    this.topic,
    this.briefId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<TopicPageCubit>();
    final state = useCubitBuilder(cubit);
    final tutorialCoachMark = cubit.tutorialCoachMark(context);

    useEffect(
      () {
        final nullableTopic = topic;

        if (nullableTopic == null) {
          cubit.initializeWithSlug(topicSlug, briefId);
        } else {
          cubit.initialize(nullableTopic, briefId);
        }
      },
      [topicSlug, cubit],
    );

    final body = _TopicPage(
      state: state,
      cubit: cubit,
      tutorialCoachMark: tutorialCoachMark,
      topicSlug: topicSlug,
      briefId: briefId,
    );

    return Platform.isAndroid
        ? WillPopScope(
            onWillPop: () => cubit.onAndroidBackButtonPress(tutorialCoachMark.isShowing),
            child: body,
          )
        : body;
  }
}

class _TopicPage extends StatelessWidget {
  const _TopicPage({
    required this.state,
    required this.cubit,
    required this.tutorialCoachMark,
    required this.topicSlug,
    required this.briefId,
    Key? key,
  }) : super(key: key);

  final TopicPageState state;
  final TopicPageCubit cubit;
  final TutorialCoachMark tutorialCoachMark;
  final String topicSlug;
  final String? briefId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AudioPlayerBannerWrapper(
        layout: AudioPlayerBannerLayout.column,
        child: state.maybeMap(
          idle: (state) => _TopicIdleView(
            topic: state.topic,
            cubit: cubit,
            tutorialCoachMark: tutorialCoachMark,
          ),
          loading: (_) => const _DefaultAppBarWrapper(
            child: TopicLoadingView(),
          ),
          error: (_) => _DefaultAppBarWrapper(
            child: GeneralErrorView(
              title: LocaleKeys.dailyBrief_oops.tr(),
              content: LocaleKeys.dailyBrief_tryAgainLater.tr(),
              svgPath: AppVectorGraphics.magError,
              retryCallback: () => cubit.initializeWithSlug(topicSlug, briefId),
            ),
          ),
          orElse: () => const SizedBox.shrink(),
        ),
      ),
    );
  }
}

class _DefaultAppBarWrapper extends StatelessWidget {
  const _DefaultAppBarWrapper({
    required this.child,
    Key? key,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        child,
        Align(
          alignment: Alignment.topCenter,
          child: AppBar(
            foregroundColor: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _TopicIdleView extends HookWidget {
  const _TopicIdleView({
    required this.topic,
    required this.cubit,
    required this.tutorialCoachMark,
    Key? key,
  }) : super(key: key);

  final Topic topic;
  final TopicPageCubit cubit;
  final TutorialCoachMark tutorialCoachMark;

  void _scrollToSummary(BuildContext context, ScrollController controller) {
    controller.animateViewTo(
      AppDimens.topicViewHeaderImageHeight(context) - kToolbarHeight - MediaQuery.of(context).viewPadding.bottom,
    );
  }

  void _scrollToArticles(BuildContext context, ScrollController controller) {
    controller.animateViewTo(AppDimens.topicArticleSectionTriggerPoint(context));
  }

  bool _updateScrollPosition(ScrollNotification scrollInfo, ValueNotifier<double> scrollPositionNotifier) {
    if (scrollInfo.metrics.axis == Axis.vertical &&
        scrollInfo.depth == _mainScrollDepth &&
        scrollPositionNotifier.value != scrollInfo.metrics.pixels) {
      scrollPositionNotifier.value = scrollInfo.metrics.pixels;
    }
    return false;
  }

  void _snapPage(BuildContext context, ScrollController scrollController) {
    final maxHeight = AppDimens.topicViewHeaderImageHeight(context) - MediaQuery.of(context).viewPadding.bottom;
    final minHeight = kToolbarHeight + MediaQuery.of(context).viewInsets.top;

    final position = scrollController.position.pixels;
    final scrollDistance = maxHeight - minHeight;

    /// ScrollDirection.forward = scrolling from the bottom / ScrollDirection.reverse = scrolling from the top
    final thresholdFactor = scrollController.position.userScrollDirection == ScrollDirection.forward ? 0.9 : 0.1;

    if (position > 0 && position < scrollDistance) {
      final snapOffset = position / scrollDistance > thresholdFactor ? scrollDistance : 0.0;

      Future.microtask(
        () => scrollController.animateTo(
          snapOffset,
          duration: const Duration(milliseconds: 400),
          curve: Curves.linearToEaseOut,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final snackbarController = useMemoized(() => SnackbarController());
    final scrollPositionNotifier = useMemoized(() => ValueNotifier(0.0));
    final scrollController = useMemoized(() => ScrollController(keepScrollOffset: true));
    final isShowingTutorialToast = useState(false);

    useEffect(
      () {
        cubit.initializeTutorialStep();
      },
      [cubit],
    );

    useCubitListener<TopicPageCubit, TopicPageState>(cubit, (cubit, state, context) {
      state.whenOrNull(
        showTutorialToast: (text) {
          isShowingTutorialToast.value = true;
          showInfoToast(
            context: context,
            text: text,
            onDismiss: () {
              isShowingTutorialToast.value = false;
            },
          );
        },
        showSummaryCardTutorialCoachMark: tutorialCoachMark.show,
        showMediaItemTutorialCoachMark: tutorialCoachMark.show,
        skipTutorialCoachMark: (jumpToNextCoachMark) {
          tutorialCoachMark.skip();
          if (jumpToNextCoachMark) {
            _scrollToArticles(context, scrollController);
          }
        },
        finishTutorialCoachMark: tutorialCoachMark.finish,
      );
    });

    return ScrollsToTop(
      onScrollsToTop: (_) => scrollController.animateToStart(),
      child: SnackbarParentView(
        controller: snackbarController,
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) => _updateScrollPosition(scrollInfo, scrollPositionNotifier),
          child: Listener(
            onPointerUp: (_) => _snapPage(context, scrollController),
            child: NoScrollGlow(
              child: CustomScrollView(
                physics: getPlatformScrollPhysics(
                  const AlwaysScrollableScrollPhysics(),
                ),
                controller: scrollController,
                slivers: [
                  TopicAppBar(
                    topic: topic,
                    cubit: cubit,
                    isShowingTutorialToast: isShowingTutorialToast,
                    scrollPositionNotifier: scrollPositionNotifier,
                    onArticlesLabelTap: () => topic.hasSummary
                        ? _scrollToArticles(context, scrollController)
                        : _scrollToSummary(context, scrollController),
                    onArrowTap: () => _scrollToSummary(context, scrollController),
                    snackbarController: snackbarController,
                  ),
                  TopicView(
                    topic: topic,
                    cubit: cubit,
                    summaryCardKey: cubit.summaryCardKey,
                    mediaItemKey: cubit.mediaItemKey,
                    scrollController: scrollController,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension on ScrollController {
  Future<void> animateViewTo(double offset) => animateTo(
        offset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
}
