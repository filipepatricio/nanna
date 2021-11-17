import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_app_bar.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_view.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

/// Make sure that changes to the view won't change depth of the main scroll
/// If they do, adjust depth accordingly
/// Depth is being changed by modifying scroll nest layers (adding or removing scrollable widget)
const _mainScrollDepth = 0;

class TopicPage extends HookWidget {
  final Topic topic;

  const TopicPage({
    required this.topic,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollPositionNotifier = useMemoized(() => ValueNotifier(0.0));
    final appBarKey = useMemoized(() => GlobalKey());
    final appBarHeightState = useState(AppDimens.topicAppBarDefaultHeight);
    final cubit = useCubit<TopicPageCubit>();

    useEffect(() {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        final renderBoxRed = appBarKey.currentContext?.findRenderObject() as RenderBox?;
        appBarHeightState.value = renderBoxRed?.size.height ?? AppDimens.topicAppBarDefaultHeight;
      });
    }, []);

    useEffect(
      () {
        cubit.initialize();
      },
      [cubit],
    );

    return LayoutBuilder(
      builder: (context, pageConstraints) => CupertinoScaffold(
        body: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.axis == Axis.vertical && scrollInfo.depth == _mainScrollDepth) {
              scrollPositionNotifier.value = scrollInfo.metrics.pixels;
            }
            return false;
          },
          child: Material(
            child: Stack(
              children: [
                TopicView(
                  topic: topic,
                  cubit: cubit,
                  articleContentHeight: pageConstraints.maxHeight - appBarHeightState.value,
                  appBarMargin: appBarHeightState.value,
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
          backgroundAnimationFactor: value / AppDimens.topicAppBarAnimationFactor,
          foregroundAnimationFactor: value / AppDimens.topicAppBarAnimationFactor,
          elevation: value / AppDimens.topicAppBarAnimationFactor > 0.95 ? 3.0 : 0.0,
        );
      },
    );
  }
}
