import 'package:better_informed_mobile/domain/categories/data/category_preference.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_preference_follow_button_state.dt.freezed.dart';

@Freezed(toJson: false)
class CategoryPreferenceFollowButtonState with _$CategoryPreferenceFollowButtonState {
  @Implements<BuildState>()
  const factory CategoryPreferenceFollowButtonState.loading() = CategoryPreferenceFollowButtonStateLoading;

  @Implements<BuildState>()
  factory CategoryPreferenceFollowButtonState.categoryPreferenceLoaded(
    CategoryPreference categoryPreference,
  ) = CategoryPreferenceFollowButtonStateLoaded;

  const factory CategoryPreferenceFollowButtonState.showMessage(String message) =
      CategoryPreferenceFollowButtonStateShowMessage;
}
