import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/daily_brief_title_hero.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/topic/topic_view.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _animationDuration = Duration(milliseconds: 200);

class TopicPage extends HookWidget {
  final int index;
  final Function(int pageIndex) onPageChanged;

  const TopicPage({
    required this.index,
    required this.onPageChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = usePageController(initialPage: index);
    final pageTransitionAnimation = useAnimationController(duration: _animationDuration);

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

    return Scaffold(
      body: Stack(
        children: [
          _PageViewContent(
            controller: controller,
            onPageChanged: onPageChanged,
            pageTransitionAnimation: pageTransitionAnimation,
          ),
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _TransparentAppBar(),
          ),
        ],
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
      elevation: 0,
      title: Hero(
        tag: dailyBriefHeroTag,
        child: Text(
          LocaleKeys.dailyBrief_title.tr(),
          style: AppTypography.title.copyWith(color: Colors.white),
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

  const _PageViewContent({
    required this.controller,
    required this.onPageChanged,
    required this.pageTransitionAnimation,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: controller,
      allowImplicitScrolling: true,
      onPageChanged: onPageChanged,
      children: [
        TopicView(index: 0, pageTransitionAnimation: pageTransitionAnimation),
        TopicView(index: 1, pageTransitionAnimation: pageTransitionAnimation),
        TopicView(index: 2, pageTransitionAnimation: pageTransitionAnimation),
      ],
    );
  }
}
