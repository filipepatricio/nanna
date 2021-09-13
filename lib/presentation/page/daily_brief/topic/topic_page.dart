import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/current_brief.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/daily_brief_relax_view.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/topic/topic_view.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/page_view_util.dart';
import 'package:better_informed_mobile/presentation/widget/hero_tag.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

const _animationDuration = Duration(milliseconds: 200);
const _pageViewportFraction = 1.0;
const animationRangeFactor = 40.0;

class TopicPage extends HookWidget {
  final int index;
  final Function(int pageIndex) onPageChanged;
  final CurrentBrief currentBrief;

  const TopicPage({
    required this.index,
    required this.onPageChanged,
    required this.currentBrief,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = usePageController(initialPage: index, viewportFraction: _pageViewportFraction);
    final pageTransitionAnimation = useAnimationController(duration: _animationDuration);
    final lastPageAnimationProgressState = useState(0.0);
    final pageIndexHook = useState(index);
    final scrollPositionMap = useState(<int, double>{});

    final route = useMemoized(() => ModalRoute.of(context));
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
            if (scrollInfo.metrics.axis == Axis.vertical) {
              scrollPositionMap.value.update(
                pageIndexHook.value,
                (existingValue) => scrollInfo.metrics.pixels,
                ifAbsent: () => scrollInfo.metrics.pixels,
              );

              /// Recreate to force hook trigger rebuild
              scrollPositionMap.value = Map.of(scrollPositionMap.value);
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
                LayoutBuilder(
                  builder: (context, pageViewConstraints) => _PageViewContent(
                    controller: controller,
                    onPageChanged: onPageChanged,
                    pageTransitionAnimation: pageTransitionAnimation,
                    currentBrief: currentBrief,
                    topicPageHeight: pageViewConstraints.maxHeight,
                    pageIndexHook: pageIndexHook,
                    appBarMargin: (pageConstraints.maxHeight - pageViewConstraints.maxHeight).round(),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: _TopicAppBar(
                    lastPageAnimationProgressState: lastPageAnimationProgressState,
                    pageCount: currentBrief.topics.length,
                    currentPageIndex: pageIndexHook.value,
                    scrollPositionMap: scrollPositionMap,
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
  final ValueNotifier<Map<int, double>> scrollPositionMap;

  const _TopicAppBar({
    required this.lastPageAnimationProgressState,
    required this.pageCount,
    required this.currentPageIndex,
    required this.scrollPositionMap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final whiteToBlack = ColorTween(begin: AppColors.white, end: AppColors.textPrimary);
    final transparentToWhite = ColorTween(begin: AppColors.transparent, end: AppColors.background);
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

        final currentPageScrollValue = scrollPositionMap.value[currentPageIndex] ?? 0;

        final toBlackHorizontalTween = whiteToBlack.transform(lastPageAnimationProgressState.value);
        final toWhiteVerticalTween = transparentToWhite.transform(currentPageScrollValue / animationRangeFactor);
        final toBlackVerticalTween = whiteToBlack.transform(currentPageScrollValue / animationRangeFactor);

        final textIconColorTween =
            lastPageAnimationProgressState.value > 0.5 ? toBlackHorizontalTween : toBlackVerticalTween;

        return Material(
          color: toWhiteVerticalTween,
          child: AppBar(
            titleSpacing: 0,
            automaticallyImplyLeading: false,
            systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: AppColors.transparent),
            centerTitle: false,
            title: Row(
              children: [
                IconButton(
                  onPressed: () => AutoRouter.of(context).pop(),
                  icon: RotatedBox(
                    quarterTurns: 2,
                    child: SvgPicture.asset(
                      AppVectorGraphics.arrowRight,
                      height: AppDimens.backArrowSize,
                      color: textIconColorTween,
                    ),
                  ),
                ),
                Hero(
                  tag: HeroTag.dailyBriefTitle,
                  child: Text(
                    text,
                    style: AppTypography.h1Bold.copyWith(color: textIconColorTween),
                  ),
                ),
                const SizedBox(width: AppDimens.m),
                Expanded(
                  child: FadeTransition(
                    opacity: animation,
                    child: LinearPercentIndicator(
                      lineHeight: AppDimens.xs,
                      percent: _countProgressValue(),
                      linearStrokeCap: LinearStrokeCap.roundAll,
                      backgroundColor: AppColors.grey.withOpacity(0.44),
                      progressColor: AppColors.limeGreen,
                    ),
                  ),
                ),
                const SizedBox(width: AppDimens.l),
              ],
            ),
          ),
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
  final double topicPageHeight;
  final ValueNotifier pageIndexHook;
  final int? appBarMargin;

  const _PageViewContent({
    required this.controller,
    required this.onPageChanged,
    required this.pageTransitionAnimation,
    required this.currentBrief,
    required this.topicPageHeight,
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
            index: index,
            pageTransitionAnimation: pageTransitionAnimation,
            topic: currentBrief.topics[index],
            topicPageHeight: topicPageHeight,
            appBarMargin: appBarMargin,
          );
        }
      },
    );
  }
}
