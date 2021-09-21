import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/topic/topic_app_bar.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/topic/topic_view.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

const _animationDuration = Duration(milliseconds: 200);
const _animationRangeFactor = 40.0;

const appBarHeightDefault = 92;

class SingleTopicPage extends HookWidget {
  final Topic topic;

  const SingleTopicPage({
    required this.topic,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageTransitionAnimation = useAnimationController(duration: _animationDuration);
    final scrollPositionNotifier = useMemoized(() => ValueNotifier(0.0));

    return LayoutBuilder(
      builder: (context, pageConstraints) => CupertinoScaffold(
        body: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.axis == Axis.vertical) {
              scrollPositionNotifier.value = scrollInfo.metrics.pixels;
            }
            return false;
          },
          child: Material(
            child: Stack(
              children: [
                LayoutBuilder(
                  builder: (context, pageViewConstraints) => Positioned.fill(
                    child: TopicView(
                      index: 0,
                      pageTransitionAnimation: pageTransitionAnimation,
                      topic: topic,
                      articleContentHeight: pageViewConstraints.maxHeight - appBarHeightDefault,
                      appBarMargin: appBarHeightDefault, // TODO calculate
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: _AppBar(scrollPositionNotifier: scrollPositionNotifier),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  final ValueNotifier<double> scrollPositionNotifier;

  const _AppBar({
    required this.scrollPositionNotifier,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final whiteToBlack = ColorTween(begin: AppColors.white, end: AppColors.textPrimary);
    final transparentToWhite = ColorTween(begin: AppColors.transparent, end: AppColors.background);

    return ValueListenableBuilder<double>(
      valueListenable: scrollPositionNotifier,
      builder: (_, value, ___) {
        final toWhiteVerticalTween = transparentToWhite.transform(value / _animationRangeFactor);
        final toBlackVerticalTween = whiteToBlack.transform(value / _animationRangeFactor);

        return TopicAppBar(
          title: tr(LocaleKeys.readingList_title),
          backgroundColor: toWhiteVerticalTween,
          textIconColor: toBlackVerticalTween,
        );
      },
    );
  }
}
