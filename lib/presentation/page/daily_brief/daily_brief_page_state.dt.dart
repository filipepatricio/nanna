import 'package:better_informed_mobile/domain/daily_brief/data/current_brief.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/past_days_brief.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_brief_page_state.dt.freezed.dart';

@freezed
class DailyBriefPageState with _$DailyBriefPageState {
  @Implements<BuildState>()
  factory DailyBriefPageState.idle({
    required CurrentBrief currentBrief,
    required List<PastDaysBrief> pastDaysBriefs,
    required bool showCalendar,
    required bool showAppBarTitle,
  }) = _DailyBriefPageStateIdle;

  @Implements<BuildState>()
  factory DailyBriefPageState.loading() = _DailyBriefPageStateLoading;

  @Implements<BuildState>()
  factory DailyBriefPageState.error() = _DailyBriefPageStateError;

  factory DailyBriefPageState.showTutorialToast(String text) = _DailyBriefPageStateShowTutorialToast;

  factory DailyBriefPageState.shouldShowTopicCardTutorialCoachMark() =
      _DailyBriefPageStateShouldShowTopicCardTutorialCoachMark;

  factory DailyBriefPageState.showTopicCardTutorialCoachMark() = _DailyBriefPageStateShowTopicCardTutorialCoachMark;

  factory DailyBriefPageState.skipTutorialCoachMark({
    required bool jumpToNextCoachMark,
  }) = _DailyBriefPageStateSkipTutorialCoachMark;

  factory DailyBriefPageState.finishTutorialCoachMark() = _DailyBriefPageStateFinishTutorialCoachMark;
}
