import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/topic/app_bar/topic_app_bar.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_loading_view.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page_cubit.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page_state.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_view.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/page_view_util.dart';
import 'package:better_informed_mobile/presentation/widget/general_error_view.dart';
import 'package:better_informed_mobile/presentation/widget/toasts/toast_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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

  void _navigateToArticles(BuildContext context, ScrollController scrollController) {
    scrollController.animateTo(
      AppDimens.topicArticleSectionTriggerPoint(context),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scrollPositionNotifier = useMemoized(() => ValueNotifier(0.0));
    final cubit = useCubit<TopicPageCubit>();
    final tutorialCoachMark = cubit.tutorialCoachMark(context);
    final state = useCubitBuilder(cubit);
    final scrollController = useScrollController();

    useCubitListener<TopicPageCubit, TopicPageState>(cubit, (cubit, state, context) {
      state.whenOrNull(
        showTutorialToast: (text) => showToast(context, text),
        showSummaryCardTutorialCoachMark: tutorialCoachMark.show,
        showMediaItemTutorialCoachMark: tutorialCoachMark.show,
        skipTutorialCoachMark: () {
          tutorialCoachMark.skip();
          _navigateToArticles(context, scrollController);
        },
        finishTutorialCoachMark: tutorialCoachMark.finish,
      );
    });

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
        child: LayoutBuilder(
          builder: (context, pageConstraints) => CupertinoScaffold(
            body: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.axis == Axis.vertical && scrollInfo.depth == _mainScrollDepth) {
                  scrollPositionNotifier.value = scrollInfo.metrics.pixels;
                }
                return false;
              },
              child: Material(
                child: topic != null
                    ? _TopicIdleView(
                        topic: topic!,
                        scrollController: scrollController,
                        scrollPositionNotifier: scrollPositionNotifier,
                        cubit: cubit,
                        onArticlesLabelTap: () => _navigateToArticles(context, scrollController),
                      )
                    : state.maybeMap(
                        idle: (state) => _TopicIdleView(
                          topic: state.topic,
                          scrollController: scrollController,
                          scrollPositionNotifier: scrollPositionNotifier,
                          cubit: cubit,
                          onArticlesLabelTap: () => _navigateToArticles(context, scrollController),
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
            ),
          ),
        ));
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
    required this.scrollController,
    required this.scrollPositionNotifier,
    required this.cubit,
    required this.onArticlesLabelTap,
    Key? key,
  }) : super(key: key);

  final Topic topic;
  final ScrollController scrollController;
  final ValueNotifier<double> scrollPositionNotifier;
  final TopicPageCubit cubit;
  final VoidCallback onArticlesLabelTap;

  @override
  Widget build(BuildContext context) {
    return NoScrollGlow(
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          TopicAppBar(
            topic: topic,
            scrollPositionNotifier: scrollPositionNotifier,
            onArticlesLabelTap: onArticlesLabelTap,
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
    );
  }
}
