import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/topic/mediaitems/topic_media_items_list.dart';
import 'package:better_informed_mobile/presentation/page/topic/summary/topic_summary_section.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/topic/topic_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_placeholder.dart';
import 'package:better_informed_mobile/presentation/widget/track/general_event_tracker/general_event_tracker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sliver_tools/sliver_tools.dart';

class TopicView extends HookWidget {
  const TopicView({
    required this.topic,
    required this.cubit,
    required this.scrollController,
    this.mediaItemKey,
    Key? key,
  }) : super(key: key);

  final Topic topic;
  final TopicPageCubit cubit;
  final GlobalKey? mediaItemKey;
  final ScrollController scrollController;

  static const bottomPaddingKey = Key('topic-view-bottom-padding');

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
        shouldShowMediaItemTutorialCoachMark: () {
          final topicArticleSectionTriggerPoint = topic.hasSummary
              ? AppDimens.topicArticleSectionTriggerPoint(context)
              : AppDimens.topicViewHeaderImageHeight(context);
          final listener = mediaItemTutorialListener(scrollController, topicArticleSectionTriggerPoint);
          scrollController.addListener(listener);
        },
      );
    });

    return MultiSliver(
      children: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              TopicSummarySection(
                topic: topic,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.l, vertical: AppDimens.xl),
                child: Text(
                  LocaleKeys.dailyBrief_articlesCount.tr(args: [topic.entries.length.toString()]),
                  style: AppTypography.h2Regular,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
        TopicMediaItemsList(
          topic: topic,
          cubit: cubit,
          eventController: eventController,
          mediaItemKey: pageIndex.value == 0 ? mediaItemKey : null,
        ),
        const SliverPadding(
          key: bottomPaddingKey,
          padding: EdgeInsets.only(bottom: AppDimens.xl),
        ),
        const SliverToBoxAdapter(
          child: AudioPlayerBannerPlaceholder(),
        ),
      ],
    );
  }

  bool didListScrollReachMediaItem(ScrollController listScrollController, double articleTriggerPosition) {
    return listScrollController.offset >= articleTriggerPosition && !listScrollController.position.outOfRange;
  }

  VoidCallback mediaItemTutorialListener(ScrollController listScrollController, double articleTriggerPosition) {
    var isToShowMediaItemTutorialCoachMark = true;
    void mediaItemTutorialListener() {
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
    }

    return mediaItemTutorialListener;
  }
}
