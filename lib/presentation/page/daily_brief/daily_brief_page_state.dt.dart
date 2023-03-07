import 'package:better_informed_mobile/domain/daily_brief/data/brief.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_past_day.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_past_days.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_brief_page_state.dt.freezed.dart';

@Freezed(toJson: false)
class DailyBriefPageState with _$DailyBriefPageState {
  @Implements<BuildState>()
  factory DailyBriefPageState.idle({
    required Brief selectedBrief,
    required BriefPastDays pastDays,
    required bool showCalendar,
    required bool showAppBarTitle,
  }) = _DailyBriefPageStateIdle;

  @Implements<BuildState>()
  factory DailyBriefPageState.loadingPastDay({
    required BriefPastDay selectedPastDay,
    required BriefPastDays pastDays,
    required bool showCalendar,
    required bool showAppBarTitle,
  }) = _DailyBriefPageStateLoadingPastDay;

  @Implements<BuildState>()
  factory DailyBriefPageState.loading() = _DailyBriefPageStateLoading;

  @Implements<BuildState>()
  factory DailyBriefPageState.error() = _DailyBriefPageStateError;

  @Implements<BuildState>()
  factory DailyBriefPageState.offline() = _DailyBriefPageStateOffline;

  factory DailyBriefPageState.showTutorialToast() = _DailyBriefPageStateShowTutorialToast;

  factory DailyBriefPageState.shouldShowTopicCardTutorialCoachMark() =
      _DailyBriefPageStateShouldShowTopicCardTutorialCoachMark;

  factory DailyBriefPageState.showTopicCardTutorialCoachMark() = _DailyBriefPageStateShowTopicCardTutorialCoachMark;

  factory DailyBriefPageState.skipTutorialCoachMark({
    required bool jumpToNextCoachMark,
  }) = _DailyBriefPageStateSkipTutorialCoachMark;

  factory DailyBriefPageState.finishTutorialCoachMark() = _DailyBriefPageStateFinishTutorialCoachMark;

  factory DailyBriefPageState.preCacheImages({required List<BriefEntry> briefEntryList}) =
      _DailyBriefPageStatePreCacheImages;

  factory DailyBriefPageState.showPaywall() = _DailyBriefPageStateShowPaywall;

  factory DailyBriefPageState.hasBeenUpdated() = _DailyBriefPageStateHasBeenUpdated;
}
