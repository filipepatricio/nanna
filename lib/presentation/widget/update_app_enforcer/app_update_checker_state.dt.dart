import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_update_checker_state.dt.freezed.dart';

@freezed
class AppUpdateCheckerState with _$AppUpdateCheckerState {
  @Implements<BuildState>()
  factory AppUpdateCheckerState.idle() = _AppUpdateCheckerStateIdle;

  const factory AppUpdateCheckerState.needsUpdate(String? availableVersion) = _AppUpdateCheckerStateNeedsUpdate;
}
