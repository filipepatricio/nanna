import 'package:better_informed_mobile/domain/daily_brief/data/current_brief.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_brief_page_state.dt.freezed.dart';

@freezed
class DailyBriefPageState with _$DailyBriefPageState {
  @Implements<BuildState>()
  factory DailyBriefPageState.idle(CurrentBrief currentBrief) = _DailyBriefPageStateIdle;

  @Implements<BuildState>()
  factory DailyBriefPageState.loading() = _DailyBriefPageStateLoading;

  @Implements<BuildState>()
  factory DailyBriefPageState.error() = _DailyBriefPageStateError;

  factory DailyBriefPageState.showTutorialToast(String text) = _DailyBriefPageStateShowTutorialToast;
}
