import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/topic/topic_app_bar.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/topic/topic_view.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

const _animationDuration = Duration(milliseconds: 200);

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
    final appBarKey = useMemoized(() => GlobalKey());
    final appBarHeightState = useState(AppDimens.topicAppBarDefaultHeight);

    useEffect(() {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        final renderBoxRed = appBarKey.currentContext?.findRenderObject() as RenderBox?;
        appBarHeightState.value = renderBoxRed?.size.height ?? AppDimens.topicAppBarDefaultHeight;
      });
    }, []);

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
                      articleContentHeight: pageViewConstraints.maxHeight - appBarHeightState.value,
                      appBarMargin: appBarHeightState.value,
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: _AppBar(
                    key: appBarKey,
                    scrollPositionNotifier: scrollPositionNotifier,
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

class _AppBar extends StatelessWidget {
  final ValueNotifier<double> scrollPositionNotifier;

  const _AppBar({
    required this.scrollPositionNotifier,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: scrollPositionNotifier,
      builder: (_, value, ___) {
        return TopicAppBar(
          title: tr(LocaleKeys.readingList_title),
          animationFactor: value / AppDimens.topicAppBarAnimationFactor,
        );
      },
    );
  }
}
