import 'package:better_informed_mobile/presentation/page/settings/account/settings_account_data.dt.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_account_state.dt.freezed.dart';

@Freezed(toJson: false)
class SettingsAccountState with _$SettingsAccountState {
  @Implements<BuildState>()
  const factory SettingsAccountState.loading() = SettingsAccountStateLoading;

  @Implements<BuildState>()
  const factory SettingsAccountState.idle(SettingsAccountData original, SettingsAccountData data) =
      SettingsAccountStateLoaded;

  @Implements<BuildState>()
  const factory SettingsAccountState.updating(SettingsAccountData original, SettingsAccountData data) =
      SettingsAccountStateUpdating;

  @Implements<BuildState>()
  const factory SettingsAccountState.guest() = SettingsAccountStateGuest;

  @Implements<BuildState>()
  const factory SettingsAccountState.error() = SettingsAccountStateError;

  @Implements<BuildState>()
  const factory SettingsAccountState.offline() = SettingsAccountStateOffline;

  const factory SettingsAccountState.showMessage(String message) = SettingsAccountStateShowMessage;
}
