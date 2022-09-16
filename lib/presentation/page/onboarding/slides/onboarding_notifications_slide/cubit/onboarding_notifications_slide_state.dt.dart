import 'package:better_informed_mobile/domain/push_notification/data/notification_preferences.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_notifications_slide_state.dt.freezed.dart';

@freezed
class OnboardingNotificationsSlideState with _$OnboardingNotificationsSlideState {
  @Implements<BuildState>()
  const factory OnboardingNotificationsSlideState.idle({required NotificationPreferences preferences}) =
      _OnboardingNotificationsSlideStateIdle;

  @Implements<BuildState>()
  const factory OnboardingNotificationsSlideState.loading() = _OnboardingNotificationsSlideStateLoading;

  const factory OnboardingNotificationsSlideState.error() = _OnboardingNotificationsSlideStateError;
}
