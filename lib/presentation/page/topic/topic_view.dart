import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/presentation/page/topic/mediaitems/topic_media_items_list.dart';
import 'package:better_informed_mobile/presentation/page/topic/summary/topic_summary_section.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/track/general_event_tracker/general_event_tracker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TopicView extends HookWidget {
  final Topic topic;
  final TopicPageCubit cubit;
  final GlobalKey? summaryCardKey;
  final GlobalKey? mediaItemKey;
  final ScrollController scrollController;

  const TopicView({
    required this.topic,
    required this.cubit,
    required this.scrollController,
    this.summaryCardKey,
    this.mediaItemKey,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final eventController = useEventTrackController();
    final pageIndex = useState(0);

    useEffect(
      () {
        cubit.initializeTutorialCoachMark();
      },
      [cubit],
    );

    useCubitListener<TopicPageCubit, TopicPageState>(cubit, (cubit, state, context) {
      state.whenOrNull(
        shouldShowSummaryCardTutorialCoachMark: () {
          final summaryCardTutorialTriggerPoint = AppDimens.topicViewHeaderImageHeight(context);
          final listener = summaryCardTutorialListener(scrollController, summaryCardTutorialTriggerPoint);
          scrollController.addListener(listener);
        },
        shouldShowMediaItemTutorialCoachMark: () {
          final topicArticleSectionTriggerPoint = AppDimens.topicArticleSectionTriggerPoint(context);
          final listener = mediaItemTutorialListener(scrollController, topicArticleSectionTriggerPoint);
          scrollController.addListener(listener);
        },
      );
    });

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TopicSummarySection(
          topic: topic,
          summaryCardKey: summaryCardKey,
        ),
        GeneralEventTracker(
          controller: eventController,
          child: TopicMediaItemsList(
            pageIndex: pageIndex,
            topic: topic,
            cubit: cubit,
            eventController: eventController,
            mediaItemKey: pageIndex.value == 0 ? mediaItemKey : null,
          ),
        ),
      ],
    );
  }

  bool didListScrollReachMediaItem(ScrollController listScrollController, double articleTriggerPosition) {
    return listScrollController.offset >= articleTriggerPosition && !listScrollController.position.outOfRange;
  }

  bool didListScrollReachSummaryCard(ScrollController listScrollController, double summaryCardTriggerPosition) {
    return listScrollController.offset >= summaryCardTriggerPosition && !listScrollController.position.outOfRange;
  }

  VoidCallback summaryCardTutorialListener(ScrollController listScrollController, double topicHeaderImageHeight) {
    var isToShowSummaryCardTutorialCoachMark = true;
    final summaryCardTutorialListener = () {
      final summaryCardTriggerPosition = topicHeaderImageHeight - AppDimens.topicViewTopicHeaderPadding;
      if (didListScrollReachSummaryCard(listScrollController, summaryCardTriggerPosition) &&
          isToShowSummaryCardTutorialCoachMark) {
        listScrollController.animateTo(
          summaryCardTriggerPosition,
          duration: const Duration(milliseconds: 100),
          curve: Curves.decelerate,
        );
        cubit.showSummaryCardTutorialCoachMark();
        isToShowSummaryCardTutorialCoachMark = false;
      }
    };
    return summaryCardTutorialListener;
  }

  VoidCallback mediaItemTutorialListener(ScrollController listScrollController, double articleTriggerPosition) {
    var isToShowMediaItemTutorialCoachMark = true;
    final mediaItemTutorialListener = () {
      if (isToShowMediaItemTutorialCoachMark &&
          didListScrollReachMediaItem(listScrollController, articleTriggerPosition)) {
        listScrollController.animateTo(
          articleTriggerPosition,
          duration: const Duration(milliseconds: 100),
          curve: Curves.decelerate,
        );
        cubit.showMediaItemTutorialCoachMark();
        isToShowMediaItemTutorialCoachMark = false;
      }
    };
    return mediaItemTutorialListener;
  }
}
