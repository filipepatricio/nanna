import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/current_brief.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/daily_brief_relax_view.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/topic/topic_view.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/page_view_util.dart';
import 'package:better_informed_mobile/presentation/widget/hero_tag.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _TransparentAppBar(lastPageAnimationProgressState: lastPageAnimationProgressState),
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

  const _TransparentAppBar({
    required this.lastPageAnimationProgressState,
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: color,
            onPressed: () {
              AutoRouter.of(context).pop();
            },
          ),
          backgroundColor: Colors.transparent,
          title: Hero(
            tag: HeroTag.dailyBriefTitle,
            child: Text(
              text,
              style: AppTypography.h1Bold.copyWith(color: color),
            ),
          ),
          centerTitle: false,
        );
      },
      animation: lastPageAnimationProgressState,
    );
  }
}

class _PageViewContent extends StatelessWidget {
  final PageController controller;
  final Function(int pageIndex) onPageChanged;
  final AnimationController pageTransitionAnimation;
  final CurrentBrief currentBrief;
  final double topicPageHeight;

  const _PageViewContent({
    required this.controller,
    required this.onPageChanged,
    required this.pageTransitionAnimation,
    required this.currentBrief,
    required this.topicPageHeight,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller,
      allowImplicitScrolling: true,
      onPageChanged: onPageChanged,
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
