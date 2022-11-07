import 'dart:async';

import 'package:better_informed_mobile/domain/analytics/use_case/identify_analytics_user_use_case.di.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/initialize_attribution_use_case.di.dart';
import 'package:better_informed_mobile/domain/auth/use_case/is_signed_in_use_case.di.dart';
import 'package:better_informed_mobile/domain/categories/use_case/get_onboarding_categories_use_case.di.dart';
import 'package:better_informed_mobile/domain/exception/unauthorized_exception.dart';
import 'package:better_informed_mobile/domain/feature_flags/use_case/initialize_feature_flags_use_case.di.dart';
import 'package:better_informed_mobile/domain/networking/use_case/is_internet_connection_available_use_case.di.dart';
import 'package:better_informed_mobile/domain/onboarding/use_case/is_onboarding_seen_use_case.di.dart';
import 'package:better_informed_mobile/domain/release_notes/use_case/save_release_note_if_first_run_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/identify_purchases_user_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/initialize_purchases_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/entry/entry_page_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

const _individualInitTimeout = Duration(seconds: 5);

@injectable
class EntryPageCubit extends Cubit<EntryPageState> {
  EntryPageCubit(
    this._isSignedInUseCase,
    this._initializeFeatureFlagsUseCase,
    this._initializeAttributionUseCase,
    this._isOnboardingSeenUseCase,
    this._saveReleaseNoteIfFirstRunUseCase,
    this._isInternetConnectionAvailableUseCase,
    this._getOnboardingCategoriesUseCase,
    this._identifyAnalyticsUserUseCase,
    this._initializePurchasesUseCase,
    this._identifyPurchasesUserUseCase,
  ) : super(EntryPageState.idle());

  final IsSignedInUseCase _isSignedInUseCase;
  final InitializeFeatureFlagsUseCase _initializeFeatureFlagsUseCase;
  final InitializeAttributionUseCase _initializeAttributionUseCase;
  final IsOnboardingSeenUseCase _isOnboardingSeenUseCase;
  final SaveReleaseNoteIfFirstRunUseCase _saveReleaseNoteIfFirstRunUseCase;
  final IsInternetConnectionAvailableUseCase _isInternetConnectionAvailableUseCase;
  final GetOnboardingCategoriesUseCase _getOnboardingCategoriesUseCase;
  final IdentifyAnalyticsUserUseCase _identifyAnalyticsUserUseCase;
  final InitializePurchasesUseCase _initializePurchasesUseCase;
  final IdentifyPurchasesUserUseCase _identifyPurchasesUserUseCase;

  bool? _isConnectionAvailable;

  StreamSubscription? _connectionStateSubscription;

  @override
  Future<void> close() async {
    await _connectionStateSubscription?.cancel();
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
    await _initializePurchasesUseCase()._withTimeout('Purchases configuration timeout');

    final signedIn = await _isSignedInUseCase();

    if (!signedIn) {
      emit(EntryPageState.notSignedIn());
      return;
    }

    await _initializeSignedInUser();

    await _connectionStateSubscription?.cancel();
    _connectionStateSubscription = _isInternetConnectionAvailableUseCase.stream.listen((isConnectionAvailable) {
      _isConnectionAvailable = isConnectionAvailable;
      _initializeSignedInUser();
    });
  }

  Future<void> _initializeSignedInUser() async {
    _isConnectionAvailable ??= await _isInternetConnectionAvailableUseCase()._withTimeout('Connectivity check timeout');
    if (!_isConnectionAvailable!) return;

    await _connectionStateSubscription?.cancel();

    try {
      await _initializeFeatureFlagsUseCase();
      await _identifyAnalyticsUserUseCase()._withTimeout('Identyfying user for analytics timeout');
      await _identifyPurchasesUserUseCase()._withTimeout('Identyfying user for purchases timeout');
    } on UnauthorizedException {
      emit(EntryPageState.notSignedIn());
      return;
    }

    final onboardingSeen = await _isOnboardingSeenUseCase();
    if (onboardingSeen) {
      await _initializeAttributionUseCase();
    } else {
      await _preFetchCategories();
      emit(EntryPageState.onboarding());
      return;
    }

    emit(EntryPageState.alreadySignedIn());
  }

  Future<void> _preFetchCategories() async {
    try {
      await _getOnboardingCategoriesUseCase();
    } catch (e, s) {
      Fimber.e('Pre-fetching onboarding categories failed', ex: e, stacktrace: s);
    }
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
