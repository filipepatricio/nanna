import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/current_brief.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/relax/daily_brief_relax_view.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/topic/topic_app_bar.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/topic/topic_page_cubit.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/topic/topic_page_state.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/topic/topic_view.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/util/page_view_util.dart';
import 'package:better_informed_mobile/presentation/widget/hero_tag.dart';
import 'package:better_informed_mobile/presentation/widget/snackbars/tutorial_snack_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

const _pageViewportFraction = 1.0;
const _pageCloseRelaxFactor = 0.95;

/// Make sure that changes to the view won't change depth of the main scroll
/// If they do, adjust depth accordingly
/// Depth is being changed by modifying scroll nest layers (adding or removing scrollable widget)
const _mainScrollDepth = 1;

class TopicPage extends HookWidget {
  final int index;
  final Function(int pageIndex) onPageChanged;
  final CurrentBrief currentBrief;
  late TutorialCoachMark tutorialCoachMark;

  TopicPage({
    required this.index,
    required this.onPageChanged,
    required this.currentBrief,
    Key? key,
  }) : super(key: key);

  final scrollPositionMapNotifier = ValueNotifier(<int, double>{});

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<TopicPageCubit>();
    final controller = usePageController(initialPage: index, viewportFraction: _pageViewportFraction);
    final lastPageAnimationProgressState = useMemoized(() => ValueNotifier(0.0));
    final pageIndexHook = useState(index);
    final appBarKey = useMemoized(() => GlobalKey());
    final appBarHeightState = useState(AppDimens.topicAppBarDefaultHeight);
    final targets = useMemoized(() => <TargetFocus>[]);
    final keySummaryCard = useMemoized(() => GlobalKey());

    useEffect(() {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        final renderBoxRed = appBarKey.currentContext?.findRenderObject() as RenderBox?;
        appBarHeightState.value = renderBoxRed?.size.height ?? AppDimens.topicAppBarDefaultHeight;
      });
    }, []);

    useEffect(() {
      final listener = () {
        final factor = calculateLastPageShownFactor(controller, _pageViewportFraction);

        if (lastPageAnimationProgressState.value >= _pageCloseRelaxFactor) {
          if (AutoRouter.of(context).current.name == TopicPageRoute.name) {
            AutoRouter.of(context).pop();
          }
          return;
        }

        lastPageAnimationProgressState.value = factor;
      };
      controller.addListener(listener);
      return () => controller.removeListener(listener);
    }, [controller]);

    useEffect(() {
      targets.clear();
      targets.add(
        TargetFocus(
          identify: "keySummaryCard",
          keyTarget: keySummaryCard,
          color: AppColors.shadowColor,
          enableOverlayTab: true,
          pulseVariation: Tween(begin: 1.0, end: 0.99),
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (context, controller) {
                return Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        "Titulo lorem ipsum",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Text(
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pulvinar tortor eget maximus iaculis.",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          controller.previous();
                        },
                        child: Icon(Icons.chevron_left),
                      ),
                    ],
                  ),
                );
              },
            )
          ],
          shape: ShapeLightFocus.RRect,
          radius: 5,
        ),
      );
      tutorialCoachMark = TutorialCoachMark(
        context,
        targets: targets,
        paddingFocus: 20,
        opacityShadow: 0.5,
        hideSkip: true,
        onFinish: () {
          print("finish");
        },
        onClickTarget: (target) {
          print('onClickTarget: $target');
        },
        onSkip: () {
          print("skip");
        },
        onClickOverlay: (target) {
          print('onClickOverlay: $target');
          tutorialCoachMark.finish();
        },
      );
    }, [targets, keySummaryCard]);

    useCubitListener<TopicPageCubit, TopicPageState>(cubit, (cubit, state, context) {
      state.whenOrNull(
          showTutorialToast: (title, message) => showToastWidget(
              TutorialSnackBar(title: title, message: message, onDismiss: cubit.showTutorialCoachMark),
              context: context,
              animation: StyledToastAnimation.slideFromTop,
              reverseAnimation: StyledToastAnimation.slideToTop,
              animDuration: const Duration(milliseconds: 500),
              position: StyledToastPosition.top,
              isIgnoring: false,
              dismissOtherToast: true,
              duration: Duration.zero),
          showTutorialCoachMark: () => tutorialCoachMark.show());
    });

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    return LayoutBuilder(
      builder: (context, pageConstraints) => NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.axis == Axis.vertical && scrollInfo.depth == _mainScrollDepth) {
            scrollPositionMapNotifier.value.update(
              pageIndexHook.value,
              (existingValue) => scrollInfo.metrics.pixels,
              ifAbsent: () => scrollInfo.metrics.pixels,
            );

            scrollPositionMapNotifier.value = Map.of(scrollPositionMapNotifier.value);
          }
          return false;
        },
        child: Material(
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: kToolbarHeight),
                  Expanded(
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.only(top: AppDimens.m, right: AppDimens.l + AppDimens.xs),
                        child: Hero(
                          tag: HeroTag.dailyBriefRelaxPage,
                          child: RelaxView(
                            lastPageAnimationProgressState: lastPageAnimationProgressState,
                            goodbyeHeadline: currentBrief.goodbye,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned.fill(
                child: LayoutBuilder(
                  builder: (context, pageViewConstraints) => _PageViewContent(
                      controller: controller,
                      onPageChanged: onPageChanged,
                      currentBrief: currentBrief,
                      articleContentHeight: pageViewConstraints.maxHeight - appBarHeightState.value,
                      pageIndexHook: pageIndexHook,
                      appBarMargin: appBarHeightState.value,
                      keySummaryCard: keySummaryCard),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: ValueListenableBuilder(
                  valueListenable: scrollPositionMapNotifier,
                  builder: (_, __, ___) {
                    return _TopicAppBar(
                      key: appBarKey,
                      lastPageAnimationProgressState: lastPageAnimationProgressState,
                      pageCount: currentBrief.topics.length,
                      currentPageIndex: pageIndexHook.value,
                      scrollPositionMap: scrollPositionMapNotifier.value,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopicAppBar extends HookWidget {
  final ValueNotifier<double> lastPageAnimationProgressState;
  final int pageCount;
  final int currentPageIndex;
  final Map<int, double> scrollPositionMap;

  const _TopicAppBar({
    required this.lastPageAnimationProgressState,
    required this.pageCount,
    required this.currentPageIndex,
    required this.scrollPositionMap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fadeInOutController = useAnimationController(duration: const Duration(milliseconds: 300));
    final animation = useMemoized(
      () => Tween(begin: 1.0, end: 0.0).animate(fadeInOutController),
      [fadeInOutController],
    );

    return ValueListenableBuilder<double>(
      valueListenable: lastPageAnimationProgressState,
      builder: (context, value, widget) {
        if (value > 0.5) {
          fadeInOutController.forward();
        } else {
          fadeInOutController.reverse();
        }

        final text = value > 0.5 ? LocaleKeys.dailyBrief_relax.tr() : LocaleKeys.dailyBrief_title.tr();

        final currentPageScrollValue = scrollPositionMap[currentPageIndex] ?? 0;

        final pageScrollAnimationFactor = currentPageScrollValue / AppDimens.topicAppBarAnimationFactor;
        final foregroundAnimationFactor = value > 0.5 ? value : pageScrollAnimationFactor;

        final elevation = value > 0.0 ? 0.0 : (pageScrollAnimationFactor >= 0.95 ? 3.0 : 0.0);

        return TopicAppBar(
          title: text,
          backgroundAnimationFactor: pageScrollAnimationFactor,
          foregroundAnimationFactor: foregroundAnimationFactor,
          elevation: elevation,
          progress: _countProgressValue(),
          fadeAnimation: animation,
          lastPageTransition: value,
        );
      },
    );
  }

  double _countProgressValue() {
    final progress = (currentPageIndex + 1) / pageCount;
    if (progress > 1.0) return 1;
    return progress;
  }
}

class _PageViewContent extends StatelessWidget {
  final PageController controller;
  final Function(int pageIndex) onPageChanged;
  final CurrentBrief currentBrief;
  final double articleContentHeight;
  final ValueNotifier pageIndexHook;
  final double? appBarMargin;
  final GlobalKey? keySummaryCard;

  const _PageViewContent({
    required this.controller,
    required this.onPageChanged,
    required this.currentBrief,
    required this.articleContentHeight,
    required this.pageIndexHook,
    this.keySummaryCard,
    this.appBarMargin,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller,
      allowImplicitScrolling: true,
      onPageChanged: (index) {
        pageIndexHook.value = index;
        onPageChanged(index);
      },
      itemCount: currentBrief.topics.length + 1,
      itemBuilder: (context, index) {
        if (index == currentBrief.topics.length) {
          return const SizedBox();
        } else {
          return TopicView(
              topic: currentBrief.topics[index],
              articleContentHeight: articleContentHeight,
              appBarMargin: appBarMargin,
              keySummaryCard: index == 0 ? keySummaryCard : null);
        }
      },
    );
  }
}
