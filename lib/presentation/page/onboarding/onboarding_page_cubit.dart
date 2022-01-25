import 'package:better_informed_mobile/domain/analytics/analytics_event.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_page.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.dart';
import 'package:better_informed_mobile/domain/onboarding/use_case/set_onboarding_seen_use_case.dart';
import 'package:better_informed_mobile/domain/push_notification/use_case/request_notification_permission_use_case.dart';
import 'package:better_informed_mobile/presentation/page/onboarding/onboarding_page_state.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class OnboardingPageCubit extends Cubit<OnboardingPageState> {
  final RequestNotificationPermissionUseCase _requestNotificationPermissionUseCase;
  final TrackActivityUseCase _trackActivityUseCase;
  final SetOnboardingSeenUseCase _setOnboardingSeenUseCase;

  OnboardingPageCubit(
      this._requestNotificationPermissionUseCase, this._trackActivityUseCase, this._setOnboardingSeenUseCase)
      : super(OnboardingPageState.idle());

  Future<void> requestNotificationPermission() async {
    final hasGivenPermission = await _requestNotificationPermissionUseCase.call();
    if (hasGivenPermission) _trackPushNotificationConsentGiven();
  }

  void trackOnboardingPage(int index) => _trackActivityUseCase.trackPage(AnalyticsPage.onboarding(index));

  void trackOnboardingStarted() => _trackActivityUseCase.trackEvent(AnalyticsEvent.onboardingStarted());

  Future<void> setOnboardingCompleted(bool isSkipped) async {
    if (isSkipped) {
      _trackOnboardingSkipped();
    } else {
      _trackOnboardingCompleted();
    }
    await _setOnboardingSeenUseCase.call();
  }

  void _trackPushNotificationConsentGiven() =>
      _trackActivityUseCase.trackEvent(AnalyticsEvent.pushNotificationConsentGiven());

  void _trackOnboardingCompleted() => _trackActivityUseCase.trackEvent(AnalyticsEvent.onboardingCompleted());

  void _trackOnboardingSkipped() => _trackActivityUseCase.trackEvent(AnalyticsEvent.onboardingSkipped());
}
