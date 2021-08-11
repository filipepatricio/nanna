import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_main_state.freezed.dart';

@freezed
class SettingsMainState with _$SettingsMainState {
  const factory SettingsMainState.init() = SettingsMainStateInit;

  const factory SettingsMainState.loading() = SettingsMainStateLoading;

  const factory SettingsMainState.signOut() = SettingsMainStateSignOut;
}
