import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_main_state.dt.freezed.dart';

@freezed
class SettingsMainState with _$SettingsMainState {
  @Implements<BuildState>()
  const factory SettingsMainState.init() = _SettingsMainStateInit;

  @Implements<BuildState>()
  const factory SettingsMainState.idle({required bool subscriptionsEnabled}) = _SettingsMainStateIdle;

  @Implements<BuildState>()
  const factory SettingsMainState.loading() = _SettingsMainStateLoading;

  factory SettingsMainState.sendingEmailError() = _SettingsMainStateSendingEmailError;
}
