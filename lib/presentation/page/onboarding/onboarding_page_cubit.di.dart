import 'dart:async';

import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_page.dt.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/initialize_attribution_use_case.di.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/request_tracking_permission_use_case.di.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.di.dart';
import 'package:better_informed_mobile/domain/categories/data/category.dart';
import 'package:better_informed_mobile/domain/categories/use_case/get_onboarding_categories_use_case.di.dart';
import 'package:better_informed_mobile/domain/onboarding/data/onboarding_version.dart';
import 'package:better_informed_mobile/domain/onboarding/use_case/get_seen_onboarding_version_use_case.di.dart';
import 'package:better_informed_mobile/domain/onboarding/use_case/set_onboarding_seen_use_case.di.dart';
import 'package:better_informed_mobile/domain/push_notification/use_case/request_notification_permission_use_case.di.dart';
import 'package:better_informed_mobile/domain/user/use_case/update_preferred_categories_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/onboarding/onboarding_page_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

@injectable
class OnboardingPageCubit extends Cubit<OnboardingPageState> {
  final RequestNotificationPermissionUseCase _requestNotificationPermissionUseCase;
  final TrackActivityUseCase _trackActivityUseCase;
  final SetOnboardingSeenUseCase _setOnboardingSeenUseCase;
  final InitializeAttributionUseCase _initializeAttributionUseCase;
  final RequestTrackingPermissionUseCase _requestTrackingPermissionUseCase;
  final GetSeenOnboardingVersionUseCase _getSeenOnboardingVersionUseCase;
  final GetOnboardingCategoriesUseCase _getCurrentOnboardingCategoriesUseCase;
  final UpdatePreferredCategoriesUseCase _updatePreferredCategoriesUseCase;

  late final StreamSubscription _onboardingCategoriesStreamSubscription;

  List<Category> _categories = [];

  OnboardingPageCubit(
    this._requestNotificationPermissionUseCase,
    this._trackActivityUseCase,
    this._setOnboardingSeenUseCase,
    this._initializeAttributionUseCase,
    this._requestTrackingPermissionUseCase,
    this._getSeenOnboardingVersionUseCase,
    this._getCurrentOnboardingCategoriesUseCase,
    this._updatePreferredCategoriesUseCase,
  ) : super(OnboardingPageState.idle());

  Future<void> initialize() async {
    _onboardingCategoriesStreamSubscription =
        _getCurrentOnboardingCategoriesUseCase.stream.listen(_onboardingCategoriesListener);
    _trackActivityUseCase.trackEvent(AnalyticsEvent.onboardingStarted());

    final lastSeenOnboardingVersion = await _getSeenOnboardingVersionUseCase();
    if (lastSeenOnboardingVersion == null) {
      trackOnboardingPage(0);
    } else if (lastSeenOnboardingVersion == OnboardingVersion.v1) {
      emit(OnboardingPageState.jumpToTrackingPage());
    }
  }

  void _onboardingCategoriesListener(List<Category> categories) {
    _categories = categories;
  }

  Future<void> requestNotificationPermission() async {
    final hasGivenPermission = await _requestNotificationPermissionUseCase.call();
    if (hasGivenPermission) _trackPushNotificationConsentGiven();
  }

  Future<void> setOnboardingCompleted() async {
    await _requestTrackingPermissionUseCase();
    await _initializeAttributionUseCase();
    _trackOnboardingCompleted();
    await _setOnboardingSeenUseCase();
    await _setPreferredCategories();
  }

  Future<void> _setPreferredCategories() async {
    if (_categories.isNotEmpty) {
      try {
        await _updatePreferredCategoriesUseCase(_categories);
      } catch (e, s) {
        Fimber.e('Updating preferred categories failed', ex: e, stacktrace: s);
      }
    }
  }

  void trackOnboardingPage(int index) {
    _trackActivityUseCase.trackPage(AnalyticsPage.onboarding(index));
  }

  void trackOnboardingSkipped() {
    _trackActivityUseCase.trackEvent(AnalyticsEvent.onboardingSkipped());
  }

  void _trackPushNotificationConsentGiven() {
    _trackActivityUseCase.trackEvent(AnalyticsEvent.pushNotificationConsentGiven());
  }

  void _trackOnboardingCompleted() {
    _trackActivityUseCase.trackEvent(AnalyticsEvent.onboardingCompleted());
  }

  @override
  Future<void> close() async {
    await super.close();
    await _onboardingCategoriesStreamSubscription.cancel();
  }
}
