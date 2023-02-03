import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'brief_entry_cover_state.dt.freezed.dart';

@Freezed(toJson: false)
class BriefEntryCoverState with _$BriefEntryCoverState {
  @Implements<BuildState>()
  factory BriefEntryCoverState.initializing() = _BriefEntryCoverStateInitializing;

  @Implements<BuildState>()
  factory BriefEntryCoverState.idle(
    BriefEntry entry,
  ) = _BriefEntryCoverStateIdle;
}
