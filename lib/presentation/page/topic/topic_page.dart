import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_app_bar.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page_cubit.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page_state.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_view.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/loader.dart';
import 'package:better_informed_mobile/presentation/widget/toasts/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

/// Make sure that changes to the view won't change depth of the main scroll
/// If they do, adjust depth accordingly
/// Depth is being changed by modifying scroll nest layers (adding or removing scrollable widget)
const _mainScrollDepth = 0;

class TopicPage extends HookWidget {
  final String topicSlug;
  final Topic? topic;
  final String? briefId;

  const TopicPage({
    @pathParam required this.topicSlug,
    this.topic,
    this.briefId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollPositionNotifier = useMemoized(() => ValueNotifier(0.0));
    final appBarKey = useMemoized(() => GlobalKey());
    final appBarHeightState = useState(AppDimens.topicAppBarDefaultHeight);
    final cubit = useCubit<TopicPageCubit>();
    final tutorialCoachMark = cubit.tutorialCoachMark(context);
    final state = useCubitBuilder(cubit);

    useEffect(() {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        final renderBoxRed = appBarKey.currentContext?.findRenderObject() as RenderBox?;
        appBarHeightState.value = renderBoxRed?.size.height ?? AppDimens.topicAppBarDefaultHeight;
      });
    }, []);

    useCubitListener<TopicPageCubit, TopicPageState>(cubit, (cubit, state, context) {
      state.whenOrNull(
        showTutorialToast: (text) => showToast(context, text),
        showSummaryCardTutorialCoachMark: tutorialCoachMark.show,
        showMediaItemTutorialCoachMark: tutorialCoachMark.show,
        skipTutorialCoachMark: tutorialCoachMark.skip,
        finishTutorialCoachMark: tutorialCoachMark.finish,
      );
    });

    useEffect(
      () {
        final nullableTopic = topic;

        if (nullableTopic == null) {
          cubit.initializeWithSlug(topicSlug, briefId);
        } else {
          cubit.initialize(nullableTopic, briefId);
        }
      },
      [topicSlug, cubit],
    );

    return WillPopScope(
        onWillPop: () => cubit.onAndroidBackButtonPress(tutorialCoachMark.isShowing),
        child: LayoutBuilder(
          builder: (context, pageConstraints) => CupertinoScaffold(
            body: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.axis == Axis.vertical && scrollInfo.depth == _mainScrollDepth) {
                  scrollPositionNotifier.value = scrollInfo.metrics.pixels;
                }
                return false;
              },
              child: Material(
                child: state.maybeMap(
                  idle: (state) => Stack(
                    children: [
                      TopicView(
                        topic: state.topic,
                        cubit: cubit,
                        appBarMargin: appBarHeightState.value,
                        summaryCardKey: cubit.summaryCardKey,
                        mediaItemKey: cubit.mediaItemKey,
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: _AppBar(
                          topic: state.topic,
                          key: appBarKey,
                          scrollPositionNotifier: scrollPositionNotifier,
                        ),
                      ),
                    ],
                  ),
                  loading: (_) => const Loader(),
                  orElse: () => const SizedBox(),
                ),
              ),
            ),
          ),
        ));
  }
}

class _AppBar extends StatelessWidget {
  final Topic topic;
  final ValueNotifier<double> scrollPositionNotifier;

  const _AppBar({
    required this.topic,
    required this.scrollPositionNotifier,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: scrollPositionNotifier,
      builder: (_, value, ___) {
        return TopicAppBar(
          topic: topic,
          backgroundAnimationFactor: value / AppDimens.topicAppBarAnimationFactor,
          foregroundAnimationFactor: value / AppDimens.topicAppBarAnimationFactor,
          elevation: value / AppDimens.topicAppBarAnimationFactor > 0.95 ? 3.0 : 0.0,
        );
      },
    );
  }
}
