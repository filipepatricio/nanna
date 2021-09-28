import 'package:better_informed_mobile/domain/daily_brief/data/current_brief.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/relax/daily_brief_relax_view.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/topic/topic_app_bar.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/topic/topic_view.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/util/page_view_util.dart';
import 'package:better_informed_mobile/presentation/widget/hero_tag.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

const _animationDuration = Duration(milliseconds: 200);
const _pageViewportFraction = 1.0;

/// Make sure that changes to the view won't change depth of the main scroll
/// If they do, adjust depth accordingly
/// Depth is being changed by modifying scroll nest layers (adding or removing scrollable widget)
const _mainScrollDepth = 1;

class TopicPage extends HookWidget {
  final int index;
  final Function(int pageIndex) onPageChanged;
  final CurrentBrief currentBrief;

  TopicPage({
    required this.index,
    required this.onPageChanged,
    required this.currentBrief,
    Key? key,
  }) : super(key: key);

  final scrollPositionMapNotifier = ValueNotifier(<int, double>{});

  @override
  Widget build(BuildContext context) {
    final controller = usePageController(initialPage: index, viewportFraction: _pageViewportFraction);
    final pageTransitionAnimation = useAnimationController(duration: _animationDuration);
    final lastPageAnimationProgressState = useState(0.0);
    final pageIndexHook = useState(index);
    final route = useMemoized(() => ModalRoute.of(context));
    final appBarKey = useMemoized(() => GlobalKey());
    final appBarHeightState = useState(AppDimens.topicAppBarDefaultHeight);

    useEffect(() {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        final renderBoxRed = appBarKey.currentContext?.findRenderObject() as RenderBox?;
        appBarHeightState.value = renderBoxRed?.size.height ?? AppDimens.topicAppBarDefaultHeight;
      });
    }, []);

    useEffect(() {
      route?.animation?.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          pageTransitionAnimation.forward();
        } else if (status == AnimationStatus.reverse) {
          pageTransitionAnimation.reset();
        }
      });
    }, [route]);

    useEffect(() {
      final listener = () {
        lastPageAnimationProgressState.value = calculateLastPageShownFactor(controller, _pageViewportFraction);
      };
      controller.addListener(listener);
      return () => controller.removeListener(listener);
    }, [controller]);

    return LayoutBuilder(
      builder: (context, pageConstraints) => CupertinoScaffold(
        body: NotificationListener<ScrollNotification>(
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
                SafeArea(
                  child: Hero(
                    tag: HeroTag.dailyBriefRelaxPage,
                    child: RelaxView(
                      lastPageAnimationProgressState: lastPageAnimationProgressState,
                      goodbyeHeadline: currentBrief.goodbye,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: LayoutBuilder(
                    builder: (context, pageViewConstraints) => _PageViewContent(
                      controller: controller,
                      onPageChanged: onPageChanged,
                      pageTransitionAnimation: pageTransitionAnimation,
                      currentBrief: currentBrief,
                      articleContentHeight: pageViewConstraints.maxHeight - appBarHeightState.value,
                      pageIndexHook: pageIndexHook,
                      appBarMargin: appBarHeightState.value,
                    ),
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
    final animation = Tween(begin: 1.0, end: 0.0).animate(fadeInOutController);

    useEffect(() {
      if (lastPageAnimationProgressState.value > 0.5) {
        fadeInOutController.forward();
      } else {
        fadeInOutController.reverse();
      }
    });
    return AnimatedBuilder(
      animation: lastPageAnimationProgressState,
      builder: (context, widget) {
        final text = lastPageAnimationProgressState.value > 0.5
            ? LocaleKeys.dailyBrief_relax.tr()
            : LocaleKeys.dailyBrief_title.tr();

        final currentPageScrollValue = scrollPositionMap[currentPageIndex] ?? 0;

        final pageScrollAnimationFactor = currentPageScrollValue / AppDimens.topicAppBarAnimationFactor;
        final foregroundAnimationFactor = lastPageAnimationProgressState.value > 0.5
            ? lastPageAnimationProgressState.value
            : pageScrollAnimationFactor;

        final elevation =
            lastPageAnimationProgressState.value > 0.0 ? 0.0 : (pageScrollAnimationFactor >= 0.95 ? 3.0 : 0.0);

        return TopicAppBar(
          title: text,
          backgroundAnimationFactor: pageScrollAnimationFactor,
          foregroundAnimationFactor: foregroundAnimationFactor,
          elevation: elevation,
          progress: _countProgressValue(),
          fadeAnimation: animation,
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
  final AnimationController pageTransitionAnimation;
  final CurrentBrief currentBrief;
  final double articleContentHeight;
  final ValueNotifier pageIndexHook;
  final double? appBarMargin;

  const _PageViewContent({
    required this.controller,
    required this.onPageChanged,
    required this.pageTransitionAnimation,
    required this.currentBrief,
    required this.articleContentHeight,
    required this.pageIndexHook,
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
            pageTransitionAnimation: pageTransitionAnimation,
            topic: currentBrief.topics[index],
            articleContentHeight: articleContentHeight,
            appBarMargin: appBarMargin,
          );
        }
      },
    );
  }
}
