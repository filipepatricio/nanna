import 'dart:io';
import 'dart:math' hide log;

import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/topic/data/curator.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/topic/header/topic_header.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_view.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/scroll_controller_utils.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_shadow.dart';
import 'package:better_informed_mobile/presentation/widget/back_text_button.dart';
import 'package:better_informed_mobile/presentation/widget/bookmark_button/bookmark_button.dart';
import 'package:better_informed_mobile/presentation/widget/general_error_view.dart';
import 'package:better_informed_mobile/presentation/widget/informed_cupertino_app_bar.dart';
import 'package:better_informed_mobile/presentation/widget/loading_shimmer.dart';
import 'package:better_informed_mobile/presentation/widget/physics/platform_scroll_physics.dart';
import 'package:better_informed_mobile/presentation/widget/share/share_options/share_options_view.dart';
import 'package:better_informed_mobile/presentation/widget/share/topic_articles_select_view.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:better_informed_mobile/presentation/widget/toasts/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scrolls_to_top/scrolls_to_top.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

part 'app_bar/topic_app_bar.dart';
part 'topic_loading_view.dart';

/// Make sure that changes to the view won't change depth of the main scroll
/// If they do, adjust depth accordingly
/// Depth is being changed by modifying scroll nest layers (adding or removing scrollable widget)
const _mainScrollDepth = 0;
const _hiddenAudioBannerPosition = AppDimens.xxxc * 4;

class TopicPage extends HookWidget {
  const TopicPage({
    @pathParam required this.topicSlug,
    this.topic,
    this.briefId,
    Key? key,
  }) : super(key: key);

  final String topicSlug;
  final Topic? topic;
  final String? briefId;

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
      extendBodyBehindAppBar: state.maybeMap(loading: (_) => true, orElse: () => false),
      appBar: state.maybeMap(
        idle: (_) => null,
        orElse: () => InformedCupertinoAppBar(
          brightness: Brightness.light,
          backLabel: LocaleKeys.common_back.tr(),
          backgroundColor: state.maybeMap(loading: (_) => AppColors.transparent, orElse: () => null),
        ),
      ),
      body: state.maybeMap(
        idle: (state) => _TopicIdleView(
          topic: state.topic,
          cubit: cubit,
          tutorialCoachMark: tutorialCoachMark,
        ),
        loading: (_) => const TopicLoadingView(),
        error: (_) => Padding(
          padding: const EdgeInsets.only(bottom: AppDimens.xxxc),
          child: Center(
            child: GeneralErrorView(
              title: LocaleKeys.common_error_title.tr(),
              content: LocaleKeys.common_error_body.tr(),
              retryCallback: () => cubit.initializeWithSlug(topicSlug, briefId),
            ),
          ),
        ),
        orElse: Container.new,
      ),
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

  bool _updateScrollPosition(ScrollNotification scrollInfo, ValueNotifier<double> scrollPositionNotifier) {
    if (scrollInfo.metrics.axis == Axis.vertical &&
        scrollInfo.depth == _mainScrollDepth &&
        scrollPositionNotifier.value != scrollInfo.metrics.pixels) {
      scrollPositionNotifier.value = scrollInfo.metrics.pixels;
    }
    return false;
  }

  void _expandCollapseAudioBanner(
    BuildContext context,
    ScrollController scrollController,
    ValueNotifier<double> audioBannerBottomPosition,
  ) {
    final position = scrollController.position.pixels;
    final fullHeight = AppDimens.topicViewHeaderImageHeight(context) -
        MediaQuery.of(context).viewPadding.bottom -
        MediaQuery.of(context).viewPadding.top;

    if (scrollController.position.userScrollDirection == ScrollDirection.forward
        ? (position < fullHeight)
        : (position > 0 && position < fullHeight)) {
      audioBannerBottomPosition.value = min(
        position - _hiddenAudioBannerPosition,
        0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final snackbarController = useMemoized(() => SnackbarController());
    final scrollPositionNotifier = useMemoized(() => ValueNotifier(0.0));
    final scrollController = useMemoized(() => ScrollController(keepScrollOffset: true));
    final isShowingTutorialToast = useState(false);
    final audioBannerBottomPosition = useValueNotifier<double>(-_hiddenAudioBannerPosition);
    final isScrolled = useState(false);
    final animationController = useAnimationController(duration: const Duration(milliseconds: 150));
    final backgroundColorAnimation = ColorTween(
      begin: AppColors.transparent,
      end: AppColors.background95,
    ).chain(CurveTween(curve: Curves.easeIn)).animate(animationController);

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
        showMediaItemTutorialCoachMark: () => tutorialCoachMark.show(context: context),
        skipTutorialCoachMark: (jumpToNextCoachMark) {
          tutorialCoachMark.skip();
        },
        finishTutorialCoachMark: tutorialCoachMark.finish,
      );
    });

    void updateAppBar() {
      final scrolled = scrollPositionNotifier.value > kToolbarHeight;
      if (isScrolled.value != scrolled) {
        isScrolled.value = scrolled;
        if (scrolled) {
          animationController.forward();
        } else {
          animationController.reverse();
        }
      }
    }

    useEffect(
      () {
        scrollPositionNotifier.addListener(updateAppBar);
        return () => scrollPositionNotifier.removeListener(updateAppBar);
      },
      [scrollPositionNotifier],
    );

    return ScrollsToTop(
      onScrollsToTop: (_) => scrollController.animateToStart(),
      child: SnackbarParentView(
        controller: snackbarController,
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            _expandCollapseAudioBanner(
              context,
              scrollController,
              audioBannerBottomPosition,
            );

            return _updateScrollPosition(
              scrollInfo,
              scrollPositionNotifier,
            );
          },
          child: Stack(
            children: [
              CustomScrollView(
                physics: getPlatformScrollPhysics(
                  const AlwaysScrollableScrollPhysics(),
                ),
                controller: scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: TopicHeader(topic: topic),
                  ),
                  TopicView(
                    topic: topic,
                    cubit: cubit,
                    scrollController: scrollController,
                    snackbarController: snackbarController,
                    mediaItemKey: cubit.mediaItemKey,
                  ),
                ],
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _TopicAppBar(
                  topic: topic,
                  cubit: cubit,
                  isScrolled: isScrolled,
                  snackbarController: snackbarController,
                  backgroundColorAnimation: backgroundColorAnimation,
                ),
              ),
              ValueListenableBuilder<double>(
                valueListenable: audioBannerBottomPosition,
                builder: (context, audioBannerBottomPosition, banner) => Positioned(
                  bottom: audioBannerBottomPosition,
                  left: 0,
                  right: 0,
                  child: banner!,
                ),
                child: const AudioPlayerBannerShadow(
                  child: AudioPlayerBanner(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
