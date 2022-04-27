import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_page.dt.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/initialize_attribution_use_case.di.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/request_tracking_permission_use_case.di.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.di.dart';
import 'package:better_informed_mobile/domain/onboarding/use_case/set_onboarding_seen_use_case.di.dart';
import 'package:better_informed_mobile/domain/push_notification/use_case/request_notification_permission_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/onboarding/onboarding_page_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class OnboardingPageCubit extends Cubit<OnboardingPageState> {
  final RequestNotificationPermissionUseCase _requestNotificationPermissionUseCase;
  final TrackActivityUseCase _trackActivityUseCase;
  final SetOnboardingSeenUseCase _setOnboardingSeenUseCase;
  final InitializeAttributionUseCase _initializeAttributionUseCase;
  final RequestTrackingPermissionUseCase _requestTrackingPermissionUseCase;

  OnboardingPageCubit(
    this._requestNotificationPermissionUseCase,
    this._trackActivityUseCase,
    this._setOnboardingSeenUseCase,
    this._initializeAttributionUseCase,
    this._requestTrackingPermissionUseCase,
  ) : super(OnboardingPageState.idle());

  Future<void> requestNotificationPermission() async {
    final hasGivenPermission = await _requestNotificationPermissionUseCase.call();
    if (hasGivenPermission) _trackPushNotificationConsentGiven();
  }

  void trackOnboardingPage(int index) => _trackActivityUseCase.trackPage(AnalyticsPage.onboarding(index));

  void trackOnboardingStarted() => _trackActivityUseCase.trackEvent(AnalyticsEvent.onboardingStarted());

  Future<void> setOnboardingCompleted() async {
    await _requestTrackingPermissionUseCase();
    await _initializeAttributionUseCase();
    _trackOnboardingCompleted();
    await _setOnboardingSeenUseCase();
  }

  void _trackPushNotificationConsentGiven() {
    _trackActivityUseCase.trackEvent(AnalyticsEvent.pushNotificationConsentGiven());
  }

  void _trackOnboardingCompleted() {
    _trackActivityUseCase.trackEvent(AnalyticsEvent.onboardingCompleted());
  }

  void trackOnboardingSkipped() {
    _trackActivityUseCase.trackEvent(AnalyticsEvent.onboardingSkipped());
  }
}
