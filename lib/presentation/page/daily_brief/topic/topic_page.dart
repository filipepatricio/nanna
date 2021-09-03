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
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

const _animationDuration = Duration(milliseconds: 200);
const _pageViewportFraction = 1.0;

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
      builder: (context, constraints) => CupertinoScaffold(
        body: Material(
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
              _PageViewContent(
                controller: controller,
                onPageChanged: onPageChanged,
                pageTransitionAnimation: pageTransitionAnimation,
                currentBrief: currentBrief,
                topicPageHeight: constraints.maxHeight,
                pageIndexHook: pageIndexHook,
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _TransparentAppBar(
                  lastPageAnimationProgressState: lastPageAnimationProgressState,
                  pageCount: currentBrief.topics.length,
                  currentPageIndex: pageIndexHook.value,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TransparentAppBar extends StatelessWidget {
  final ValueNotifier<double> lastPageAnimationProgressState;
  final int pageCount;
  final int currentPageIndex;

  const _TransparentAppBar({
    required this.lastPageAnimationProgressState,
    required this.pageCount,
    required this.currentPageIndex,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: (context, widget) {
        final text = lastPageAnimationProgressState.value > 0.5
            ? LocaleKeys.dailyBrief_relax.tr()
            : LocaleKeys.dailyBrief_title.tr();

        final color = ColorTween(
          begin: AppColors.white,
          end: AppColors.textPrimary,
        ).transform(lastPageAnimationProgressState.value);

        return AppBar(
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          title: Row(
            children: [
              IconButton(
                onPressed: () => AutoRouter.of(context).pop(),
                icon: RotatedBox(
                  quarterTurns: 2,
                  child: SvgPicture.asset(
                    AppVectorGraphics.arrowRight,
                    color: AppColors.white,
                    height: AppDimens.backArrowSize,
                  ),
                ),
              ),
              Hero(
                tag: HeroTag.dailyBriefTitle,
                child: Text(
                  text,
                  style: AppTypography.h1Bold.copyWith(color: color),
                ),
              ),
              if (currentPageIndex < pageCount) ...[
                const SizedBox(width: AppDimens.m),
                Expanded(
                  child: Opacity(
                    opacity: 1 * (1 - lastPageAnimationProgressState.value),
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
            ],
          ),
          centerTitle: false,
        );
      },
      animation: lastPageAnimationProgressState,
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

  const _PageViewContent({
    required this.controller,
    required this.onPageChanged,
    required this.pageTransitionAnimation,
    required this.currentBrief,
    required this.topicPageHeight,
    required this.pageIndexHook,
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
          return Container();
        } else {
          return TopicView(
            index: index,
            pageTransitionAnimation: pageTransitionAnimation,
            topic: currentBrief.topics[index],
            topicPageHeight: topicPageHeight,
          );
        }
      },
    );
  }
}
