import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_page_state.dt.freezed.dart';

@freezed
class OnboardingPageState with _$OnboardingPageState {
  factory OnboardingPageState.idle() = _OnboardingPageStateIdle;
}
