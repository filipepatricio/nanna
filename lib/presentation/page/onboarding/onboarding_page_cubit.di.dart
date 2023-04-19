import 'dart:async';

import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_page.dt.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_active_subscription_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/onboarding/onboarding_page_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class OnboardingPageCubit extends Cubit<OnboardingPageState> {
  OnboardingPageCubit(
    this._trackActivityUseCase,
    this._getActiveSubscriptionUseCase,
  ) : super(OnboardingPageState.idle());

  final TrackActivityUseCase _trackActivityUseCase;
  final GetActiveSubscriptionUseCase _getActiveSubscriptionUseCase;

  StreamSubscription? _activeSubscriptionSub;

  @override
  Future<void> close() async {
    await _activeSubscriptionSub?.cancel();
    await super.close();
  }

  Future<void> initialize() async {
    _trackActivityUseCase.trackEvent(AnalyticsEvent.onboardingStarted());

    await _setupSubscriptionListener();
  }

  void skip() => _trackActivityUseCase.trackEvent(AnalyticsEvent.onboardingSkipped());

  void setOnboardingCompleted() => _trackActivityUseCase.trackEvent(AnalyticsEvent.onboardingCompleted());

  void trackOnboardingPage(int index) {
    _trackActivityUseCase.trackPage(AnalyticsPage.onboarding(index));
  }

  Future<void> _setupSubscriptionListener() async {
    if (_activeSubscriptionSub != null) return;

    _activeSubscriptionSub = _getActiveSubscriptionUseCase.stream.distinct().listen((subscription) {
      emit(subscription.mapToState());
    });
  }
}

extension on ActiveSubscription {
  OnboardingPageState mapToState() {
    return map(
      free: (_) => OnboardingPageState.idle(),
      trial: (_) => OnboardingPageState.subscribed(),
      premium: (_) => OnboardingPageState.subscribed(),
      manualPremium: (_) => OnboardingPageState.subscribed(),
    );
  }
}
