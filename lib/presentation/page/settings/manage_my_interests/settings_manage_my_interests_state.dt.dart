import 'package:better_informed_mobile/domain/user/data/category_preference.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_manage_my_interests_state.dt.freezed.dart';

@Freezed(toJson: false)
class SettingsManageMyInterestsState with _$SettingsManageMyInterestsState {
  @Implements<BuildState>()
  const factory SettingsManageMyInterestsState.loading() = SettingsManageMyInterestsStateLoading;

  @Implements<BuildState>()
  factory SettingsManageMyInterestsState.myInterestsSettingsLoaded(
    List<CategoryPreference> categoryPreferences,
  ) = SettingsManageMyInterestsStateLoaded;

  @Implements<BuildState>()
  const factory SettingsManageMyInterestsState.error(
    String title,
    String message,
  ) = SettingsManageMyInterestsStateError;

  const factory SettingsManageMyInterestsState.showMessage(String message) = SettingsManageMyInterestsStateShowMessage;
}
