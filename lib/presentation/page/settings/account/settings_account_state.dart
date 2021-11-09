import 'package:better_informed_mobile/presentation/page/settings/account/settings_account_data.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_account_state.freezed.dart';

@freezed
class SettingsAccountState with _$SettingsAccountState {
  @Implements(BuildState)
  const factory SettingsAccountState.loading() = SettingsAccountStateLoading;

  @Implements(BuildState)
  const factory SettingsAccountState.idle(SettingsAccountData data) = SettingsAccountStateLoaded;

  @Implements(BuildState)
  const factory SettingsAccountState.updating(SettingsAccountData data) = SettingsAccountStateUpdating;

  const factory SettingsAccountState.showMessage(String message) = SettingsAccountStateShowMessage;
}
