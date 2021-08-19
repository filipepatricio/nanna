import 'package:better_informed_mobile/domain/daily_brief/data/current_brief.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/daily_brief_relax_view.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/topic/topic_view.dart';
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

    return CupertinoScaffold(
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
            ),
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _TransparentAppBar(),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransparentAppBar extends StatelessWidget {
  const _TransparentAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Hero(
        tag: HeroTag.dailyBriefTitle,
        child: Text(
          LocaleKeys.dailyBrief_title.tr(),
          style: AppTypography.h1Bold.copyWith(color: Colors.white),
        ),
      ),
      centerTitle: false,
    );
  }
}

class _PageViewContent extends StatelessWidget {
  final PageController controller;
  final Function(int pageIndex) onPageChanged;
  final AnimationController pageTransitionAnimation;
  final CurrentBrief currentBrief;

  const _PageViewContent({
    required this.controller,
    required this.onPageChanged,
    required this.pageTransitionAnimation,
    required this.currentBrief,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: controller,
      allowImplicitScrolling: true,
      onPageChanged: onPageChanged,
      children: [
        ..._buildTopicCards(),
        Container(),
      ],
    );
  }

  Iterable<Widget> _buildTopicCards() {
    return currentBrief.topics.asMap().map<int, Widget>((key, value) {
      return MapEntry(
        key,
        TopicView(
          index: key,
          pageTransitionAnimation: pageTransitionAnimation,
          topic: value,
        ),
      );
    }).values;
  }
}
