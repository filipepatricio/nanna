import 'package:better_informed_mobile/domain/daily_brief/data/current_brief.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todays_topics_page_state.freezed.dart';

@freezed
class TodaysTopicsPageState with _$TodaysTopicsPageState {
  @Implements(BuildState)
  factory TodaysTopicsPageState.idle(CurrentBrief currentBrief) = _TodaysTopicsPageStateIdle;

  @Implements(BuildState)
  factory TodaysTopicsPageState.loading() = _TodaysTopicsPageStateLoading;

  @Implements(BuildState)
  factory TodaysTopicsPageState.error() = _TodaysTopicsPageStateError;
}
