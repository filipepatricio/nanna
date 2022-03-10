import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/topic/app_bar/topic_app_bar.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_loading_view.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page_cubit.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page_gesture_manager.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page_state.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_view.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/scroll_controller_utils.dart';
import 'package:better_informed_mobile/presentation/widget/cloudinary_progressive_image.dart';
import 'package:better_informed_mobile/presentation/widget/general_error_view.dart';
import 'package:better_informed_mobile/presentation/widget/physics/platform_scroll_physics.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:better_informed_mobile/presentation/widget/toasts/toast_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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

    return WillPopScope(
      onWillPop: () => cubit.onAndroidBackButtonPress(tutorialCoachMark.isShowing),
      child: Material(
        child: state.maybeMap(
          idle: (state) => _TopicIdleView(
            topic: state.topic,
            cubit: cubit,
            tutorialCoachMark: tutorialCoachMark,
          ),
          loading: (_) => const _DefaultAppBarWrapper(child: TopicLoadingView()),
          error: (_) => _DefaultAppBarWrapper(
            child: GeneralErrorView(
              title: LocaleKeys.todaysTopics_oops.tr(),
              content: LocaleKeys.todaysTopics_tryAgainLater.tr(),
              svgPath: AppVectorGraphics.magError,
              retryCallback: () => cubit.initializeWithSlug(topicSlug, briefId),
            ),
          ),
          orElse: () => const SizedBox(),
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

  void _scrollToSummary(BuildContext context, TopicPageGestureManager gestureManager) {
    gestureManager.animateViewTo(
      AppDimens.topicViewHeaderImageHeight(context) - kToolbarHeight - MediaQuery.of(context).viewPadding.bottom,
    );
  }

  void _scrollToArticles(BuildContext context, TopicPageGestureManager gestureManager) {
    gestureManager.animateViewTo(
      AppDimens.topicArticleSectionTriggerPoint(context) + kToolbarHeight + MediaQuery.of(context).viewPadding.bottom,
    );
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
    final cloudinaryProvider = useCloudinaryProvider();
    final snackbarController = useMemoized(() => SnackbarController());
    final backgroundImageWidth = MediaQuery.of(context).size.width;
    final backgroundImageHeight = AppDimens.topicViewHeaderImageHeight(context);
    final scrollPositionNotifier = useMemoized(() => ValueNotifier(0.0));
    final modalScrollController = useMemoized(() => ModalScrollController.of(context));
    final scrollController = useMemoized(() => ScrollController(keepScrollOffset: true));
    final gestureManager = useMemoized(
      () => TopicPageGestureManager(
        context: context,
        modalController: modalScrollController!,
        generalViewController: scrollController,
      ),
    );
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
        skipTutorialCoachMark: () {
          tutorialCoachMark.skip();
          _scrollToArticles(context, gestureManager);
        },
        finishTutorialCoachMark: tutorialCoachMark.finish,
      );
    });

    return SnackbarParentView(
      controller: snackbarController,
      child: RawGestureDetector(
        gestures: Map<Type, GestureRecognizerFactory>.fromEntries(
          [gestureManager.dragGestureRecognizer, gestureManager.tapGestureRecognizer],
        ),
        behavior: HitTestBehavior.opaque,
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) => _updateScrollPosition(scrollInfo, scrollPositionNotifier),
          child: Listener(
            onPointerUp: (_) => _snapPage(context, scrollController),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Opacity(
                    opacity: .6,
                    child: CloudinaryProgressiveImage(
                      width: backgroundImageWidth,
                      height: backgroundImageHeight,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      testImage: AppRasterGraphics.testReadingListCoverImage,
                      cloudinaryTransformation: cloudinaryProvider
                          .withPublicId(topic.coverImage.publicId)
                          .transform()
                          .withLogicalSize(backgroundImageWidth, backgroundImageWidth, context)
                          .fit(),
                    ),
                  ),
                ),
                NoScrollGlow(
                  child: CustomScrollView(
                    physics: NeverScrollableScrollPhysics(
                      parent: getPlatformScrollPhysics(
                        const AlwaysScrollableScrollPhysics(),
                      ),
                    ),
                    controller: scrollController,
                    slivers: [
                      TopicAppBar(
                        topic: topic,
                        isShowingTutorialToast: isShowingTutorialToast,
                        cubit: cubit,
                        scrollPositionNotifier: scrollPositionNotifier,
                        onArticlesLabelTap: () => _scrollToArticles(context, gestureManager),
                        onArrowTap: () => _scrollToSummary(context, gestureManager),
                        snackbarController: snackbarController,
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
