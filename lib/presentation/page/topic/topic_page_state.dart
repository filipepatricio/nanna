import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'topic_page_state.freezed.dart';

@freezed
class TopicPageState with _$TopicPageState {
  @Implements<BuildState>()
  factory TopicPageState.idle(Topic topic) = _TopicPageStateStateIdle;

  @Implements<BuildState>()
  factory TopicPageState.loading() = _TopicPageStateLoading;

  factory TopicPageState.showTutorialToast(String text) = _TopicPageStateShowTutorialToast;

  factory TopicPageState.shouldShowSummaryCardTutorialCoachMark() =
      _TopicPageStateShouldShowSummaryCardTutorialCoachMark;

  factory TopicPageState.shouldShowMediaItemTutorialCoachMark() = _TopicPageStateShouldShowMediaItemTutorialCoachMark;

  factory TopicPageState.showSummaryCardTutorialCoachMark() = _TopicPageStateShowSummaryCardTutorialCoachMark;

  factory TopicPageState.showMediaItemTutorialCoachMark() = _TopicPageStateShowMediaItemTutorialCoachMark;

  factory TopicPageState.skipTutorialCoachMark() = _TopicPageStateSkipTutorialCoachMark;

  factory TopicPageState.finishTutorialCoachMark() = _TopicPageStateFinishTutorialCoachMark;
}
