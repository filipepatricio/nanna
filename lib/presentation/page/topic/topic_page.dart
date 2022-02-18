import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/topic/app_bar/topic_app_bar.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_loading_view.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page_cubit.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page_state.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_view.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/page_view_util.dart';
import 'package:better_informed_mobile/presentation/widget/cloudinary_progressive_image.dart';
import 'package:better_informed_mobile/presentation/widget/general_error_view.dart';
import 'package:better_informed_mobile/presentation/widget/toasts/toast_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
    final tutorialCoachMark = cubit.tutorialCoachMark(context);
    final state = useCubitBuilder(cubit);

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

  void _scrollToSummary(BuildContext context, ScrollController scrollController) {
    scrollController.animateTo(
      AppDimens.topicViewHeaderImageHeight(context) - kToolbarHeight,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
  }

  void _scrollToArticles(BuildContext context, ScrollController scrollController) {
    scrollController.animateTo(
      AppDimens.topicArticleSectionTriggerPoint(context),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cloudinaryProvider = useCloudinaryProvider();
    final backgroundImageWidth = MediaQuery.of(context).size.width;
    final backgroundImageHeight = AppDimens.topicViewHeaderImageHeight(context);
    final scrollPositionNotifier = useMemoized(() => ValueNotifier(0.0));

    final scrollController = useMemoized(
      () => ScrollController(keepScrollOffset: true),
    );

    useCubitListener<TopicPageCubit, TopicPageState>(cubit, (cubit, state, context) {
      state.whenOrNull(
        showTutorialToast: (text) => showToast(context, text),
        showSummaryCardTutorialCoachMark: tutorialCoachMark.show,
        showMediaItemTutorialCoachMark: tutorialCoachMark.show,
        skipTutorialCoachMark: () {
          tutorialCoachMark.skip();
          _scrollToArticles(context, scrollController);
        },
        finishTutorialCoachMark: tutorialCoachMark.finish,
      );
    });

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.axis == Axis.vertical &&
            scrollInfo.depth == _mainScrollDepth &&
            scrollPositionNotifier.value != scrollInfo.metrics.pixels) {
          scrollPositionNotifier.value = scrollInfo.metrics.pixels;
        }
        return false;
      },
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
              physics: const ClampingScrollPhysics(),
              controller: scrollController,
              slivers: [
                TopicAppBar(
                  topic: topic,
                  scrollPositionNotifier: scrollPositionNotifier,
                  onArticlesLabelTap: () => _scrollToArticles(context, scrollController),
                  onArrowTap: () => _scrollToSummary(context, scrollController),
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
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
