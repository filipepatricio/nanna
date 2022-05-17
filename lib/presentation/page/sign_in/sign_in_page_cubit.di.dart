import 'dart:async';

import 'package:better_informed_mobile/domain/analytics/use_case/initialize_attribution_use_case.di.dart';
import 'package:better_informed_mobile/domain/auth/auth_exception.dt.dart';
import 'package:better_informed_mobile/domain/auth/data/exceptions.dart';
import 'package:better_informed_mobile/domain/auth/use_case/send_magic_link_use_case.di.dart';
import 'package:better_informed_mobile/domain/auth/use_case/sign_in_with_default_provider_use_case.di.dart';
import 'package:better_informed_mobile/domain/auth/use_case/sign_in_with_linkedin_use_case.di.dart';
import 'package:better_informed_mobile/domain/auth/use_case/sign_in_with_magic_link_token_use_case.di.dart';
import 'package:better_informed_mobile/domain/auth/use_case/subscribe_for_magic_link_token_use_case.di.dart';
import 'package:better_informed_mobile/domain/feature_flags/use_case/initialize_feature_flags_use_case.di.dart';
import 'package:better_informed_mobile/domain/general/is_email_valid_use_case.di.dart';
import 'package:better_informed_mobile/domain/onboarding/use_case/is_onboarding_seen_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/sign_in/sign_in_page_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

typedef _SignInFunction = Future<void> Function();

@injectable
class SignInPageCubit extends Cubit<SignInPageState> {
  SignInPageCubit(
    this._isEmailValidUseCase,
    this._sendMagicLinkUseCase,
    this._signInWithDefaultProviderUseCase,
    this._subscribeForMagicLinkTokenUseCase,
    this._signInWithMagicLinkTokenUseCase,
    this._isOnboardingSeenUseCase,
    this._initializeFeatureFlagsUseCase,
    this._initializeAttributionUseCase,
  ) : super(SignInPageState.idle(false));

  final IsEmailValidUseCase _isEmailValidUseCase;
  final SendMagicLinkUseCase _sendMagicLinkUseCase;
  final SignInWithDefaultProviderUseCase _signInWithDefaultProviderUseCase;
  final SubscribeForMagicLinkTokenUseCase _subscribeForMagicLinkTokenUseCase;
  final SignInWithMagicLinkTokenUseCase _signInWithMagicLinkTokenUseCase;
  final IsOnboardingSeenUseCase _isOnboardingSeenUseCase;
  final InitializeFeatureFlagsUseCase _initializeFeatureFlagsUseCase;
  final InitializeAttributionUseCase _initializeAttributionUseCase;
  final SignInWithLinkedinUseCase _signInWithLinkedinUseCase;

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
    await _signInWithOAuthProvider(_signInWithLinkedinUseCase);
  }

  Future<void> signInWithPlatformProvider() async {
    await _signInWithOAuthProvider(_signInWithDefaultProviderUseCase);
  }

  void closeMagicLinkView() {
    emit(SignInPageState.idle(true));
  }

  Future<void> _signInWithOAuthProvider(_SignInFunction signIn) async {
    emit(SignInPageState.processing());
    try {
      await signIn();
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
      await _signInWithMagicLink(token);
    });
  }

  Future<void> _signInWithMagicLink(String token) async {
    emit(SignInPageState.processing());

    try {
      await _signInWithMagicLinkTokenUseCase(token);
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

    final isOnboardingSeen = await _isOnboardingSeenUseCase();
    if (isOnboardingSeen) {
      await _initializeAttributionUseCase();
    }

    emit(SignInPageState.success(isOnboardingSeen));
  }

  void _resolveAuthException(AuthException authException, [String? magicLinkToken]) {
    authException.map(
      noMemberAccess: (state) => emit(SignInPageState.noMemberAccess(state.credentials)),
      unknown: (_) => emit(SignInPageState.generalError()),
    );
  }
}
