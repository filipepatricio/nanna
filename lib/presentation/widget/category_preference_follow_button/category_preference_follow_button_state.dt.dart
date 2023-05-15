import 'package:better_informed_mobile/domain/user/data/category_preference.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_preference_follow_button_state.dt.freezed.dart';

@Freezed(toJson: false)
class CategoryPreferenceFollowButtonState with _$CategoryPreferenceFollowButtonState {
  @Implements<BuildState>()
  const factory CategoryPreferenceFollowButtonState.loading() = _CategoryPreferenceFollowButtonStateLoading;

  @Implements<BuildState>()
  const factory CategoryPreferenceFollowButtonState.guest() = _CategoryPreferenceFollowButtonStateGuest;

  @Implements<BuildState>()
  factory CategoryPreferenceFollowButtonState.categoryPreferenceLoaded(
    CategoryPreference categoryPreference,
  ) = _CategoryPreferenceFollowButtonStateLoaded;

  const factory CategoryPreferenceFollowButtonState.error() = _CategoryPreferenceFollowButtonStateError;
}
