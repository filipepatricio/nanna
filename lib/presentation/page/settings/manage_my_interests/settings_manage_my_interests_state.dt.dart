import 'package:better_informed_mobile/domain/categories/data/category_preference.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../util/cubit_hooks.dart';

part 'settings_manage_my_interests_state.dt.freezed.dart';

@freezed
class SettingsManageMyInterestsState with _$SettingsManageMyInterestsState {
  @Implements<BuildState>()
  const factory SettingsManageMyInterestsState.loading() = SettingsManageMyInterestsStateLoading;

  @Implements<BuildState>()
  factory SettingsManageMyInterestsState.myInterestsSettingsLoaded(
    List<CategoryPreference> categoryPreferences,
  ) = SettingsManageMyInterestsStateLoaded;
}
