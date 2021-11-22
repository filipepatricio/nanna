import 'package:better_informed_mobile/domain/analytics/analytics_event.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_page.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.dart';
import 'package:better_informed_mobile/domain/push_notification/use_case/request_notification_permission_use_case.dart';
import 'package:better_informed_mobile/presentation/page/onboarding/onboarding_page_state.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class OnboardingPageCubit extends Cubit<OnboardingPageState> {
  final RequestNotificationPermissionUseCase _requestNotificationPermissionUseCase;
  final TrackActivityUseCase _trackActivityUseCase;

  OnboardingPageCubit(
    this._requestNotificationPermissionUseCase,
    this._trackActivityUseCase,
  ) : super(OnboardingPageState.idle());

  Future<void> requestNotificationPermission() async {
    final hasGivenPermission = await _requestNotificationPermissionUseCase.call();
    if (hasGivenPermission) _trackPushNotificationConsentGiven();
  }

  void trackOnboardingPage(int index) => _trackActivityUseCase.trackPage(AnalyticsPage.onboarding(index));

  void _trackPushNotificationConsentGiven() =>
      _trackActivityUseCase.trackEvent(AnalyticsEvent.pushNotificationConsentGiven());

  void trackOnboardingStarted() => _trackActivityUseCase.trackEvent(AnalyticsEvent.onboardingStarted());

  void trackOnboardingCompleted() => _trackActivityUseCase.trackEvent(AnalyticsEvent.onboardingCompleted());

  void trackOnboardingSkipped() => _trackActivityUseCase.trackEvent(AnalyticsEvent.onboardingSkipped());
}
