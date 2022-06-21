import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'onboarding_categories_slide_data.dt.dart';

part 'onboarding_categories_slide_state.dt.freezed.dart';

@freezed
class OnboardingCategoriesSlideState with _$OnboardingCategoriesSlideState {
  @Implements<BuildState>()
  const factory OnboardingCategoriesSlideState.idle({required OnboardingCategoriesSlideData data}) =
      _OnboardingCategoriesSlideStateIdle;

  @Implements<BuildState>()
  const factory OnboardingCategoriesSlideState.loading() = _OnboardingCategoriesSlideStateLoading;

  const factory OnboardingCategoriesSlideState.error() = _OnboardingCategoriesSlideStateError;
}
