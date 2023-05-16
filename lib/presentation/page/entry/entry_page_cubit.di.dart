import 'dart:async';

import 'package:better_informed_mobile/domain/analytics/use_case/identify_analytics_user_use_case.di.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/initialize_attribution_use_case.di.dart';
import 'package:better_informed_mobile/domain/auth/use_case/is_signed_in_use_case.di.dart';
import 'package:better_informed_mobile/domain/exception/unauthorized_exception.dart';
import 'package:better_informed_mobile/domain/feature_flags/use_case/initialize_feature_flags_use_case.di.dart';
import 'package:better_informed_mobile/domain/release_notes/use_case/save_release_note_if_first_run_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_active_subscription_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/initialize_purchases_use_case.di.dart';
import 'package:better_informed_mobile/domain/user/use_case/is_guest_mode_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/entry/entry_page_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

const _individualInitTimeout = Duration(seconds: 10);

@injectable
class EntryPageCubit extends Cubit<EntryPageState> {
  EntryPageCubit(
    this._isSignedInUseCase,
    this._initializeFeatureFlagsUseCase,
    this._initializeAttributionUseCase,
    this._saveReleaseNoteIfFirstRunUseCase,
    this._identifyAnalyticsUserUseCase,
    this._initializePurchasesUseCase,
    this._getActiveSubscriptionUseCase,
    this._isGuestModeUseCase,
  ) : super(EntryPageState.idle());

  final IsSignedInUseCase _isSignedInUseCase;
  final InitializeFeatureFlagsUseCase _initializeFeatureFlagsUseCase;
  final InitializeAttributionUseCase _initializeAttributionUseCase;
  final SaveReleaseNoteIfFirstRunUseCase _saveReleaseNoteIfFirstRunUseCase;
  final IdentifyAnalyticsUserUseCase _identifyAnalyticsUserUseCase;
  final InitializePurchasesUseCase _initializePurchasesUseCase;
  final GetActiveSubscriptionUseCase _getActiveSubscriptionUseCase;
  final IsGuestModeUseCase _isGuestModeUseCase;

  @override
  Future<void> close() async {
    await super.close();
  }

  Future<void> initialize() async {
    emit(EntryPageState.idle());

    try {
      await _initialize();
    } catch (e, s) {
      Fimber.e('App initialization failed', ex: e, stacktrace: s);
      emit(EntryPageState.error());
    }
  }

  Future<void> _initialize() async {
    await _saveReleaseNoteIfFirstRunUseCase();

    await _initializePurchasesUseCase()._withTimeout('Identyfying user for purchases timeout');

    final signedIn = await _isSignedInUseCase();
    if (signedIn) {
      await _initializeSignedInUser();
      return;
    }

    final activeSubscription = await _getActiveSubscriptionUseCase();
    final isGuestMode = await _isGuestModeUseCase();
    emit(activeSubscription.mapToState(isGuestMode));
  }

  Future<void> _initializeSignedInUser() async {
    try {
      await _initializeFeatureFlagsUseCase();
      await _identifyAnalyticsUserUseCase()._withTimeout('Identyfying user for analytics timeout');
    } on UnauthorizedException {
      emit(EntryPageState.notSignedIn());
      return;
    }

    _initializeAttributionUseCase().ignore();
    emit(EntryPageState.signedIn());
  }
}

extension _FutureExtension<T> on Future<T> {
  Future<T> _withTimeout(String timeoutMessage) {
    return timeout(
      _individualInitTimeout,
      onTimeout: () => Future.error(
        Exception(timeoutMessage),
      ),
    );
  }
}

extension on ActiveSubscription {
  EntryPageState mapToState(bool isGuestMode) {
    return map(
      free: (_) => isGuestMode ? EntryPageState.guest() : EntryPageState.notSignedIn(),
      trial: (_) => EntryPageState.subscribed(),
      premium: (_) => EntryPageState.subscribed(),
      manualPremium: (_) => EntryPageState.subscribed(),
    );
  }
}
