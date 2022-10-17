import 'package:better_informed_mobile/presentation/page/onboarding/slides/onboarding_categories_slide/onboarding_categories_slide_data.dt.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_categories_slide_state.dt.freezed.dart';

@Freezed(toJson: false)
class OnboardingCategoriesSlideState with _$OnboardingCategoriesSlideState {
  @Implements<BuildState>()
  const factory OnboardingCategoriesSlideState.idle({required OnboardingCategoriesSlideData data}) =
      _OnboardingCategoriesSlideStateIdle;

  @Implements<BuildState>()
  const factory OnboardingCategoriesSlideState.loading() = _OnboardingCategoriesSlideStateLoading;

  const factory OnboardingCategoriesSlideState.error() = _OnboardingCategoriesSlideStateError;
}
