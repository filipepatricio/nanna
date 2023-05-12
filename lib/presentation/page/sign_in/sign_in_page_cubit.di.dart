import 'dart:async';

import 'package:better_informed_mobile/core/util/app_link.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/initialize_attribution_use_case.di.dart';
import 'package:better_informed_mobile/domain/auth/auth_exception.dt.dart';
import 'package:better_informed_mobile/domain/auth/data/exceptions.dart';
import 'package:better_informed_mobile/domain/auth/use_case/send_magic_link_use_case.di.dart';
import 'package:better_informed_mobile/domain/auth/use_case/sign_in_use_case.di.dart';
import 'package:better_informed_mobile/domain/auth/use_case/subscribe_for_magic_link_token_use_case.di.dart';
import 'package:better_informed_mobile/domain/feature_flags/use_case/initialize_feature_flags_use_case.di.dart';
import 'package:better_informed_mobile/domain/general/is_email_valid_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/force_subscription_status_sync_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/has_active_subscription_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/initialize_purchases_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/restore_purchase_use_case.di.dart';
import 'package:better_informed_mobile/domain/synchronization/use_case/run_initial_bookmark_sync_use_case.di.dart';
import 'package:better_informed_mobile/domain/user/use_case/clear_guest_mode_use_case.di.dart';
import 'package:better_informed_mobile/domain/user/use_case/get_user_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/sign_in/sign_in_page_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

typedef _SignInFunction = Future<void> Function();

@injectable
class SignInPageCubit extends Cubit<SignInPageState> {
  SignInPageCubit(
    this._isEmailValidUseCase,
    this._sendMagicLinkUseCase,
    this._subscribeForMagicLinkTokenUseCase,
    this._initializeFeatureFlagsUseCase,
    this._initializeAttributionUseCase,
    this._initializePurchasesUseCase,
    this._restorePurchaseUseCase,
    this._signInUseCase,
    this._runIntitialBookmarkSyncUseCase,
    this._getUserUseCase,
    this._hasActiveSubscriptionUseCase,
    this._forceSubscriptionStatusSyncUseCase,
    this._clearGuestModeUseCase,
  ) : super(SignInPageState.idle(false));

  final IsEmailValidUseCase _isEmailValidUseCase;
  final SendMagicLinkUseCase _sendMagicLinkUseCase;
  final SubscribeForMagicLinkTokenUseCase _subscribeForMagicLinkTokenUseCase;
  final InitializeFeatureFlagsUseCase _initializeFeatureFlagsUseCase;
  final InitializeAttributionUseCase _initializeAttributionUseCase;
  final InitializePurchasesUseCase _initializePurchasesUseCase;
  final RestorePurchaseUseCase _restorePurchaseUseCase;
  final SignInUseCase _signInUseCase;
  final RunIntitialBookmarkSyncUseCase _runIntitialBookmarkSyncUseCase;
  final GetUserUseCase _getUserUseCase;
  final HasActiveSubscriptionUseCase _hasActiveSubscriptionUseCase;
  final ForceSubscriptionStatusSyncUseCase _forceSubscriptionStatusSyncUseCase;
  final ClearGuestModeUseCase _clearGuestModeUseCase;

  StreamSubscription? _magicLinkSubscription;
  late String _email;

  @override
  Future<void> close() async {
    await _magicLinkSubscription?.cancel();
    return super.close();
  }

  Future<void> initialize() async {
    await _subscribeForMagicLink();
  }

  void updateEmail(String email) {
    _email = email;
    final valid = _isEmailValidUseCase(email);
    emit(SignInPageState.idle(valid));
  }

  Future<void> sendMagicLink() async {
    emit(SignInPageState.processing());
    try {
      await _sendMagicLinkUseCase(_email);
      emit(SignInPageState.magicLink(_email));
    } catch (_) {
      emit(SignInPageState.generalError());
      emit(SignInPageState.idle(false));
    }
  }

  Future<void> signInWithLinkedin() async {
    try {
      emit(SignInPageState.processingLinkedIn());
      await _signInWithOAuthProvider(_signInUseCase.withLinkeding);
    } on SignInAbortedException {
      // Do nothing
    } catch (e, s) {
      Fimber.e('Signing in with linkedin failed', ex: e, stacktrace: s);
      emit(SignInPageState.generalError());
    } finally {
      emit(SignInPageState.idle(false));
    }
  }

  Future<void> signInWithApple() async {
    emit(SignInPageState.processing());
    await _signInWithOAuthProvider(_signInUseCase.withApple);
  }

  Future<void> signInWithGoogle() async {
    emit(SignInPageState.processing());
    await _signInWithOAuthProvider(_signInUseCase.withGoogle);
  }

  void closeMagicLinkView() {
    emit(SignInPageState.idle(true));
  }

  Future<void> cancelLinkedInSignIn() async {
    await Future.delayed(const Duration(seconds: 5));

    state.mapOrNull(
      processingLinkedIn: (_) => emit(SignInPageState.idle(true)),
    );
  }

  Future<void> restorePurchase() async {
    emit(const SignInPageState.restoringPurchase());
    await _restorePurchaseUseCase();
  }

  Future<void> redeemOfferCode() async {
    emit(const SignInPageState.redeemingCode());
    await openUrlWithAnyApp(
      appleCodeRedemptionLink,
      (error, stackTrace) => Fimber.e('Error launching code redemption sheet', ex: error, stacktrace: stackTrace),
    );
  }

  Future<void> _signInWithOAuthProvider(_SignInFunction signIn) async {
    try {
      await signIn();
      emit(SignInPageState.processing());
      await _finishSignIn();
    } on SignInAbortedException {
      // Do nothing
    } on AuthException catch (authException) {
      _resolveAuthException(authException);
    } catch (e, s) {
      Fimber.e('Signing in with provider failed', ex: e, stacktrace: s);
      emit(SignInPageState.generalError());
    } finally {
      emit(SignInPageState.idle(false));
    }
  }

  Future<void> _subscribeForMagicLink() async {
    _magicLinkSubscription = _subscribeForMagicLinkTokenUseCase().listen((token) async {
      await signInWithMagicLink(token);
    });
  }

  @visibleForTesting
  Future<void> signInWithMagicLink(String token) async {
    emit(SignInPageState.processing());

    try {
      await _signInUseCase.withMagicLink(token);
      await _finishSignIn();
    } on AuthException catch (authException) {
      _resolveAuthException(authException, token);
    } catch (e, s) {
      Fimber.e('Signing in with magic link failed', ex: e, stacktrace: s);
      emit(SignInPageState.generalError());
    } finally {
      emit(SignInPageState.idle(false));
    }
  }

  Future<void> _finishSignIn() async {
    await _initializeFeatureFlagsUseCase();
    await _initializePurchasesUseCase();
    await _getUserUseCase();

    if (await _hasActiveSubscriptionUseCase()) {
      await _forceSubscriptionStatusSyncUseCase();
    }

    await _clearGuestModeUseCase();

    _initializeAttributionUseCase().ignore();
    _runIntitialBookmarkSyncUseCase().ignore();

    //TODO: Need to do something to reset the whole navigation stack if user is coming from guest mode

    emit(SignInPageState.success());
  }

  void _resolveAuthException(AuthException authException, [String? magicLinkToken]) {
    authException.map(
      unauthorized: (_) => emit(SignInPageState.unauthorizedError()),
      unknown: (_) => emit(SignInPageState.generalError()),
    );
  }
}
