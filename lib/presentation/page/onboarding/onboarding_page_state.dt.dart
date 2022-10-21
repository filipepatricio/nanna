import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_page_state.dt.freezed.dart';

@Freezed(toJson: false)
class OnboardingPageState with _$OnboardingPageState {
  factory OnboardingPageState.idle() = _OnboardingPageStateIdle;

  factory OnboardingPageState.jumpToTrackingPage() = _OnboardingPageStateJumpToTrackingPage;
}
