import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'topic_page_state.freezed.dart';

@freezed
class TopicPageState with _$TopicPageState {
  @Implements(BuildState)
  factory TopicPageState.idle() = _TopicPageStateStateIdle;

  @Implements(BuildState)
  factory TopicPageState.loading() = _TopicPageStateLoading;

  factory TopicPageState.showTutorialToast(String title, String message) = _TopicPageStateShowTutorialToast;

  factory TopicPageState.showSummaryCardTutorialCoachMark() = _TopicPageStateShowSummaryCardTutorialCoachMark;

  factory TopicPageState.showMediaItemTutorialCoachMark() = _TopicPageStateShowMediaItemTutorialCoachMark;
}
