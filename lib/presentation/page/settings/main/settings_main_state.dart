import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_main_state.freezed.dart';

@freezed
class SettingsMainState with _$SettingsMainState {
  @Implements<BuildState>()
  const factory SettingsMainState.init() = SettingsMainStateInit;

  @Implements<BuildState>()
  const factory SettingsMainState.loading() = SettingsMainStateLoading;

  factory SettingsMainState.sendingEmailError() = _SettingsMainStateSendingEmailError;
}
